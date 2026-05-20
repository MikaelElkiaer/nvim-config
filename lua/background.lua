vim.g.config_updated = false
vim.g.git_updates_available = false
vim.g.lockfile_unapplied = false

local function check_git_updates()
  local config_path = vim.fn.stdpath("config")
  vim.system({ "git", "fetch" }, { cwd = config_path }, function(obj)
    if obj.code ~= 0 then
      return
    end
    vim.system({ "git", "rev-list", "--count", "HEAD..@{u}" }, { cwd = config_path }, function(obj2)
      if obj2.code == 0 then
        local count = tonumber(obj2.stdout:match("%d+"))
        if count and count > 0 and not vim.g.git_updates_available then
          vim.g.git_updates_available = true
          vim.schedule(function()
            vim.notify("Config has " .. count .. " un-pulled changes", vim.log.levels.INFO, { title = "Config Update" })
          end)
        end
      end
    end)
  end)
end

local function check_lockfile_applied()
  local current_packs = vim.pack.get(nil, { info = false })
  local count = #current_packs
  if count == 0 then
    return
  end

  local checked = 0
  local found_unapplied = false

  for _, pack in ipairs(current_packs) do
    vim.system({ "git", "rev-parse", "HEAD" }, { cwd = pack.path }, function(obj)
      checked = checked + 1
      if not found_unapplied then
        if obj.code ~= 0 then
          found_unapplied = true
        else
          local disk_rev = obj.stdout:match("%w+")
          if disk_rev ~= pack.rev then
            found_unapplied = true
          end
        end
      end

      if checked == count then
        if found_unapplied then
          if not vim.g.lockfile_unapplied then
            vim.g.lockfile_unapplied = true
            vim.schedule(function()
              vim.notify("Plugin lockfile is not fully applied", vim.log.levels.WARN, { title = "Config Update" })
            end)
          end
        else
          vim.g.lockfile_unapplied = false
        end
      end
    end)
  end
end

vim.schedule(function()
  local function setup_periodic_checks()
    local timer = vim.uv.new_timer()
    if not timer then
      return
    end

    local function run_checks()
      check_git_updates()
      check_lockfile_applied()
    end

    -- Run once after 5 seconds, then every 1 hour
    timer:start(5000, 3600000, vim.schedule_wrap(run_checks))
  end

  local function watch_config_dir()
    local config_path = vim.fn.stdpath("config")
    local fswatch = vim.uv.new_fs_event()
    if not fswatch then
      vim.notify(
        "Failed to create filesystem watcher for config directory.",
        vim.log.levels.ERROR,
        { title = "Config Watcher" }
      )
      return
    end
    local timer = vim.uv.new_timer()
    if not timer then
      vim.notify("Failed to create timer for config watcher.", vim.log.levels.ERROR, { title = "Config Watcher" })
      fswatch:close()
      return
    end

    vim.uv.fs_event_start(fswatch, config_path, { recursive = true }, function(err, filename, _)
      -- 1. If we already notified, immediately drop all future events
      if err or not filename or vim.g.config_updated then
        return
      end

      if filename:match("^%.git[/\\]") or filename == ".git" then
        return
      end

      timer:start(200, 0, function()
        -- Double-check in case the timer was already queued
        if vim.g.config_updated then
          return
        end

        vim.system({ "git", "check-ignore", "-q", filename }, { cwd = config_path }, function(obj)
          -- 2. If ignored, or if another async check beat us to the punch, abort
          if obj.code == 0 or vim.g.config_updated then
            return
          end

          -- 3. Lock it down immediately so no other events can trigger
          vim.g.config_updated = true

          vim.schedule(function()
            -- 4. Turn off the filesystem watcher entirely to save resources
            if not fswatch:is_closing() then
              fswatch:stop()
            end
          end)
        end)
      end)
    end)
  end

  setup_periodic_checks()
  watch_config_dir()
end)
