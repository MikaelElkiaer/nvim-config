-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Treat kubeconfigs as yaml
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function()
    vim.bo.filetype = "yaml"
  end,
  pattern = vim.fn.expand("~") .. "/.kube/config*",
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = vim.api.nvim_create_augroup("checktime", { clear = true }),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("man_unlisted", { clear = true }),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- Notify user to restart Neovim after Lazy config reload
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyReload",
  callback = function()
    vim.notify("Lazy configuration reloaded. Restart Neovim to apply changes.", vim.log.levels.WARN, {
      timeout = false,
    })
  end,
})

-- WARN: Broke after moving to treesitter main branch
-- -- Auto switch schema for multi-document YAML files
-- vim.api.nvim_create_autocmd("CursorHold", {
--   group = vim.api.nvim_create_augroup("YamlSchemaSwitcher", { clear = true }),
--   pattern = { "*.yaml", "*.yml" },
--   callback = function()
--     -- Check if schema-companion is available
--     local sc_ok, sc = pcall(require, "schema-companion")
--     if not sc_ok then
--       return
--     end
--
--     local bufnr = vim.api.nvim_get_current_buf()
--
--     -- Ensure yamlls is active
--     local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "yamlls" })
--     if #clients == 0 then
--       return
--     end
--
--     -- Setup Tree-sitter parser
--     local parser = vim.treesitter.get_parser(bufnr)
--     if not parser then
--       return
--     end
--     local tree = parser:parse()[1]
--     if not tree then
--       return
--     end
--     local root = tree:root()
--
--     -- Use Tree-sitter to find all document nodes
--     local doc_query_str = "((document) @doc)"
--     local ok, doc_query = pcall(vim.treesitter.query.parse, "yaml", doc_query_str)
--     if not ok or not doc_query then
--       return
--     end
--
--     local doc_nodes = {}
--     for _, node in doc_query:iter_captures(root, bufnr, 0, -1) do
--       table.insert(doc_nodes, node)
--     end
--
--     -- Only proceed for multi-document files
--     if #doc_nodes <= 1 then
--       return
--     end
--
--     -- Find the document node under the cursor
--     local cursor_row, _ = unpack(vim.api.nvim_win_get_cursor(0))
--     cursor_row = cursor_row - 1 -- make it 0-indexed
--     local current_doc_node = nil
--     for _, node in ipairs(doc_nodes) do
--       local start_row, _, end_row, _ = node:range()
--       if cursor_row >= start_row and cursor_row <= end_row then
--         current_doc_node = node
--         break
--       end
--     end
--
--     -- If no document node found, exit
--     if not current_doc_node then
--       return
--     end
--
--     local apiVersion = nil
--     local kind = nil
--     local apiVersion_query_str = [[
--           (document
--             (block_node
--               (block_mapping
--                 (block_mapping_pair
--                   key: (flow_node) @key (#eq? @key "apiVersion")
--                   value: (flow_node) @value)
--                 )))
--
--         ]]
--     local kind_query_str = [[
--           (document
--             (block_node
--               (block_mapping
--                 (block_mapping_pair
--                   key: (flow_node) @key (#eq? @key "kind")
--                   value: (flow_node) @value)
--                 )))
--
--         ]]
--     -- Extract apiVersion and kind from the current document node
--     local ok, apiVersion_query = pcall(vim.treesitter.query.parse, "yaml", apiVersion_query_str)
--     if ok and apiVersion_query then
--       for _, match, _ in apiVersion_query:iter_matches(current_doc_node, bufnr) do
--         for id, nodes in pairs(match) do
--           for _, node in ipairs(nodes) do
--             local capture_name = apiVersion_query.captures[id]
--             if capture_name == "value" then
--               local value_text = vim.treesitter.get_node_text(node, bufnr)
--               apiVersion = value_text
--             end
--           end
--         end
--       end
--     end
--     local ok, kind_query = pcall(vim.treesitter.query.parse, "yaml", kind_query_str)
--     if ok and kind_query then
--       for _, match, _ in kind_query:iter_matches(current_doc_node, bufnr) do
--         for id, nodes in pairs(match) do
--           for _, node in ipairs(nodes) do
--             local capture_name = kind_query.captures[id]
--             if capture_name == "value" then
--               local value_text = vim.treesitter.get_node_text(node, bufnr)
--               kind = value_text
--             end
--           end
--         end
--       end
--     end
--
--     -- If either apiVersion or kind is missing, exit
--     if not kind or not apiVersion then
--       return
--     end
--
--     -- Check if the correct schema is already set
--     local schemas = sc.get_matching_schemas(bufnr)
--     if schemas and #schemas == 1 then
--       local name_to_match = kind .. "@" .. apiVersion
--       if schemas[1].name == name_to_match then
--         return
--       end
--     end
--
--     -- Refresh matching schemas
--     --   if schema was previously set,
--     --   not all schemas may be considered during matching
--     sc.match()
--     -- Check for multiple schemas from schema-companion
--     schemas = sc.get_matching_schemas(bufnr)
--     if not schemas or #schemas <= 1 then
--       return
--     end
--
--     -- Select schema based on apiVersion and kind
--     local schema_to_select = nil
--     local name_to_match = kind .. "@" .. apiVersion
--     for _, schema in ipairs(schemas) do
--       if schema.name == name_to_match then
--         schema_to_select = schema
--         break
--       end
--     end
--
--     -- If no matching schema found, exit
--     if not schema_to_select then
--       return
--     end
--
--     -- Set schema
--     vim.notify("Switching to schema: " .. schema_to_select.uri, vim.log.levels.INFO, { timeout = 2000 })
--     sc.set_schemas({ schema_to_select })
--   end,
-- })
