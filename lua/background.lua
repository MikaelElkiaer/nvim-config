vim.schedule(function()
  local has_notified = false

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
      if err or not filename or has_notified then
        return
      end

      if filename:match("^%.git[/\\]") or filename == ".git" then
        return
      end

      timer:start(200, 0, function()
        -- Double-check in case the timer was already queued
        if has_notified then
          return
        end

        vim.system({ "git", "check-ignore", "-q", filename }, { cwd = config_path }, function(obj)
          -- 2. If ignored, or if another async check beat us to the punch, abort
          if obj.code == 0 or has_notified then
            return
          end

          -- 3. Lock it down immediately so no other events can trigger
          has_notified = true

          vim.schedule(function()
            -- 4. Turn off the filesystem watcher entirely to save resources
            if not fswatch:is_closing() then
              fswatch:stop()
            end

            local msg = string.format("Config changed - restart Neovim.", filename)

            vim.notify(msg, vim.log.levels.WARN, {
              title = "Config Watcher",
              timeout = false,
            })
          end)
        end)
      end)
    end)
  end

  watch_config_dir()
end)
