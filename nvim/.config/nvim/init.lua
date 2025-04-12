-- base config
local opt = vim.opt
local api = vim.api

-- opt.syntax = 'on'
opt.number = true
opt.relativenumber = true

opt.mouse:append 'a'
opt.clipboard = 'unnamedplus,unnamed'

opt.hlsearch = true
opt.incsearch = true

opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.autoindent = true
opt.listchars =
    'space:·,nbsp:○,trail:␣,tab:>-,eol:↵,extends:◣,precedes:◢'
opt.list = true

opt.ignorecase = true
opt.smartcase = true

opt.undofile = true
opt.swapfile = true
opt.autoread = true
vim.bo.autoread = true

opt.vb = true
opt.wrap = false
opt.signcolumn = 'yes'
opt.colorcolumn = '80'
api.nvim_create_autocmd(
    'Filetype',
    { pattern = 'rust', command = 'set colorcolumn=100' }
)

api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank {
            timeout = 300,
        }
    end,
})

opt.scrolloff = 5
opt.sidescrolloff = 5
opt.cursorline = true
-- enable 24-bit colour
opt.termguicolors = true
vim.diagnostic.config { virtual_text = true }

-------------------------------------------------------------------------------
-- set leader keys before lazy
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- lazy config
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        '--branch=stable',
        lazyrepo,
        lazypath,
    }
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
            { out, 'WarningMsg' },
            { '\nPress any key to exit...' },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
    spec = {
        -- theme
        -- :help everforest.txt
        {
            'sainnhe/everforest',
            enabled = false,
            priority = 1000,
            config = function()
                if vim.o.termguicolors then
                    vim.o.termguicolors = true
                end
                vim.g.everforest_transparent_background = 2
                vim.g.everforest_float_style = 'dim'
                vim.g.everforest_dim_inactive_windows = 1
                vim.g.everforest_diagnostic_text_highlight = 1
                vim.g.everforest_diagnostic_line_highlight = 1
                vim.g.everforest_diagnostic_virtual_text = 'highlighted'
                vim.g.everforest_inlay_hints_background = 'dimmed'
                vim.g.everforest_better_performance = 1
                vim.g.everforest_enable_italic = 1
                vim.g.everforest_disable_italic_comment = 0
                vim.g.everforest_sign_column_background = 'grey'
                vim.g.everforest_ui_contrast = 'high'
                -- vim.g:everforest_background = 'soft' -- 'hard'
                vim.o.background = 'dark' -- or "light" for light mode
                vim.cmd.colorscheme 'everforest'
            end,
        },
        {
            'ellisonleao/gruvbox.nvim',
            lazy = false,
            priority = 1000,
            config = function()
                require('gruvbox').setup {
                    -- contrast = 'hard', -- can be "hard", "soft" or empty string
                    transparent_mode = false,
                    -- transparent_mode = true,
                }
                vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
                vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
                vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
                vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
                vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
                vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
                vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })

                vim.o.background = 'dark' -- or "light" for light mode
                vim.cmd [[colorscheme gruvbox]]
            end,
        },
        -- status line below
        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' },
            config = function()
                require('lualine').setup {
                    options = {
                        icons_enabled = true,
                        theme = 'auto',
                        -- theme = 'gruvbox',
                        -- theme = 'gruvbox_dark',
                        component_separators = { left = '', right = '' },
                        section_separators = { left = '', right = '' },
                        disabled_filetypes = {
                            statusline = {},
                            winbar = {},
                        },
                        ignore_focus = {},
                        always_divide_middle = true,
                        always_show_tabline = true,
                        globalstatus = false,
                        refresh = {
                            statusline = 100,
                            tabline = 100,
                            winbar = 100,
                        },
                    },
                    sections = {
                        lualine_a = { 'mode', 'lsp_status' },
                        lualine_b = { 'branch', 'diff', 'diagnostics' },
                        lualine_c = { 'filename' },
                        lualine_x = { 'encoding', 'fileformat', 'filetype' },
                        lualine_y = { 'progress' },
                        lualine_z = { 'location' },
                    },
                    inactive_sections = {
                        lualine_a = {},
                        lualine_b = {},
                        lualine_c = { 'filename' },
                        lualine_x = { 'location' },
                        lualine_y = {},
                        lualine_z = {},
                    },
                    tabline = {},
                    winbar = {},
                    inactive_winbar = {},
                    extensions = {},
                }
            end,
        },
        -- manage tools
        {
            'williamboman/mason.nvim',
            event = 'VeryLazy',
            config = function()
                require('mason').setup {
                    ui = {
                        icons = {
                            package_installed = '✓',
                            package_pending = '➜',
                            package_uninstalled = '✗',
                        },
                    },
                }
            end,
        },
        -- install and update manson tools
        {
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            lazy = true,
            -- event = 'VeryLazy',
            dependencies = {
                'williamboman/mason.nvim',
            },
            config = function()
                require('mason-tool-installer').setup {
                    ensure_installed = {
                        -- lsp
                        'rust-analyzer',
                        'clangd',
                        'gopls',
                        'pyright',
                        'lua-language-server',
                        -- lint
                        'ruff',
                        -- fmt
                        'black',
                        'stylua',
                        'eslint_d',
                        'prettierd',
                        -- dap
                        'codelldb',
                    },
                    auto_update = true,
                    integrations = {
                        ['mason-lspconfig'] = true,
                        ['mason-null-ls'] = true,
                        ['mason-nvim-dap'] = true,
                    },
                }
            end,
        },
        -- make mason work with nvim lsp
        {
            'williamboman/mason-lspconfig.nvim',
            lazy = true,
            dependencies = {
                'williamboman/mason.nvim',
            },
            config = function()
                require('mason-lspconfig').setup {
                    ensure_installed = {
                        'rust_analyzer',
                        'clangd',
                        'gopls',
                        'ruff',
                        -- 'pyright',
                        'lua_ls',
                        'eslint',
                        'marksman',
                    },
                    automatic_installation = true,
                }
            end,
        },
        -- lsp config
        {
            'neovim/nvim-lspconfig',
            event = { 'BufReadPost', 'BufNewFile' },
            cmd = { 'LspInfo', 'LspInstall', 'LspUninstall' },
            dependencies = {
                'williamboman/mason-lspconfig.nvim',
            },
            opts = {
                inlay_hints = {
                    enabled = true, -- globally set to true
                },
            },
            config = function(_, opts)
                local lspconfig = require 'lspconfig'
                -- local util = require 'lspconfig.util'
                local capabilities = vim.lsp.protocol.make_client_capabilities()
                local methods = vim.lsp.protocol.Methods

                vim.diagnostic.config { virtual_text = true }

                -- Python
                -- https://docs.astral.sh/ruff/editors/setup/#neovim
                lspconfig.ruff.setup {
                    --[[ init_options = {
                        settings = {
                            -- Ruff language server settings go here
                        },
                    }, ]]
                }
                lspconfig.pyright.setup {
                    capabilities = vim.lsp.protocol.make_client_capabilities(),
                    settings = {
                        python = {
                            analysis = {
                                typeCheckingMode = 'off',
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                                diagnosticMode = 'off',
                                autoImportCompletions = false,
                            },
                            linting = {
                                enabled = false,
                            },
                        },
                    },
                    -- Disable all diagnostics from Pyright
                    handlers = {
                        ['textDocument/publishDiagnostics'] = function() end,
                    },
                }

                -- clangd
                -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/clangd.lua
                require('lspconfig').clangd.setup {
                    cmd = {
                        'clangd',
                        '--background-index',
                        '-j=10',
                        '--clang-tidy',
                        '--all-scopes-completion',
                        '--completion-style=detailed',
                        '--header-insertion=iwyu',
                        '--function-arg-placeholders',
                        '--pch-storage=memory',
                        '--offset-encoding=utf-8',
                        '--fallback-style=LLVM',
                        '--compile-commands-dir=build',
                    },
                    on_attach = function(client, bufnr)
                        if
                            opts.inlay_hints.enabled
                            and vim.api.nvim_buf_is_valid(bufnr)
                            and vim.bo[bufnr].buftype == ''
                            and client.server_capabilities.inlayHintProvider
                            and client:supports_method(
                                methods.textDocument_inlayHint
                            )
                        then
                            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                        end
                    end,
                }

                -- golang
                vim.api.nvim_create_autocmd('BufWritePre', {
                    pattern = '*.go',
                    callback = function()
                        local params = vim.lsp.util.make_range_params()
                        params.context = { only = { 'source.organizeImports' } }
                        -- buf_request_sync defaults to a 1000ms timeout. Depending on your
                        -- machine and codebase, you may want longer. Add an additional
                        -- argument after params if you find that you have to write the file
                        -- twice for changes to be saved.
                        -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
                        local result = vim.lsp.buf_request_sync(
                            0,
                            'textDocument/codeAction',
                            params
                        )
                        for cid, res in pairs(result or {}) do
                            for _, r in pairs(res.result or {}) do
                                if r.edit then
                                    local enc = (
                                        vim.lsp.get_client_by_id(cid) or {}
                                    ).offset_encoding or 'utf-16'
                                    vim.lsp.util.apply_workspace_edit(
                                        r.edit,
                                        enc
                                    )
                                end
                            end
                        end
                        vim.lsp.buf.format { async = false }
                    end,
                })

                lspconfig.gopls.setup {
                    settings = {
                        gopls = {
                            analyses = {
                                unusedparams = true,
                            },
                            staticcheck = true,
                            gofumpt = true,
                        },
                    },
                    on_attach = function(client, bufnr)
                        -- Enable completion triggered by <c-x><c-o>
                        vim.api.nvim_buf_set_option(
                            bufnr,
                            'omnifunc',
                            'v:lua.vim.lsp.omnifunc'
                        )
                    end,
                }

                -- lua
                lspconfig.lua_ls.setup {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { 'vim' },
                            },
                        },
                    },
                    capabilities = capabilities,
                }
            end,
        },
        --[[ -- make mason work with null-ls
        {
            'jay-babu/mason-null-ls.nvim',
            event = { 'BufReadPre', 'BufNewFile' },
            dependencies = {
                'williamboman/mason.nvim',
            },
            config = function()
                require('mason-null-ls').setup {
                    ensure_installed = {
                        -- 'ruff',
                        'stylua',
                    },
                    automatic_installation = true,
                }
            end,
        },
        -- replacing null-ls
        {
            'nvimtools/none-ls.nvim',
            dependencies = {
                'jay-babu/mason-null-ls.nvim',
                'nvim-lua/plenary.nvim',
            },
            config = function()
                local null_ls = require 'null-ls'

                null_ls.setup {
                    sources = {
                        null_ls.builtins.formatting.stylua,
                        null_ls.builtins.completion.spell,
                        -- require 'none-ls.diagnostics.eslint', -- requires none-ls-extras.nvim
                    },
                }
            end,
        }, ]]
        -- make mason work with nvim dap
        {
            'jay-babu/mason-nvim-dap.nvim',
            lazy = true,
            dependencies = {
                'williamboman/mason.nvim',
            },
            config = function()
                require('mason-nvim-dap').setup {
                    automatic_installation = true,
                    ensure_installed = {
                        'codelldb',
                        'delve',
                    },
                }
            end,
        },
        -- dap
        {
            'mfussenegger/nvim-dap',
            lazy = true,
            dependencies = {
                'rcarriga/nvim-dap-ui',
                'nvim-neotest/nvim-nio',
                'jay-babu/mason-nvim-dap.nvim',
                -- 'leoluz/nvim-dap-go',
            },
            keys = {
                {
                    '<F5>',
                    function()
                        require('dap').continue()
                    end,
                    desc = 'Debug: Start/Continue',
                },
                {
                    '<F1>',
                    function()
                        require('dap').step_into()
                    end,
                    desc = 'Debug: Step Into',
                },
                {
                    '<F2>',
                    function()
                        require('dap').step_over()
                    end,
                    desc = 'Debug: Step Over',
                },
                {
                    '<F3>',
                    function()
                        require('dap').step_out()
                    end,
                    desc = 'Debug: Step Out',
                },
                {
                    '<leader>b',
                    function()
                        require('dap').toggle_breakpoint()
                    end,
                    desc = 'Debug: Toggle Breakpoint',
                },
                {
                    '<leader>B',
                    function()
                        require('dap').set_breakpoint(
                            vim.fn.input 'Breakpoint condition: '
                        )
                    end,
                    desc = 'Debug: Set Breakpoint',
                },
                {
                    '<F7>',
                    function()
                        require('dapui').toggle()
                    end,
                    desc = 'Debug: See last session result.',
                },
            },
            config = function()
                local dap = require 'dap'
                local dapui = require 'dapui'

                -- Dap UI setup
                -- For more information, see |:help nvim-dap-ui|
                dapui.setup {
                    -- Set icons to characters that are more likely to work in every terminal.
                    --    Feel free to remove or use ones that you like more! :)
                    --    Don't feel like these are good choices.
                    icons = {
                        expanded = '▾',
                        collapsed = '▸',
                        current_frame = '*',
                    },
                    controls = {
                        icons = {
                            pause = '⏸',
                            play = '▶',
                            step_into = '⏎',
                            step_over = '⏭',
                            step_out = '⏮',
                            step_back = 'b',
                            run_last = '▶▶',
                            terminate = '⏹',
                            disconnect = '⏏',
                        },
                    },
                }

                -- Change breakpoint icons
                vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
                vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
                local breakpoint_icons = vim.g.have_nerd_font
                        and {
                            Breakpoint = '',
                            BreakpointCondition = '',
                            BreakpointRejected = '',
                            LogPoint = '',
                            Stopped = '',
                        }
                    or {
                        Breakpoint = '●',
                        BreakpointCondition = '⊜',
                        BreakpointRejected = '⊘',
                        LogPoint = '◆',
                        Stopped = '⭔',
                    }
                for type, icon in pairs(breakpoint_icons) do
                    local tp = 'Dap' .. type
                    local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
                    vim.fn.sign_define(
                        tp,
                        { text = icon, texthl = hl, numhl = hl }
                    )
                end

                dap.listeners.after.event_initialized['dapui_config'] =
                    dapui.open
                dap.listeners.before.event_terminated['dapui_config'] =
                    dapui.close
                dap.listeners.before.event_exited['dapui_config'] = dapui.close

                -- -- Install golang specific config
                -- require('dap-go').setup {
                --     delve = {
                --         -- On Windows delve must be run attached or it crashes.
                --         -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
                --         detached = vim.fn.has 'win32' == 0,
                --     },
                -- }
            end,
        },
        -- completion
        {
            'saghen/blink.cmp',
            event = 'InsertEnter',
            -- event = { 'BufReadPost', 'BufNewFile' },
            dependencies = { 'rafamadriz/friendly-snippets' },
            version = '1.*',
            opts = {
                keymap = {
                    preset = 'super-tab',
                },

                appearance = {
                    nerd_font_variant = 'mono',
                },
                completion = {
                    documentation = {
                        auto_show = true,
                    },
                },
                sources = {
                    default = { 'lsp', 'path', 'snippets', 'buffer' },
                },
                fuzzy = { implementation = 'prefer_rust_with_warning' },
            },
            opts_extend = { 'sources.default' },
        },
        -- formatting
        {
            'stevearc/conform.nvim',
            lazy = true,
            cmd = 'ConformInfo',
            event = { 'BufWritePre', 'BufReadPre', 'BufNewFile' }, -- to disable, comment this out
            config = function()
                require('conform').setup {
                    formatters_by_ft = {
                        rust = { 'rustfmt', lsp_format = 'fallback' },
                        python = function(bufnr)
                            if
                                require('conform').get_formatter_info(
                                    'ruff_format',
                                    bufnr
                                ).available
                            then
                                return { 'ruff_format' }
                            else
                                return { 'isort', 'black' }
                            end
                        end,
                        lua = { 'stylua' },
                        javascript = {
                            'prettierd',
                            'prettier',
                            stop_after_first = true,
                        },
                        typescript = { 'prettierd' },
                        javascriptreact = { 'prettierd' },
                        typescriptreact = { 'prettierd' },
                        css = { 'prettierd' },
                        html = { 'prettierd' },
                        jsonc = { 'prettierd' },
                        yaml = { 'prettierd' },
                        markdown = { 'prettierd' },
                        graphql = { 'prettierd' },
                    },
                    default_format_opts = {
                        lsp_format = 'fallback',
                    },
                    format_on_save = {
                        timeout_ms = 500,
                        async = false,
                        quiet = false,
                        lsp_format = 'fallback',
                    },
                    format_after_save = {
                        lsp_format = 'fallback',
                    },
                    notify_on_error = true,
                    notify_no_formatters = true,
                    formatters = {
                        black = {
                            prepend_args = { '--fast' },
                        },
                    },
                }
            end,
        },
        -- basic highlighting
        {
            {
                'nvim-treesitter/nvim-treesitter',
                event = { 'BufReadPre', 'BufNewFile' },
                build = ':TSUpdate',
                config = function()
                    require('nvim-treesitter.configs').setup {
                        ensure_installed = {
                            -- 'rust',
                            -- 'latex',
                            'toml',
                            'zig',
                            'python',
                            'go',
                            'gomod',
                            'gosum',
                            'c',
                            'make',
                            'cmake',
                            'asm',
                            'glsl',
                            'sql',
                            'lua',
                            'vim',
                            'vimdoc',
                            'markdown',
                            'markdown_inline',
                            'tsx',
                            'typescript',
                            'javascript',
                            'html',
                            'css',
                            'scss',
                            'regex',
                            'json',
                            'yaml',
                            'xml',
                            'vue',
                            'java',
                            'javadoc',
                            'git_config',
                            'gitcommit',
                            'gitignore',
                            'git_rebase',
                            'doxygen',
                            'dockerfile',
                            'desktop',
                            'hyprlang',
                            'kdl',
                        },

                        sync_install = false,

                        auto_install = true,

                        highlight = {
                            enable = true,
                            disable = {
                                'latex', -- use vimtex
                                'rust',
                            },
                            additional_vim_regex_highlighting = true,
                        },
                        autotag = {
                            enable = true,
                        },
                        indent = {
                            enable = true,
                        },
                        -- incremental_selection = {
                        --     enable = true,
                        --     keymaps = {
                        --         init_selection = '<enter>',
                        --         node_incremental = '<enter>',
                        --         scope_incremental = false,
                        --         node_decremental = '<bs>',
                        --     },
                        -- },
                    }
                end,
            },
        },
        -- file viewer
        {
            'nvim-tree/nvim-tree.lua',
            event = 'VeryLazy',
            --[[ keys = {
                {
                    '<leader>t',
                    ':NvimTreeToggle<enter>',
                    'n',
                    desc = 'Toggle Tree',
                },
            }, ]]
            config = function()
                require('nvim-tree').setup()
            end,
        },
        -- quick search and jump to char in screen
        {
            'folke/flash.nvim',
            opts = {},
            keys = {
                {
                    's',
                    mode = { 'n', 'x', 'o' },
                    function()
                        require('flash').jump()
                    end,
                    desc = 'Flash',
                },
                {
                    'S',
                    mode = { 'n', 'x', 'o' },
                    function()
                        require('flash').treesitter()
                    end,
                    desc = 'Flash Treesitter',
                },
                {
                    'r',
                    mode = 'o',
                    function()
                        require('flash').remote()
                    end,
                    desc = 'Remote Flash',
                },
                {
                    'R',
                    mode = { 'o', 'x' },
                    function()
                        require('flash').treesitter_search()
                    end,
                    desc = 'Treesitter Search',
                },
                {
                    '<c-s>',
                    mode = { 'c' },
                    function()
                        require('flash').toggle()
                    end,
                    desc = 'Toggle Flash Search',
                },
            },
        },
        -- search stuff
        {
            'nvim-telescope/telescope.nvim',
            enabled = false, -- use fzf-lua
            -- tag = '0.1.8',
            -- or                              , branch = '0.1.x',
            dependencies = { 'nvim-lua/plenary.nvim' },
            event = 'VeryLazy',
            config = function()
                local builtin = require 'telescope.builtin'
                vim.keymap.set(
                    'n',
                    '<leader>ff',
                    builtin.find_files,
                    { desc = 'Telescope find files' }
                )
                vim.keymap.set(
                    'n',
                    '<leader>fg',
                    builtin.live_grep,
                    { desc = 'Telescope live grep' }
                )
                vim.keymap.set(
                    'n',
                    '<leader>fb',
                    builtin.buffers,
                    { desc = 'Telescope buffers' }
                )
                vim.keymap.set(
                    'n',
                    '<leader>fh',
                    builtin.help_tags,
                    { desc = 'Telescope help tags' }
                )

                require('telescope').setup {
                    defaults = {
                        -- Default configuration for telescope goes here:
                        -- config_key = value,
                        mappings = {
                            i = {
                                -- map actions.which_key to <C-h> (default: <C-/>)
                                -- actions.which_key shows the mappings for your picker,
                                -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                                ['<C-h>'] = 'which_key',
                            },
                        },
                    },
                    pickers = {
                        -- Default configuration for builtin pickers goes here:
                        -- picker_name = {
                        --   picker_config_key = value,
                        --   ...
                        -- }
                        -- Now the picker_config_key will be applied every time you call this
                        -- builtin picker
                    },
                    extensions = {
                        -- Your extension configuration goes here:
                        -- extension_name = {
                        --   extension_config_key = value,
                        -- }
                        -- please take a look at the readme of the extension you want to configure
                    },
                }
            end,
        },
        -- fuzzy finding, lua version of fzf
        {
            'ibhagwan/fzf-lua',
            event = 'VeryLazy',
            -- optional for icon support
            dependencies = { 'nvim-tree/nvim-web-devicons' },
            -- or if using mini.icons/mini.nvim
            -- dependencies = { "echasnovski/mini.icons" },
            -- opts = {},
            config = function()
                require('fzf-lua').setup {
                    'hide',
                    -- your other settings here
                    -- fzf-lua
                    vim.keymap.set(
                        'n',
                        '<leader>ff',
                        ':FzfLua files<enter>',
                        { desc = 'fzf-lua - files' }
                    ),
                    vim.keymap.set(
                        'n',
                        '<leader>fr',
                        ':FzfLua resume<enter>',
                        { desc = 'fzf-lua - resume' }
                    ),
                    vim.keymap.set(
                        'n',
                        '<leader>fb',
                        ':FzfLua buffers<enter>',
                        { desc = 'fzf-lua - buffers' }
                    ),
                    vim.keymap.set(
                        'n',
                        '<leader>fh',
                        ':FzfLua helptags<enter>',
                        { desc = 'fzf-lua -  helptags' }
                    ),
                    vim.keymap.set(
                        'n',
                        '<leader>fm',
                        ':FzfLua manpages<enter>',
                        { desc = 'fzf-lua -  manpages' }
                    ),
                }
            end,
        },
        -- keymap hints
        {
            'folke/which-key.nvim',

            dependencies = { 'nvim-tree/nvim-web-devicons' },
            event = 'VeryLazy',
            opts = {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            },
            keys = {
                {
                    '<leader>?',
                    function()
                        require('which-key').show { global = false }
                    end,
                    desc = 'Buffer Local Keymaps (which-key)',
                },
            },
        },
        -- comment
        {
            'numToStr/Comment.nvim',
            event = { 'BufReadPost', 'BufNewFile' },
            opts = {},
        },
        -- pairs
        {
            'windwp/nvim-autopairs',
            event = 'InsertEnter',
            opts = {},
        },
        -- rainbow indent
        {
            'folke/snacks.nvim',
            event = { 'BufReadPost', 'BufNewFile' },
            opts = {
                indent = {
                    indent = {
                        enabled = true,
                        -- hl = {
                        --     'SnacksIndent1',
                        --     'SnacksIndent2',
                        --     'SnacksIndent3',
                        --     'SnacksIndent4',
                        --     'SnacksIndent5',
                        --     'SnacksIndent6',
                        --     'SnacksIndent7',
                        --     'SnacksIndent8',
                        -- },
                    },
                    scope = {
                        enabled = true,
                        hl = {
                            'RainbowRed',
                            'RainbowYellow',
                            'RainbowBlue',
                            'RainbowOrange',
                            'RainbowGreen',
                            'RainbowViolet',
                            'RainbowCyan',
                        },
                    },
                },
            },
        },
        -- render markdown
        {
            'MeanderingProgrammer/render-markdown.nvim',
            -- lazy = true,
            ft = 'markdown',
            dependencies = {
                'nvim-treesitter/nvim-treesitter',
                'nvim-tree/nvim-web-devicons',
            }, -- if you prefer nvim-web-devicons
            -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
            opts = {},
        },
        -- latex support
        {
            'lervag/vimtex',
            -- lazy = false, -- we don't want to lazy load VimTeX
            ft = 'tex',
            tag = 'v2.15', -- uncomment to pin to a specific release
            init = function()
                -- VimTeX configuration goes here, e.g.
                vim.g.vimtex_mappings_disable = { ['n'] = { 'K' } } -- disable `K` as it conflicts with LSP hover
                -- vim.g.vimtex_view_method = "zathura"
                vim.g.vimtex_view_general_viewer = 'sioyek'
                vim.g.vimtex_view_method = 'sioyek'
                vim.g.vimtex_compiler_method = 'latexmk'
                vim.g.vimtex_compiler_latexmk = {
                    options = {
                        '-synctex=1',
                        '-interaction=nonstopmode',
                        -- '-file-line-error',
                        '-xelatex',
                        -- "-pdf",
                        '-outdir=./build',
                    },
                }
                vim.g.vimtex_quickfix_open_on_warning = 0
                -- vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
            end,
            keys = {
                { '<localLeader>l', '', desc = '+vimtex', ft = 'tex' },
            },
        },
        -- rust lsp
        {
            'mrcjkb/rustaceanvim',
            -- version = '^6', -- Recommended
            lazy = true, -- This plugin is already lazy
            ft = 'rust',
            config = function()
                vim.g.rustaceanvim = {
                    -- Plugin configuration
                    tools = {},
                    -- LSP configuration
                    server = {
                        on_attach = function(client, bufnr)
                            -- enable inlay hint for rust at buffer open
                            -- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

                            -- keymaps
                            vim.keymap.set('n', '<leader>a', function()
                                vim.cmd.RustLsp 'codeAction' -- supports rust-analyzer's grouping
                                -- or vim.lsp.buf.codeAction() if you don't want grouping.
                            end, {
                                silent = true,
                                buffer = bufnr,
                                desc = 'RustLsp codeAction',
                            })
                            vim.keymap.set(
                                'n',
                                -- 'K', -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
                                '<leader>k', -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
                                function()
                                    vim.cmd.RustLsp { 'hover', 'actions' }
                                end,
                                {
                                    silent = true,
                                    buffer = bufnr,
                                    desc = 'RustLsp hover actions',
                                }
                            )
                        end,
                        default_settings = {
                            -- rust-analyzer language server configuration
                            ['rust-analyzer'] = {
                                assist = {
                                    importEnforceGranularity = true,
                                    importPrefix = 'create',
                                },
                                cargo = { allFeatures = true },
                                checkOnSave = {
                                    -- default: `cargo check`
                                    command = 'clippy',
                                    allFeatures = true,
                                },
                                inlayHints = {
                                    typeHints = { enable = true },
                                    chainingHints = { enable = true },
                                    closingBraceHints = { enable = true },
                                    bindingModeHints = { enable = true },
                                    closureCaptureHints = { enable = true },
                                    closureReturnTypeHints = {
                                        enable = 'always',
                                    },
                                    discriminantHints = { enable = 'always' },
                                    expressionAdjustmentHints = {
                                        enable = 'always',
                                    },
                                    genericParameterHints = {
                                        const = { enable = true },
                                        lifetime = { enable = true },
                                        type = { enable = true },
                                    },
                                    implicitDrops = { enable = true },
                                    implicitSizedBoundHints = { enable = true },
                                    maxLength = { nil },
                                    reborrowHints = { enable = 'always' },
                                    renderColons = { enable = true },
                                    lifetimeElisionHints = {
                                        enable = true,
                                        useParameterNames = true,
                                    },
                                },
                            },
                        },
                    },
                    -- DAP configuration
                    dap = {},
                }
            end,
        },
        -- git commands
        {
            'tpope/vim-fugitive',
            event = 'VeryLazy',
        },
        -- git signs
        {
            'lewis6991/gitsigns.nvim',
            enabled = false,
            event = 'VeryLazy',
            config = function()
                require('gitsigns').setup {
                    vim.keymap.set(
                        'n',
                        '<leader>gp',
                        ':Gitsigns preview_hunk<cr>',
                        { desc = 'gitsigns - preview hunk' }
                    ),
                    vim.keymap.set(
                        'n',
                        '<leader>gt',
                        ':Gitsigns toggle_current_line_blame<cr>',
                        { desc = 'gitsigns - toggle current line blame' }
                    ),
                }
            end,
        },
        -- { import = 'plugins' },
    },
    checker = { enabled = true, notify = false },
    change_detection = { enabled = true, notify = false },
    lazy = true,
}

-------------------------------------------------------------------------------
-- keymap config
-- tip: use gx to open link in browser
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

keymap.set('n', '<leader>l', ':Lazy<enter>')
keymap.set('n', '<leader>m', ':Mason<enter>')
keymap.set('n', '<leader>e', ':Explore<enter>')

keymap.set(
    'n',
    '<leader>df',
    vim.diagnostic.open_float,
    { desc = 'open float diagnostic' }
)
keymap.set(
    'n',
    '<leader>q',
    vim.diagnostic.setloclist,
    { desc = 'diagnostic set loc list' }
)
keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'go to declaration' })
keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'go to definition' })
keymap.set(
    'n',
    '<leader>k',
    vim.lsp.buf.hover,
    { desc = 'open hover, x2 into hover window, q to exit' }
)
keymap.set(
    'n',
    'gi',
    vim.lsp.buf.implementation,
    { desc = 'go to implementation' }
)
keymap.set(
    'n',
    '<C-k>',
    vim.lsp.buf.signature_help,
    { desc = 'signature help' }
)
vim.keymap.set(
    'n',
    '<leader>wa',
    vim.lsp.buf.add_workspace_folder,
    { desc = 'add add workspace folder' }
)
vim.keymap.set(
    'n',
    '<leader>wr',
    vim.lsp.buf.remove_workspace_folder,
    { desc = 'remove workspace folder' }
)
vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = 'list workspace folders' })
vim.keymap.set(
    'n',
    '<space>D',
    vim.lsp.buf.type_definition,
    { desc = 'type definition' }
)
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { desc = 'rename buffer' })
vim.keymap.set(
    { 'n', 'v' },
    '<leader>a',
    vim.lsp.buf.code_action,
    { desc = 'code action' }
)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'references' })

vim.keymap.set('n', '<leader>i', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle inlay hints' })

-- ctrl w + h,j,k to move among splited window buffer
vim.keymap.set(
    'n',
    '<leader>t',
    ':NvimTreeToggle<enter>',
    { desc = 'Toggle Tree' }
)
