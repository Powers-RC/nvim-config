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

-- Create an autocmd group for formatting on save
local format_on_save_group = vim.api.nvim_create_augroup("LspFormatting", {})

-- Attach the formatting autocmd to the LspAttach event
vim.api.nvim_create_autocmd("LspAttach", {
    group = format_on_save_group,
    callback = function(args)
        -- Check if the attached LSP client supports the formatting method
        if vim.lsp.buf.server_caps[args.client_id].documentFormatting then
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = format_on_save_group,
                buffer = args.buffer,
                callback = function()
                    -- Use the synchronous formatting function (most reliable)
                    vim.lsp.buf.format({ bufnr = args.buffer, async = false })
                end,
            })
        end
    end,
})

vim.lsp.enable({ "ty" })
vim.lsp.enable({ "tsserver" })
vim.lsp.enable({ "tailwind" })
vim.lsp.enable({ "php" })

