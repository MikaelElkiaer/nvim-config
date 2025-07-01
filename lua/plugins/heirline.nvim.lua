return {
  "rebelot/heirline.nvim",
  event = "BufEnter",
  opts = function(_, _)
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

    local align = { provider = "%=" }
    local space = { provider = " " }

    local bufList = utils.make_buflist(
      {
        init = function(self)
          local bufnr = self.bufnr
          local name = vim.api.nvim_buf_get_name(bufnr)
          self.filename = name:match("^.+/(.+)$")
          if not self.filename then
            self.filename = "[No Name]"
          end
          local extension = vim.fn.fnamemodify(self.filename, ":e")
          self.icon, self.icon_color =
            require("nvim-web-devicons").get_icon_color(self.filename, extension, { default = true })
        end,
        {
          provider = function(self)
            return self.icon
          end,
          hl = function(self)
            return { fg = self.icon_color }
          end,
        },
        {
          provider = function(self)
            return " " .. self.filename .. " "
          end,
        },
        hl = { fg = "gray" },
        update = { "BufEnter", "TabEnter" },
      },
      nil,
      nil,
      function()
        local bufnr = vim.api.nvim_get_current_buf()
        local buffers = vim.tbl_filter(function(buf)
          return buf ~= bufnr
            and vim.api.nvim_get_option_value("buflisted", { buf = buf })
        end, vim.api.nvim_list_bufs())
        table.sort(buffers, function(a, b)
          if (a > bufnr and b > bufnr) or (a < bufnr and b < bufnr) then
            return a < b
          else
            return a > bufnr
          end
        end)
        return buffers
      end,
      false
    )

    local columnEnd = {
      provider = function(_)
        return "%)"
      end,
    }

    local columnStartLeft = {
      init = function(self)
        local width = vim.o.columns
        self.maxWidth = math.floor(width * 0.3)
      end,
      provider = function(self)
        return "%-" .. self.maxWidth .. "("
      end,
      update = { "VimResized" },
    }

    local columnStartRight = {
      init = function(self)
        local width = vim.o.columns
        self.maxWidth = math.floor(width * 0.3)
      end,
      provider = function(self)
        return "%" .. self.maxWidth .. "("
      end,
      update = { "VimResized" },
    }

    local diagnostics = {

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

    local fileEncoding = {
      provider = function()
        local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
        return enc ~= "utf-8" and enc:upper()
      end,
    }

    local fileFlags = {
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

    local fileFormat = {
      provider = function()
        local fmt = vim.bo.fileformat
        return fmt ~= "unix" and fmt:upper()
      end,
    }

    local fileName = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
        if vim.bo.buftype == "terminal" then
          self.filename, _ = self.filename:gsub(".*:(.*);.*", "%1")
        elseif vim.bo.filetype == "help" then
          self.filename = vim.fn.fnamemodify(self.filename, ":t")
        end
        local extension = vim.fn.fnamemodify(self.filename, ":e")
        self.icon, self.icon_color =
          require("nvim-web-devicons").get_icon_color(self.filename, extension, { default = true })
      end,
      {
        provider = function(self)
          return self.icon .. " "
        end,
        hl = function(self)
          return { fg = self.icon_color }
        end,
      },
      {
        provider = function(self)
          local folder = vim.fn.fnamemodify(self.filename, ":.:h")
          if not conditions.width_percent_below(#folder, 0.3) then
            folder = vim.fn.pathshorten(folder)
          end
          return folder .. "/"
        end,
        hl = { fg = "gray" },
      },
      {
        provider = function(self)
          local filename = vim.fn.fnamemodify(self.filename, ":.:t")
          return filename
        end,
        hl = { fg = "light" },
      },
    }

    local gitDiff = {
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

      { provider = "  󰊢", hl = { fg = "light" } },
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

    local lsp = {
      condition = conditions.lsp_attached,
      update = { "LspAttach", "LspDetach" },

      provider = function()
        local names = {}
        for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
          table.insert(names, server.name)
        end
        table.sort(names)
        return " " .. table.concat(names, " ")
      end,
      hl = { fg = "light" },
    }

    local mode = {
      init = function(self)
        self.mode = vim.fn.mode(1)
      end,
      static = {
        mode_names = {
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
      provider = function(self)
        return "%-3( " .. self.mode_names[self.mode] .. "%)"
      end,
      hl = function(self)
        local mode = self.mode:sub(1, 1)
        return { bg = self.mode_colors[mode], fg = "dark" }
      end,
      update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
          vim.cmd("redrawstatus")
        end),
      },
    }

    local ruler = {
      provider = ":%l:%c",
      hl = { fg = "gray" },
    }

    local tabList = utils.make_tablist({
      provider = function(self)
        return " " .. self.tabpage .. " "
      end,
      hl = function(self)
        return { bg = "dark", fg = self.is_active and "light" or "gray" }
      end,
    })

    return {
      opts = {
        colors = colors,
      },
      -- stylua: ignore
      statusline = {
        -- INFO: left
        columnStartLeft, mode, space, fileName, ruler, fileFlags, columnEnd,
        -- INFO: center
        align, bufList, align,
        -- INFO: right
        columnStartRight, gitDiff, diagnostics, fileEncoding, fileFormat, space, lsp, space, columnEnd,
      },
      tabline = {
        { provider = "%=", hl = { bg = "dark" } },
        tabList,
        { provider = "%=", hl = { bg = "dark" } },
      },
    }
  end,
}
