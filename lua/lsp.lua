-- Remove Global Default Key mapping
vim.keymap.del("n", "grn")
vim.keymap.del("n", "gra")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "gO")

-- Create keymapping
-- LspAttach: After an LSP Client performs "initialize" and attaches to a buffer.
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function (args)
        local keymap = vim.keymap
        local lsp = vim.lsp
	    local bufopts = { noremap = true, silent = true }
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        -- print(vim.inspect(client.server_capabilities))

        keymap.set("n", "gr", lsp.buf.references, bufopts)
        keymap.set("n", "gd", lsp.buf.definition, bufopts)
            -- Go to Declaration (fallback if not supported)
        keymap.set("n", "gD", function()
          if lsp.buf.declaration then
            lsp.buf.declaration()  -- Try Go to Declaration
          else
            lsp.buf.definition()  -- Fallback to Go to Definition
          end
        end, bufopts)
        keymap.set("n", "<space>rn", lsp.buf.rename, bufopts)
        keymap.set("n", "K", lsp.buf.hover, bufopts)
        keymap.set("n", "<space>f", function()
            vim.lsp.buf.format({ async = true })
        end, bufopts)
    end
})

-- Prevent the typescript lsp from formatting document
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.name == "ts_ls" then
      client.server_capabilities.documentFormattingProvider = false
    end
  end,
})

-- Change js,ts,jsx,tsx formatting defaults
vim.api.nvim_create_autocmd("FileType", {
  pattern = "javascript,typescript,javascriptreact,typescriptreact",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true -- JS/TS often uses 2 spaces
  end
})

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})



vim.lsp.enable({ "ty" })
vim.lsp.enable({ "tsserver" })
vim.lsp.enable({ "tailwind" })
vim.lsp.enable({ "php" })

