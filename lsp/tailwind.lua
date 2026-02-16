-- lua/lsp/tailwind.lua
return {
  cmd = { "tailwindcss-language-server", "--stdio" }, --
    filetypes = {
        "html",
        "css",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "svelte",
        "templ", -- Example of a custom filetype
    },
    root_markers = {
        "tailwind.config.js",
        "tailwind.config.cjs",
        "tailwind.config.mjs",
        "tailwind.config.ts",
        "postcss.config.js",
        "package.json",
        ".git" --
    }
}

