vim.g.config_updated = false

vim.schedule(function()
  local function watch_config_dir()
    local config_path = vim.fn.stdpath("config")

    local function is_functional_file(filename)
      if not filename then
        return true
      end

      -- Root files we explicitly track
      if filename == "init.lua" or filename == "nvim-pack-lock.json" then
        return true
      end

      -- Subdirectories we explicitly track
      local first_part = filename:match("^([^/\\]+)")
      if first_part == "after" or first_part == "lua" or first_part == "plugin" or first_part == "queries" then
        return true
      end

      return false
    end

    local function compute_config_hash()
      local files = {}

      local folders = { "after", "lua", "plugin", "queries" }
      for _, folder in ipairs(folders) do
        local found = vim.fn.globpath(config_path, folder .. "/**/*", false, true)
        for _, f in ipairs(found) do
          table.insert(files, f)
        end
      end

      local root_files = { "init.lua", "nvim-pack-lock.json" }
      for _, file in ipairs(root_files) do
        local found = vim.fn.globpath(config_path, file, false, true)
        for _, f in ipairs(found) do
          table.insert(files, f)
        end
      end

      table.sort(files)

      local parts = {}
      for _, file_path in ipairs(files) do
        if vim.fn.isdirectory(file_path) == 0 then
          local f = io.open(file_path, "r")
          if f then
            local content = f:read("*all")
            f:close()
            local file_hash = vim.fn.sha256(content)
            table.insert(parts, file_path .. ":" .. file_hash)
          end
        end
      end

      local combined = table.concat(parts, "\n")
      return vim.fn.sha256(combined)
    end

    local initial_hash = compute_config_hash()

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
      if err then
        return
      end

      if not is_functional_file(filename) then
        return
      end

      timer:stop()
      timer:start(
        200,
        0,
        vim.schedule_wrap(function()
          local current_hash = compute_config_hash()
          local changed = (current_hash ~= initial_hash)
          if vim.g.config_updated ~= changed then
            vim.g.config_updated = changed
            vim.cmd("redrawstatus")
          end
        end)
      )
    end)
  end

  watch_config_dir()
end)
