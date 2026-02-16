local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"tanvirtin/monokai.nvim",
    {
        "saghen/blink.cmp",
        -- optional: provides snippets for the snippet source
        dependencies = { "rafamadriz/friendly-snippets" },

        -- Use a release tag to download pre-built binaries
        version = "*",
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use Nix, you can build from source using the latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to VSCode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = {
                -- Each keymap may be a list of commands and/or functions
                preset = "enter",
                -- Select completions
                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                ["<Tab>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                -- Scroll documentation
                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },
                -- Show/hide signature
                ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
            },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            sources = {
                -- `lsp`, `buffer`, `snippets`, `path`, and `omni` are built-in
                -- so you don't need to define them in `sources.providers`
                default = { "lsp", "path", "snippets", "buffer" },

                -- Sources are configured via the sources.providers table
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "prefer_rust_with_warning" },
            completion = {
                -- The keyword should only match against the text before
                keyword = { range = "prefix" },
                menu = {
                    -- Use treesitter to highlight the label text for the given list of sources
                    draw = {
                        treesitter = { "lsp" },
                    },
                },
                -- Show completions after typing a trigger character, defined by the source
                trigger = { show_on_trigger_character = true },
                documentation = {
                    -- Show documentation automatically
                    auto_show = true,
                },
            },

            -- Signature help when tying
            signature = { enabled = true },
        },
        opts_extend = { "sources.default" },
    },
    { "mason-org/mason.nvim", opts = {} },
    {"theprimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
          require("harpoon"):setup()
        end,
        keys = {
          { "<leader>a", function() require("harpoon"):list():add() end, desc = "Append harpoon file", },
          { "<leader>h", function() local harpoon = require("harpoon") harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "harpoon quick menu", },
          { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "harpoon to file 1", },
          { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "harpoon to file 2", },
          { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "harpoon to file 3", },
          { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "harpoon to file 4", },
          { "<leader>5", function() require("harpoon"):list():select(5) end, desc = "harpoon to file 5", },
        },
    },
    {"nvim-telescope/telescope.nvim",
      tag = "0.1.2",

      -- Telescope needs plenary, and the file browser is an extension
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
      },

      -- Keymaps are declared here so lazy.nvim can lazy-load Telescope
      keys = {
        -- Core Telescope pickers
        {
          "<leader>ff",
          function() require("telescope.builtin").find_files() end,
          desc = "Find files",
        },
        {
          "<leader>fg",
          function() require("telescope.builtin").live_grep() end,
          desc = "Live grep",
        },
        {
          "<leader>fh",
          function() require("telescope.builtin").help_tags() end,
          desc = "Help tags",
        },

        -- File browser: opens in the directory of the current file
        {
          "<leader>fb",
          function()
            require("telescope").extensions.file_browser.file_browser({
              path = vim.fn.expand("%:p:h"),
              cwd = vim.fn.expand("%:p:h"),
              select_buffer = true,
            })
          end,
          desc = "File browser (current file)",
        },
      },

      config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local fb_actions = telescope.extensions.file_browser.actions
        local function open_in_split(prompt_bufnr)
          actions.select_default(prompt_bufnr)
          vim.cmd("split")
        end

        local function open_in_vsplit(prompt_bufnr)
          actions.select_default(prompt_bufnr)
          vim.cmd("vsplit")
        end

        local function open_in_tab(prompt_bufnr)
          actions.select_default(prompt_bufnr)
          vim.cmd("tabedit")
        end

        telescope.setup({
          ------------------------------------------------------------------
          -- DEFAULTS (apply to all Telescope pickers)
          ------------------------------------------------------------------
          defaults = {
            -- Faster navigation with fewer keystrokes
            mappings = {
              i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<Esc>"] = actions.close,
              },
            },
          },

          ------------------------------------------------------------------
          -- EXTENSIONS
          ------------------------------------------------------------------
          extensions = {
            file_browser = {
              ----------------------------------------------------------------
              -- CORE BEHAVIOR
              ----------------------------------------------------------------

              -- Replace netrw entirely
              hijack_netrw = true,

              -- Group files & folders together (cleaner tree)
              grouped = true,

              -- Show dotfiles but still respect .gitignore
              hidden = false,
              respect_gitignore = true,

              -- No preview pane = faster + less visual noise
              previewer = false,

              -- When cwd changes, reflect it in the path display
              cwd_to_path = true,

              ----------------------------------------------------------------
              -- KEYMAPS (designed for muscle memory)
              ----------------------------------------------------------------
              mappings = {
                -- INSERT MODE (default Telescope mode)
                i = {
                  -- Navigation
                  ["<CR>"]  = actions.select_default, -- always open in nvim
                  ["<C-l>"] = actions.select_default,
                  ["<C-h>"] = fb_actions.goto_parent_dir, -- go up a directory

                  ["<C-x>"] = open_in_split,
                  ["<C-v>"] = open_in_vsplit,
                  ["<C-t>"] = open_in_tab,

                  -- File operations
                  ["<C-n>"] = fb_actions.create,           -- new file / folder
                  ["<C-r>"] = fb_actions.rename,           -- rename
                  ["<C-d>"] = fb_actions.remove,           -- delete
                  ["<C-y>"] = fb_actions.copy,             -- copy
                  ["<C-m>"] = fb_actions.move,             -- move

                  ["<Esc>"] = actions.close,
                },

                -- NORMAL MODE (vim-style browsing)
                n = {
                  h = fb_actions.goto_parent_dir,
                  l = actions.select_default,

                  ["<C-x>"] = open_in_split,
                  ["<C-v>"] = open_in_vsplit,
                  ["<C-t>"] = open_in_tab,

                  n = fb_actions.create,
                  r = fb_actions.rename,
                  d = fb_actions.remove,
                  y = fb_actions.copy,
                  m = fb_actions.move,
                },
              },
            },
          },
        })

        -- Load the file_browser extension explicitly
        telescope.load_extension("file_browser")
      end,
    },
  'tpope/vim-commentary',
})

