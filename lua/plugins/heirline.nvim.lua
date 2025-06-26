return {
  "rebelot/heirline.nvim",
  event = "BufEnter",
  opts = function(_, opts)
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")

    local colors = {
      dark = utils.get_highlight("Search").bg,
      light = utils.get_highlight("Normal").fg,
      red = utils.get_highlight("Statement").fg,
      green = utils.get_highlight("String").fg,
      blue = utils.get_highlight("Identifier").fg,
      gray = utils.get_highlight("Comment").fg,
      orange = utils.get_highlight("Special").fg,
      purple = utils.get_highlight("Constant").fg,
      cyan = utils.get_highlight("Structure").fg,
      yellow = utils.get_highlight("Search").fg,
    }

    local Align = { provider = "%=" }
    local DefaultSeparator = { provider = " |" }
    local Space = { provider = " " }

    local mode = {
      -- get vim current mode, this information will be required by the provider
      -- and the highlight functions, so we compute it only once per component
      -- evaluation and store it as a component attribute
      init = function(self)
        self.mode = vim.fn.mode(1) -- :h mode()
      end,
      -- Now we define some dictionaries to map the output of mode() to the
      -- corresponding string and color. We can put these into `static` to compute
      -- them at initialisation time.
      static = {
        mode_names = { -- change the strings if you like it vvvvverbose!
          n = "N",
          no = "N?",
          nov = "N?",
          noV = "N?",
          ["no\22"] = "N?",
          niI = "Ni",
          niR = "Nr",
          niV = "Nv",
          nt = "Nt",
          v = "V",
          vs = "Vs",
          V = "V_",
          Vs = "Vs",
          ["\22"] = "V^",
          ["\22s"] = "V^",
          s = "S",
          S = "S_",
          ["\19"] = "S^",
          i = "I",
          ic = "Ic",
          ix = "Ix",
          R = "R",
          Rc = "Rc",
          Rx = "Rx",
          Rv = "Rv",
          Rvc = "Rv",
          Rvx = "Rv",
          c = "C",
          cv = "Ex",
          r = "...",
          rm = "M",
          ["r?"] = "?",
          ["!"] = "!",
          t = "T",
        },
        mode_colors = {
          n = "blue",
          i = "green",
          v = "orange",
          V = "orange",
          ["\22"] = "orange",
          c = "cyan",
          s = "red",
          S = "red",
          ["\19"] = "red",
          R = "cyan",
          r = "cyan",
          ["!"] = "purple",
          t = "purple",
        },
      },
      -- We can now access the value of mode() that, by now, would have been
      -- computed by `init()` and use it to index our strings dictionary.
      -- note how `static` fields become just regular attributes once the
      -- component is instantiated.
      -- To be extra meticulous, we can also add some vim statusline syntax to
      -- control the padding and make sure our string is always at least 2
      -- characters long. Plus a nice Icon.
      provider = function(self)
        return "%-3( " .. self.mode_names[self.mode] .. "%)"
      end,
      -- Same goes for the highlight. Now the foreground will change according to the current mode.
      hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        return { bg = self.mode_colors[mode], fg = "dark" }
      end,
      -- Re-evaluate the component only on ModeChanged event!
      -- Also allows the statusline to be re-evaluated when entering operator-pending mode
      update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
          vim.cmd("redrawstatus")
        end),
      },
    }

    local FileNameBlock = {
      -- let's first set up some attributes needed by this component and its children
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
      end,
    }
    -- We can now define some children separately and add them later

    local FileIcon = {
      init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ":e")
        self.icon, self.icon_color =
          require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
      end,
      provider = function(self)
        return self.icon and (self.icon .. " ")
      end,
      hl = function(self)
        return { fg = self.icon_color }
      end,
    }

    local FileName = {
      provider = function(self)
        -- first, trim the pattern relative to the current directory. For other
        -- options, see :h filename-modifers
        local filename = vim.fn.fnamemodify(self.filename, ":.:h")
        if filename == "" then
          return "[No Name]"
        end
        -- now, if the filename would occupy more than 1/4th of the available
        -- space, we trim the file path to its initials
        -- See Flexible Components section below for dynamic truncation
        if not conditions.width_percent_below(#filename, 0.25) then
          filename = vim.fn.pathshorten(filename)
        end
        return filename
      end,
      hl = { fg = "light" },
    }

    local FileFlags = {
      {
        condition = function()
          return vim.bo.modified
        end,
        provider = " [+]",
        hl = { fg = "red" },
      },
      {
        condition = function()
          return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = " [RO]",
        hl = { fg = "orange" },
      },
    }

    local Git = {
      condition = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        if not self.status_dict then
          return false
        end
        self.is_untracked = not (self.status_dict.added or self.status_dict.removed or self.status_dict.changed)
        if self.is_untracked then
          return true
        end
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
        return self.has_changes
      end,

      { provider = "  󰊢 " },
      {
        provider = function(self)
          return self.is_untracked and " ?"
        end,
        hl = { fg = "blue" },
      },
      {
        provider = function(self)
          local count = self.status_dict.added or 0
          return count > 0 and (" +" .. count)
        end,
        hl = { fg = "green" },
      },
      {
        provider = function(self)
          local count = self.status_dict.removed or 0
          return count > 0 and (" -" .. count)
        end,
        hl = { fg = "red" },
      },
      {
        provider = function(self)
          local count = self.status_dict.changed or 0
          return count > 0 and (" ±" .. count)
        end,
        hl = { fg = "yellow" },
      },
    }

    local Diagnostics = {

      condition = conditions.has_diagnostics,

      init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        self.error_icon = " " .. vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.ERROR] .. " "
        self.warn_icon = " " .. vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.WARN] .. " "
        self.info_icon = " " .. vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.INFO] .. " "
        self.hint_icon = " " .. vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.HINT] .. " "
      end,

      update = { "DiagnosticChanged", "BufEnter" },

      { provider = "   " },
      {
        provider = function(self)
          -- 0 is just another output, we can decide to print it or not!
          return self.errors > 0 and (self.error_icon .. self.errors)
        end,
        hl = { fg = "red" },
      },
      {
        provider = function(self)
          return self.warnings > 0 and (self.warn_icon .. self.warnings)
        end,
        hl = { fg = "yellow" },
      },
      {
        provider = function(self)
          return self.info > 0 and (self.info_icon .. self.info)
        end,
        hl = { fg = "blue" },
      },
      {
        provider = function(self)
          return self.hints > 0 and (self.hint_icon .. self.hints)
        end,
        hl = { fg = "cyan" },
      },
    }

    local BufList = utils.make_buflist({
      provider = function(self)
        local bufnr = self.bufnr
        local name = vim.api.nvim_buf_get_name(bufnr)
        local filename = name:match("^.+/(.+)$")
        if filename == "" then
          filename = "[No Name]"
        end
        return " " .. filename .. " "
      end,
      hl = function(self)
        return { fg = self.is_active and "light" or "gray" }
      end,
    })

    -- let's add the children to our FileNameBlock component
    FileNameBlock = utils.insert(
      FileNameBlock,
      FileName,
      FileFlags,
      { provider = "%<" } -- this means that the statusline is cut here when there's not enough space
    )

    return {
      opts = {
        colors = colors,
      },
      -- stylua: ignore
      statusline = {
        { provider = "%-40(" }, mode, Space, FileNameBlock,{ provider = "%)" },
        Align,
        BufList,
        Align,
        { provider = "%40(" }, Git, Diagnostics, Space,{ provider = "%)" },
      },
    }
  end,
}
