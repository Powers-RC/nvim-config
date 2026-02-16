
-- src: https://github.com/typescript-language-server/typescript-language-server
---@type vim.lsp.Config
return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "typescript",
    "typescriptreact",
    "javascript",
    "javascriptreact",
  },
  root_markers = { "package.json", "tsconfig.json", ".git" },
}
