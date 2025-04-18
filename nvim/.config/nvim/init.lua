--
-- base config
vim.loader.enable(true)

local opt = vim.opt
local api = vim.api

-- https://neovim.io/doc/user/options.html
opt.number = true
opt.relativenumber = true

opt.mouse:append("a")
opt.mousemoveevent = true
opt.clipboard = "unnamedplus,unnamed"

opt.hlsearch = true
opt.incsearch = true
opt.jumpoptions = "stack" -- helps jumps out of the definition without too many C-o

opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.autoindent = true
opt.copyindent = false

opt.listchars = "space:·,nbsp:○,trail:␣,tab:>-,eol:↵,extends:◣,precedes:◢"
opt.list = true
opt.showbreak = "> "

opt.ignorecase = true
opt.smartcase = true

opt.undofile = true
opt.swapfile = true
opt.backup = false
opt.autoread = true
opt.updatetime = 300

opt.vb = true
opt.laststatus = 3 -- means statuscolumn will only on the bottom
opt.wrap = false -- display lines as one long line
opt.signcolumn = "yes"
opt.colorcolumn = "80"
-- opt.colorcolumn = { 80, 100 }
opt.fileencoding = "utf-8"
opt.completeopt = { "menuone", "noselect" } -- completion will pop up when there is only one match
opt.conceallevel = 0 -- no hide for ``
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal,globals"
opt.splitbelow = true -- force window to be splited into the bottom
opt.splitright = true

opt.scrolloff = 8
opt.sidescrolloff = 8
opt.cursorline = true

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- enable 24-bit colour
opt.termguicolors = true
-- override color
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = { "*" },
  callback = function()
    api.nvim_set_hl(0, "IlluminatedWordText", { underline = true })
    api.nvim_set_hl(0, "IlluminatedWordRead", { underline = true })
    api.nvim_set_hl(0, "IlluminatedWordWrite", { underline = true })

    api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
  end,
})

-- highlight while yank
api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({
      timeout = 300,
    })
  end,
})

-- language specific settings
api.nvim_create_autocmd("Filetype", {
  pattern = "lua",
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.wo.colorcolumn = "80"
  end,
})
api.nvim_create_autocmd("Filetype", {
  pattern = "rust",
  command = "set colorcolumn=100",
})

-------------------------------------------------------------------------------
vim.lsp.set_log_level("OFF") -- "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF"
-- vim.lsp.inlay_hint.enable(true) -- enable globally

vim.diagnostic.config({
  virtual_text = true,
  -- underline = true,
  -- virtual_lines = true,
  -- update_in_insert = true,
  -- severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "󰌶",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
})

vim.g.tex_flavor = "latex"

-------------------------------------------------------------------------------
-- set leader keys before lazy
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- lazy config
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- theme
    -- :help everforest.txt
    {
      "sainnhe/everforest",
      config = function()
        if vim.o.termguicolors then
          vim.o.termguicolors = true
        end
        vim.g.everforest_transparent_background = 2
        vim.g.everforest_float_style = "dim"
        vim.g.everforest_dim_inactive_windows = 1
        vim.g.everforest_diagnostic_text_highlight = 1
        vim.g.everforest_diagnostic_line_highlight = 1
        vim.g.everforest_diagnostic_virtual_text = "highlighted"
        vim.g.everforest_inlay_hints_background = "dimmed"
        vim.g.everforest_better_performance = 1
        vim.g.everforest_enable_italic = 1
        vim.g.everforest_disable_italic_comment = 0
        vim.g.everforest_sign_column_background = "grey"
        vim.g.everforest_ui_contrast = "high"
        -- vim.g:everforest_background = 'soft' -- 'hard'
        vim.o.background = "dark" -- or "light" for light mode
        vim.cmd.colorscheme("everforest")
      end,
    },
    {
      "ellisonleao/gruvbox.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        require("gruvbox").setup({
          dim_inactive = false,
          -- contrast = 'hard', -- can be "hard", "soft" or empty string
          transparent_mode = false,
          -- transparent_mode = true,
        })

        vim.o.background = "dark" -- or "light" for light mode
        vim.cmd([[colorscheme gruvbox]])
      end,
    },
    -- status line below
    {
      "nvim-lualine/lualine.nvim",
      lazy = false,
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("lualine").setup({
          options = {
            icons_enabled = true,
            theme = "auto",
            -- theme = 'gruvbox',
            -- theme = 'gruvbox_dark',
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = {
              statusline = {},
              winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            always_show_tabline = true,
            globalstatus = true,
            refresh = {
              statusline = 100,
              tabline = 100,
              winbar = 100,
            },
          },
          sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = { "filename" },
            lualine_x = { "lsp_status", "encoding", "fileformat", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
          },
          tabline = {},
          winbar = {},
          inactive_winbar = {},
          extensions = {},
        })
      end,
    },
    -- manage tools
    {
      "williamboman/mason.nvim",
      event = "VeryLazy",
      keys = {
        { "<leader>m", ":Mason<enter>", desc = "Open Mason" },
      },
      config = function()
        require("mason").setup({
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        })
      end,
    },
    -- make mason work with nvim lsp
    {
      "williamboman/mason-lspconfig.nvim",
      lazy = true,
      dependencies = {
        "williamboman/mason.nvim",
      },
      config = function()
        require("mason-lspconfig").setup({
          ensure_installed = {
            "rust_analyzer",
            "clangd",
            "ruff",
            "pyright",
            "lua_ls",
            "texlab",
            "asm_lsp",
            "gopls",
            -- 'eslint',
            -- 'marksman',
          },
          automatic_installation = true,
        })
      end,
    },
    -- nvim-lspconfig (lsp config presets)
    {
      "neovim/nvim-lspconfig",
      event = { "BufReadPost", "BufNewFile" },
      cmd = { "LspInfo", "LspInstall", "LspUninstall" },
      dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "saghen/blink.cmp",
      },
      config = function()
        -- https://neovim.io/doc/user/lsp.html#vim.lsp.config()
        local servers = {
          "rust_analyzer",
          "clangd",
          "ruff",
          "pyright",
          "lua_ls",
          "asm_lsp",
          "texlab",
        }
        vim.lsp.enable(servers)

        vim.lsp.config["*"] = {
          -- common settings (redefine)
          capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()),
        }

        -- rust
        -- local lsp_work_by_client_id = {}
        -- local time = 0
        vim.lsp.config("rust_analyzer", {
          settings = {
            ["rust-analyzer"] = {
              diagnostics = {
                enable = true,
                experimental = { enable = true },
                styleLints = { enable = true },
              },
              cargo = { features = "all" },
              checkOnSave = true,
              check = {
                command = "clippy",
                features = "all",
              },
              files = {
                -- watcher = 'server',
                watcher = "client",
              },
              inlayHints = {
                typeHints = { enable = true },
                chainingHints = { enable = true },
                closingBraceHints = { enable = true },
                bindingModeHints = { enable = true },
                closureCaptureHints = { enable = true },
                closureReturnTypeHints = {
                  enable = "always",
                },
                discriminantHints = { enable = "always" },
                expressionAdjustmentHints = {
                  enable = "always",
                },
                genericParameterHints = {
                  const = { enable = true },
                  lifetime = { enable = true },
                  type = { enable = true },
                },
                implicitDrops = { enable = true },
                implicitSizedBoundHints = { enable = true },
                maxLength = { "" },
                reborrowHints = { enable = "always" },
                renderColons = { enable = true },
                lifetimeElisionHints = {
                  enable = true,
                  useParameterNames = true,
                },
              },
            },
          },
          -- -- enable inlay hints at buffer open
          -- on_attach = function(_, bufnr)
          --   vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          --
          --   pcall(vim.api.nvim_create_autocmd, "LspProgress", {
          --     callback = function(event)
          --       local kind = event.data.params.value.kind
          --       local client_id = event.data.client_id
          --       local work = lsp_work_by_client_id[client_id] or 0
          --       local work_change = kind == "begin" and 1 or (kind == "end" and -1 or 0)
          --       lsp_work_by_client_id[client_id] = math.max(work + work_change, 0)
          --
          --       if
          --         vim.lsp.inlay_hint.is_enabled({
          --           bufnr = bufnr,
          --         }) and lsp_work_by_client_id[client_id] == 0
          --       then
          --         vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
          --         vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          --         time = time + 1
          --         print(string.format("inlay hints redrew %d times", time))
          --       end
          --     end,
          --   })
          -- end,
        })

        -- clangd
        local nproc
        local jit = require("jit")
        if jit.os == "OSX" then
          nproc = vim.fn.systemlist("sysctl -n hw.physicalcpu")[1]
        elseif jit.os == "Linux" then
          nproc = vim.fn.systemlist("nproc")[1]
        end
        vim.lsp.config("clangd", {
          cmd = {
            "clangd",
            "--background-index",
            "--background-index-priority=normal",
            "-j=" .. nproc,
            "--clang-tidy",
            "--all-scopes-completion",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
            "--function-arg-placeholders",
            "--pch-storage=memory",
            "--offset-encoding=utf-8",
            "--fallback-style=LLVM",
            "--compile-commands-dir=build",
          },
          on_attach = function(_, bufnr)
            if not vim.lsp.inlay_hint.is_enabled() then
              vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
              print("clangd running with " .. nproc .. " jobs...")
            end
          end,
        })

        -- python
        vim.lsp.config("ruff", {
          -- https://docs.astral.sh/ruff/editors/setup/#neovim
        })
        -- pyright
        vim.lsp.config("pyright", {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "off",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "off",
                autoImportCompletions = false,
              },
              linting = {
                enabled = false,
              },
            },
          },
          -- Disable all diagnostics from Pyright
          handlers = {
            ["textDocument/publishDiagnostics"] = function() end,
          },
        })

        --lua
        vim.lsp.config("lua_ls", {
          settings = {
            Lua = {
              hint = {
                enable = true,
                setType = true,
                arrayIndex = "Enable",
              },
            },
          },
          -- on_attach = function(_, bufnr)
          --   vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          -- end,
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if
                path ~= vim.fn.stdpath("config")
                and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
              then
                return
              end
            end

            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
              runtime = {
                version = "LuaJIT",
              },
              diagnostics = {
                globals = { "vim" },
                disable = { "missing-fields" },
              },
              telemetry = { enable = false },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  vim.fn.stdpath("data") .. "/lazy/",
                  -- "${3rd}/luv/library",
                  -- "${3rd}/busted/library",
                },
              },
            })
          end,
        })

        -- asm
        vim.lsp.config("asm_lsp", {
          -- https://github.com/bergercookie/asm-lsp
        })

        -- latex
        vim.lsp.config("texlab", {
          settings = {
            texlab = {
              build = {
                onSave = false, -- use <leader>tb to build
                forwardSearchAfter = true,
                -- fallback if reading .latexmkrc/latexmkrc failed
                auxDirectory = "build",
                logDirectory = "build",
                pdfDirectory = "build",
                executable = "latexmk",
                args = {
                  -- "-pv", -- preview
                  "-synctex=1",
                  "-interaction=nonstopmode",
                  "-file-line-error",
                  "-pdf",
                  "-outdir=build",
                  "%f",
                },
              },
              chktex = {
                onOpenAndSave = true,
                onEdit = true,
              },
              latexFormatter = "none", -- defined in conform config
              -- latexFormatter = "latexindent",
              -- latexindent = {
              --   modifyLineBreaks = true,
              -- },
              -- <leader>tt to forwardSearch, right click in sioyek to inverse search
              forwardSearch = {
                executable = "sioyek",
                args = {
                  "--reuse-window",
                  "--execute-command",
                  "turn_on_synctex;turn_on_presenation_mode",
                  "--inverse-search",

                  -- -- stylua: ignore
                  -- "texlab inverse-search -i \"%%1\" -l \"%%2\"", -- would offset by one line down

                  -- stylua: ignore
                  string.format("bash -c %s", string.format(
                    "\"nvim --headless --noplugin --server %s --remote \"%s\" && nvim --headless --noplugin --server %s --remote-send \"gg%sjk0%slh\"\"",
                    vim.v.servername,
                    "%%1",
                    vim.v.servername,
                    "%%2",
                    "%%3"
                  )),

                  "--forward-search-file",
                  "%f",
                  "--forward-search-line",
                  "%l",
                  "%p",
                },
              },
            },
          },
        })
      end,
    },
    -- completion
    {
      "saghen/blink.cmp",
      event = "VeryLazy",
      build = "cargo build --release",
      dependencies = {
        "rafamadriz/friendly-snippets",
        {
          "L3MON4D3/LuaSnip",
          build = "make install_jsregexp",
        },
        {
          "folke/lazydev.nvim",
          ft = "lua",
          opts = {
            library = {
              { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
          },
        },
        {
          "xzbdmw/colorful-menu.nvim",
        },
      },
      opts = {
        keymap = {
          preset = "super-tab",
        },
        appearance = {
          nerd_font_variant = "mono",
        },
        completion = {
          documentation = {
            auto_show = true,
          },
          ghost_text = { enabled = true },
          menu = {
            draw = {
              columns = { { "kind_icon" }, { "label", gap = 1 } },
              components = {
                label = {
                  text = function(ctx)
                    return require("colorful-menu").blink_components_text(ctx)
                  end,
                  highlight = function(ctx)
                    return require("colorful-menu").blink_components_highlight(ctx)
                  end,
                },
              },
            },
          },
        },
        fuzzy = { implementation = "rust" },
        cmdline = {
          enabled = true,
          keymap = {
            preset = "super-tab",
          },
          completion = { menu = { auto_show = true } },
        },
        snippets = { preset = "luasnip" },
        sources = {
          -- add lazydev to your completion providers
          default = { "lazydev", "lsp", "path", "snippets", "buffer" },
          providers = {
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              -- make lazydev completions top priority (see `:h blink.cmp`)
              score_offset = 100,
            },
          },
        },
        signature = { enabled = true },
      },
      opts_extend = { "sources.default" },
    },
    -- formatting
    {
      "stevearc/conform.nvim",
      lazy = true,
      cmd = "ConformInfo",
      event = { "BufWritePre", "BufReadPre", "BufNewFile" }, -- to disable, comment this out
      config = function()
        require("conform").setup({
          formatters_by_ft = {
            rust = { "rustfmt", lsp_format = "fallback" },
            python = function(bufnr)
              if require("conform").get_formatter_info("ruff_format", bufnr).available then
                return { "ruff_format" }
              else
                return { "isort", "black" }
              end
            end,
            lua = { "stylua" },
            javascript = {
              "prettierd",
              "prettier",
              stop_after_first = true,
            },
            typescript = { "prettierd" },
            javascriptreact = { "prettierd" },
            typescriptreact = { "prettierd" },
            css = { "prettierd" },
            html = { "prettierd" },
            jsonc = { "prettierd" },
            json = { "prettierd" },
            yaml = { "prettierd" },
            markdown = { "prettierd" },
            graphql = { "prettierd" },
            tex = { "tex-fmt" },
            bib = { "tex-fmt" },
            cls = { "tex-fmt" },
            sty = { "tex-fmt" },
          },
          default_format_opts = {
            lsp_format = "fallback",
          },
          format_on_save = {
            timeout_ms = 500,
            async = false,
            quiet = false,
            lsp_format = "fallback",
          },
          format_after_save = {
            lsp_format = "fallback",
          },
          notify_on_error = true,
          notify_no_formatters = true,
          formatters = {
            black = {
              prepend_args = { "--fast" },
            },
          },
        })
      end,
    },
    -- basic highlighting
    {
      {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        config = function()
          require("nvim-treesitter.configs").setup({
            ensure_installed = {
              "rust",
              "latex",
              "bibtex",
              "toml",
              "zig",
              "python",
              "go",
              "gomod",
              "gosum",
              "c",
              "make",
              "cmake",
              "asm",
              "glsl",
              "sql",
              "lua",
              "vim",
              "vimdoc",
              "markdown",
              "markdown_inline",
              "tsx",
              "typescript",
              "javascript",
              "html",
              "css",
              "scss",
              "regex",
              "json",
              "yaml",
              "xml",
              "vue",
              "java",
              "javadoc",
              "git_config",
              "gitcommit",
              "gitignore",
              "git_rebase",
              "doxygen",
              "dockerfile",
              "desktop",
              "hyprlang",
              "kdl",
            },

            sync_install = false,
            auto_install = true,
            ignore_install = {
              -- "javascript",
            },
            highlight = {
              enable = true,
              disable = {
                "latex",
              },
            },
            autotag = {
              enable = true,
            },
            indent = {
              enable = true,
            },
            incremental_selection = {
              enable = true,
              keymaps = {
                init_selection = "gnn", -- set to `false` to disable one of the mappings
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
              },
            },
          })
        end,
      },
    },
    -- quick search and jump to char in screen
    {
      "folke/flash.nvim",
      opts = {},
      keys = {
        {
          "s",
          mode = { "n", "x", "o" },
          function()
            require("flash").jump()
          end,
          desc = "Flash",
        },
        {
          "S",
          mode = { "n", "x", "o" },
          function()
            require("flash").treesitter()
          end,
          desc = "Flash Treesitter",
        },
        {
          "r",
          mode = "o",
          function()
            require("flash").remote()
          end,
          desc = "Remote Flash",
        },
        {
          "R",
          mode = { "o", "x" },
          function()
            require("flash").treesitter_search()
          end,
          desc = "Treesitter Search",
        },
        {
          "<c-s>",
          mode = { "c" },
          function()
            require("flash").toggle()
          end,
          desc = "Toggle Flash Search",
        },
      },
    },
    -- fuzzy finding, lua version
    {
      "ibhagwan/fzf-lua",
      event = "VeryLazy",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
        {
          "skim-rs/skim",
          build = "./install",
        },
        {
          "junegunn/fzf",
          build = "./install --all",
        },
      },
      config = function()
        require("fzf-lua").setup({
          -- https://github.com/ibhagwan/fzf-lua/blob/main/OPTIONS.md
          "fzf-native", -- https://github.com/ibhagwan/fzf-lua/tree/main/lua/fzf-lua/profiles

          winopts = { preview = { layout = "vertical", vertical = "up:75%" } },

          fzf_bin = "sk",
          fzf_opts = { ["--border"] = "rounded", ["--tmux"] = "center,80%,80%" },

          --[[ -- preview code_actions, set in ~/.gitconfig, require `dandavison/delta`
            [core]
              editor = nvim
                pager = delta
            [interactive]
                diffFilter = delta --color-only
            [delta]
                # dark = true      # or light = true, or omit for auto-detection
                navigate = true  # use n and N to move between diff sections
                line-numbers = true
                side-by-side = true
                hyperlinks = true
            [merge]
                conflictstyle = zdiff3
          --]]
          -- lsp = {
          --   code_actions = {
          --     -- previewer = "codeaction_native", -- already set in "fzf-native"
          --
          --     -- for fzf
          --     -- preview_pager = "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS",
          --     -- preview_pager = "delta --navigate --line-numbers --hyperlinks --side-by-side --width=$FZF_PREVIEW_COLUMNS",
          --
          --     -- for sk, https://github.com/ibhagwan/fzf-lua/issues/2000
          --     -- preview_pager = "delta --navigate --line-numbers --hyperlinks --side-by-side --width=$COLUMNS",
          --   },
          -- },
        })

        vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find Files" })
        vim.keymap.set("n", "<leader>fll", "<cmd>FzfLua lines<cr>", { desc = "Open Buffers Lines" })
        vim.keymap.set("n", "<leader>flb", "<cmd>FzfLua blines<cr>", { desc = "Current Buffer Lines" })
        vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { desc = "Live grep current project" })
        vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "Find Buffers" })
        vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua helptags<cr>", { desc = "Find Helptags" })
        vim.keymap.set("n", "<leader>fm", "<cmd>FzfLua manpages<cr>", { desc = "Find Manpages" })
        vim.keymap.set("n", "<leader>fc", "<cmd>FzfLua commands<cr>", { desc = "Find Commands" })
        vim.keymap.set("n", "<leader>fs", "<cmd>FzfLua colorschemes<cr>", { desc = "Color Schemes" })
        vim.keymap.set("n", "<leader>gf", "<cmd>FzfLua git_files<cr>", { desc = "Git Files" })
        vim.keymap.set("n", "<leader>gst", "<cmd>FzfLua git_status<cr>", { desc = "Git Status" })
        vim.keymap.set("n", "<leader>gc", "<cmd>FzfLua git_commits<cr>", { desc = "Git Commits" })
        vim.keymap.set("n", "<leader>gbc", "<cmd>FzfLua git_bcommits<cr>", { desc = "Git Buffer Commits" })
        vim.keymap.set("n", "<leader>gbb", "<cmd>FzfLua git_blame<cr>", { desc = "Git Buffer Blame" })
        vim.keymap.set("n", "<leader>gss", "<cmd>FzfLua git_stash<cr>", { desc = "Git Stash" })
        vim.keymap.set("n", "<leader>gbr", "<cmd>FzfLua git_branches<cr>", { desc = "Git Branches" })
        vim.keymap.set(
          "n",
          "<leader>ft",
          -- vim.lsp.buf.declaration,
          "<cmd>FzfLua tmux_buffers<cr>",
          { desc = "list tmux paste buffers" }
        )
      end,
    },
    {
      "saecki/crates.nvim",
      event = { "BufRead Cargo.toml" },
      dependencies = {
        "nvim-lua/plenary.nvim",
        "folke/which-key.nvim",
      },
      config = function()
        local crates = require("crates")
        crates.setup({ -- https://github.com/YaQia/.dotfile/blob/master/nvim/lua/plugins/crates.lua
          popup = {
            border = "rounded",
          },
          lsp = {
            enabled = true,
            on_attach = function(_, bufnr)
              require("lsp_signature").on_attach({
                hint_enable = true, -- virtual hint enable
                hint_prefix = "• ",
              }, bufnr)
            end,
            actions = true,
            completion = true,
            hover = true,
          },
          completion = {
            crates = {
              enabled = true, -- disabled by default
              max_results = 8, -- The maximum number of search results to display
              min_chars = 3, -- The minimum number of charaters to type before completions begin appearing
            },
            cmp = {
              enabled = true,
            },
          },
        })

        local function show_documentation()
          local filetype = vim.bo.filetype
          if vim.tbl_contains({ "vim", "help" }, filetype) then
            vim.cmd("h " .. vim.fn.expand("<cword>"))
          elseif vim.tbl_contains({ "man" }, filetype) then
            vim.cmd("Man " .. vim.fn.expand("<cword>"))
          elseif vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
            require("crates").show_popup()
          else
            vim.lsp.buf.hover()
          end
        end
        vim.keymap.set("n", "K", show_documentation, { silent = true })

        local wk = require("which-key")
        wk.add({
          { "<leader>C", group = "Crates", remap = false },
          {
            "<leader>CA",
            crates.upgrade_all_crates,
            desc = "Upgrade All",
            remap = false,
          },
          {
            "<leader>CU",
            crates.upgrade_crate,
            desc = "Upgrade",
            remap = false,
          },
          {
            "<leader>Ca",
            crates.update_all_crates,
            desc = "Update All",
            remap = false,
          },
          {
            "<leader>Cd",
            crates.show_dependencies_popup,
            desc = "Dependencies",
            remap = false,
          },
          {
            "<leader>Cf",
            crates.show_features_popup,
            desc = "Features",
            remap = false,
          },
          {
            "<leader>Cr",
            crates.show_features_popup,
            desc = "Reload",
            remap = false,
          },
          { "<leader>Ct", crates.toggle, desc = "Toggle", remap = false },
          { "<leader>Cu", crates.update_crate, desc = "Update", remap = false },
          {
            "<leader>Cv",
            crates.show_versions_popup,
            desc = "Version",
            remap = false,
          },
        })

        wk.add({
          {
            mode = { "x" },
            { "<leader>C", group = "Crates", nowait = true, remap = false },
            {
              "<leader>CU",
              crates.upgrade_crates,
              desc = "Upgrade",
              nowait = true,
              remap = false,
            },
            {
              "<leader>Cu",
              crates.update_crates,
              desc = "Update",
              nowait = true,
              remap = false,
            },
          },
        })
      end,
    },
    -- keymap hints
    {
      "folke/which-key.nvim",
      -- enabled = false,
      dependencies = { "nvim-tree/nvim-web-devicons" },
      event = "VeryLazy",
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
      },
    },
    -- pairs
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      opts = {},
    },
    -- hex color render
    {
      "echasnovski/mini.hipatterns",
      version = false,
      event = { "BufReadPost", "BufNewFile" },
      config = function()
        local hipatterns = require("mini.hipatterns")
        hipatterns.setup({
          highlighters = {
            hex_color = hipatterns.gen_highlighter.hex_color(),
          },
        })
      end,
    },
    {
      "folke/snacks.nvim",
      event = { "BufReadPost", "BufNewFile" },
      opts = {
        animate = {
          enabled = true,
          fps = 240,
        },
        bigfile = { enabled = true },
        dashboard = { enabled = false },
        git = { enabled = false },
        explorer = { enabled = true },
        image = { enabled = true },
        indent = {
          indent = {
            enabled = true,
          },
          scope = {
            enabled = true,
            hl = {
              "RainbowRed",
              "RainbowYellow",
              "RainbowBlue",
              "RainbowOrange",
              "RainbowGreen",
              "RainbowViolet",
              "RainbowCyan",
            },
          },
        },
        input = { enabled = true },
        picker = { enabled = true },
        layout = { enabled = true },
        notifier = { enabled = true },
        notify = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = {
          enabled = false,
          animate = {
            duration = { step = 30, total = 210 },
            easing = "outQuad",
          },
        },
        statuscolumn = {
          enabled = true,
          left = { "mark", "sign" }, -- priority of signs on the left (high to low)
          right = { "git", "fold" }, -- priority of signs on the right (high to low)
          folds = {
            open = false, -- show open fold icons
            git_hl = true, -- use Git Signs hl for fold icons
          },
          git = {
            -- patterns to match Git signs
            patterns = { "GitSign", "MiniDiffSign" },
          },
          refresh = 50, -- refresh at most every 50ms
        },
        styles = {
          ["input"] = {
            relative = "cursor",
            width = 25,
            row = -3,
          },
        },
        toggle = {
          enabled = true,
          which_key = true,
          notify = true,
        },
        win = {
          enabled = true,
        },
        words = {
          enabled = false,
        },
        zen = {
          enabled = true,
        },
      },
    },
    -- todo
    {
      "folke/todo-comments.nvim",
      event = { "BufReadPost", "BufNewFile" },
      dependencies = { "nvim-lua/plenary.nvim" },
      keys = {
        {
          "]t",
          function()
            require("todo-comments").jump_next()
          end,
          desc = "Next todo comment",
        },
        {
          "[t",
          function()
            require("todo-comments").jump_prev()
          end,
          desc = "Previous todo comment",
        },
        {
          "<leader>tf",
          "<cmd>TodoFzfLua<cr>",
          desc = "TODO Search",
        },
      },
      opts = {},
    },
    -- usage indication
    {
      "RRethy/vim-illuminate",
      event = {
        "CursorHold",
        "CursorHoldI",
        -- "LspAttach"
      },
      -- dependencies = { "neovim/nvim-lspconfig" },
      config = function()
        require("illuminate").configure({
          providers = {
            "lsp",
            -- 'treesitter',
            -- 'regex',
          },
          modes_denylist = { "i", "v", "V" },
        })
      end,
    },
    -- render markdown
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = "markdown",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
      }, -- if you prefer nvim-web-devicons
      opts = {},
    },
    -- pretty list for showing diagnostics and more
    {
      "folke/trouble.nvim",
      opts = {}, -- for default options, refer to the configuration section for custom setup.
      cmd = "Trouble",
      keys = {
        {
          "<leader>xx",
          "<cmd>Trouble diagnostics toggle<cr>",
          desc = "Diagnostics (Trouble)",
        },
        {
          "<leader>xX",
          "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
          desc = "Buffer Diagnostics (Trouble)",
        },
        {
          "<leader>cs",
          "<cmd>Trouble symbols toggle focus=false<cr>",
          desc = "Symbols (Trouble)",
        },
        {
          "<leader>cl",
          "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
          desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
          "<leader>xL",
          "<cmd>Trouble loclist toggle<cr>",
          desc = "Location List (Trouble)",
        },
        {
          "<leader>xQ",
          "<cmd>Trouble qflist toggle<cr>",
          desc = "Quickfix List (Trouble)",
        },
      },
    },
  },
  install = { colorscheme = { "everforest" } },
  checker = { enabled = true, notify = false },
  change_detection = { enabled = true, notify = false },
  defaults = { lazy = true },
})

-------------------------------------------------------------------------------
-- keymap config
-- tip: use gx to open link in browser
-- ctrl w + h,j,k,l to move among splited window buffer

local keymap = vim.keymap

--[[ -- force not using arrow keys
keymap.set('n', '<up>', '<nop>')
keymap.set('n', '<down>', '<nop>')
keymap.set('n', '<left>', '<nop>')
keymap.set('n', '<right>', '<nop>')
keymap.set('i', '<up>', '<nop>')
keymap.set('i', '<down>', '<nop>')
keymap.set('i', '<left>', '<nop>')
keymap.set('i', '<right>', '<nop>') ]]

keymap.set("n", "<leader>ll", ":Lazy<enter>")
keymap.set("n", "<leader>e", ":Explore<enter>")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    local buffer = ev.buf

    -- lsp keymap
    keymap.set("n", "<leader>li", "<cmd>checkhealth vim.lsp<cr>", { desc = "LSP info" })
    keymap.set("n", "<leader>i", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { desc = "Toggle inlay hints", buffer = buffer })
    keymap.set("n", "<leader>df", vim.diagnostic.open_float, { desc = "open float diagnostic", buffer = buffer })
    keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "diagnostic set loc list", buffer = buffer })
    keymap.set(
      "n",
      "gD",
      -- vim.lsp.buf.declaration,
      "<cmd>FzfLua lsp_declarations<cr>",
      { desc = "go to declaration", buffer = buffer }
    )
    keymap.set(
      "n",
      "gd",
      -- vim.lsp.buf.definition,
      "<cmd>FzfLua lsp_definitions<cr>",
      { desc = "go to definition", buffer = buffer }
    )
    keymap.set("n", "<leader>k", vim.lsp.buf.hover, {
      desc = "open hover, x2 into hover window, q to exit",
      buffer = buffer,
    })
    keymap.set(
      "n",
      "gi",
      -- vim.lsp.buf.implementation,
      "<cmd>FzfLua lsp_implementations<cr>",
      { desc = "go to implementation", buffer = buffer }
    )
    keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "signature help", buffer = buffer })
    keymap.set(
      "n",
      "<leader>wa",
      vim.lsp.buf.add_workspace_folder,
      { desc = "add add workspace folder", buffer = buffer }
    )
    keymap.set(
      "n",
      "<leader>wr",
      vim.lsp.buf.remove_workspace_folder,
      { desc = "remove workspace folder", buffer = buffer }
    )
    keymap.set("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, {
      desc = "list workspace folders",
      buffer = buffer,
    })
    keymap.set(
      "n",
      "<space>D",
      -- vim.lsp.buf.type_definition,
      "<cmd>FzfLua lsp_typedefs<cr>",
      { desc = "type definition", buffer = buffer }
    )
    -- keymap.set('n', '<leader>br', vim.lsp.buf.rename, { desc = 'rename buffer', buffer = buffer })
    -- keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, { desc = "Code Actions", buffer = buffer })
    keymap.set({ "n", "v" }, "<leader>a", "<cmd>FzfLua lsp_code_actions<cr>", { desc = "Code Action", buffer = buffer })
    keymap.set(
      "n",
      "gr",
      -- vim.lsp.buf.references,
      "<cmd>FzfLua lsp_references<cr>",
      { desc = "references", buffer = buffer }
    )

    keymap.set("n", "gI", "<cmd>FzfLua lsp_incoming_calls<cr>", { desc = "Goto Parent", buffer = buffer })
    keymap.set("n", "gO", "<cmd>FzfLua lsp_outgoing_calls<cr>", { desc = "Goto Child", buffer = buffer })

    -- texlab
    vim.keymap.set("n", "<leader>tt", "<cmd>TexlabForward<cr>", { desc = "Texlab Forward Search" })
    vim.keymap.set("n", "<leader>tb", "<cmd>TexlabBuild<cr>", { desc = "Texlab Build" })
  end,
})
