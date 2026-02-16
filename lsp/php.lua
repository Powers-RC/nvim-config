-- lua/lsp/php.lua
return {
  cmd = { "intelephense", "--stdio" },
  filetypes = { "php" },
  root_markers = { "composer.json", "composer.lock", ".git" },
}

