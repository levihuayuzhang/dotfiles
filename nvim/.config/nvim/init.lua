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
opt.copyindent = false

opt.listchars =
  'space:·,nbsp:○,trail:␣,tab:>-,eol:↵,extends:◣,precedes:◢'
opt.list = true
opt.showbreak = '> '

opt.ignorecase = true
opt.smartcase = true

opt.undofile = true
opt.swapfile = true
opt.autoread = true

opt.vb = true
opt.wrap = false
opt.signcolumn = 'yes'
opt.colorcolumn = '80'
-- opt.colorcolumn = { 80, 100 }

opt.scrolloff = 6
opt.sidescrolloff = 6
opt.cursorline = true
-- enable 24-bit colour
opt.termguicolors = true

api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })

api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank {
      timeout = 300,
    }
  end,
})
api.nvim_create_autocmd('Filetype', {
  pattern = 'lua',
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.wo.colorcolumn = '80'
  end,
})
api.nvim_create_autocmd('Filetype', {
  pattern = 'rust',
  command = 'set colorcolumn=100',
})

vim.diagnostic.config {
  virtual_text = true,
  -- virtual_lines = true,
  -- update_in_insert = true,
}
-- vim.lsp.inlay_hint.enable(true) -- enable globally

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

        vim.o.background = 'dark' -- or "light" for light mode
        vim.cmd [[colorscheme gruvbox]]
      end,
    },
    -- status line below
    {
      'nvim-lualine/lualine.nvim',
      lazy = false,
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
            globalstatus = true,
            refresh = {
              statusline = 100,
              tabline = 100,
              winbar = 100,
            },
          },
          sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { 'filename' },
            lualine_x = { 'lsp_status', 'encoding', 'fileformat', 'filetype' },
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
            -- 'eslint',
            -- 'marksman',
          },
          automatic_installation = true,
        }
      end,
    },
    -- nvim-lspconfig (work with presets)
    -- if any tools not available with system package manager
    -- use mason to install and this to config
    {
      'neovim/nvim-lspconfig',
      event = { 'BufReadPost', 'BufNewFile' },
      cmd = { 'LspInfo', 'LspInstall', 'LspUninstall' },
      dependencies = {
        'williamboman/mason-lspconfig.nvim',
      },
      opts = {
        inlay_hints = {
          enabled = true, -- just for nvim-lspconfig
        },
      },
      config = function(_, opts)
        local lspconfig = require 'lspconfig'

        -- rust
        -- local lsp_work_by_client_id = {}
        -- local time = 0
        -- local _ran_once = {}
        lspconfig.rust_analyzer.setup {
          settings = {
            ['rust-analyzer'] = {
              diagnostics = {
                enable = true,
                experimental = { enable = true },
                styleLints = { enable = true },
              },
              cargo = { features = 'all' },
              checkOnSave = true,
              check = {
                command = 'clippy',
                features = 'all',
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
                maxLength = { '' },
                reborrowHints = { enable = 'always' },
                renderColons = { enable = true },
                lifetimeElisionHints = {
                  enable = true,
                  useParameterNames = true,
                },
              },
            },
          },
        }

        -- Python
        -- https://docs.astral.sh/ruff/editors/setup/#neovim
        lspconfig.ruff.setup {}
        -- pyright
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
        lspconfig.clangd.setup {
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
          on_attach = function(_, bufnr)
            if opts.inlay_hints.enabled then
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
            local result =
              vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params)
            for cid, res in pairs(result or {}) do
              for _, r in pairs(res.result or {}) do
                if r.edit then
                  local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding
                    or 'utf-16'
                  vim.lsp.util.apply_workspace_edit(r.edit, enc)
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
          on_attach = function(_, bufnr)
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
              runtime = {
                version = 'LuaJIT',
              },
              diagnostics = {
                globals = { 'vim' },
              },
            },
          },
          capabilities = vim.lsp.protocol.make_client_capabilities(),
        }
      end,
    },
    -- completion
    {
      'saghen/blink.cmp',
      event = 'VeryLazy',
      build = 'cargo build --release',
      dependencies = { 'rafamadriz/friendly-snippets' },
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
        fuzzy = { implementation = 'rust' },
        cmdline = {
          enabled = true,
          keymap = {
            preset = 'super-tab',
          },
          completion = { menu = { auto_show = true } },
        },
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
                require('conform').get_formatter_info('ruff_format', bufnr).available
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
            json = { 'prettierd' },
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
              'rust',
              'latex',
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
                -- 'latex', -- use vimtex
              },
              additional_vim_regex_highlighting = true,
            },
            autotag = {
              enable = true,
            },
            indent = {
              enable = true,
            },
          }
        end,
      },
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
    -- fuzzy finding, lua version
    {
      'ibhagwan/fzf-lua',
      event = 'VeryLazy',
      dependencies = {
        'nvim-tree/nvim-web-devicons',
        {
          'skim-rs/skim',
          build = './install',
        },
        {
          'junegunn/fzf',
          build = './install --all',
        },
      },
      config = function()
        require('fzf-lua').setup {
          'fzf-native', -- https://github.com/ibhagwan/fzf-lua/tree/main/lua/fzf-lua/profiles

          -- fzf_bin = 'sk',

          -- opens in a tmux popup (requires tmux > 3.2)
          fzf_opts = { ['--border'] = 'rounded', ['--tmux'] = 'center,80%,60%' },
        }
      end,
    },
    -- keymap hints
    {
      'folke/which-key.nvim',
      -- enabled = false,
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      event = 'VeryLazy',
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
      ft = 'markdown',
      dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons',
      }, -- if you prefer nvim-web-devicons
      opts = {},
    },
    -- latex support
    {
      'lervag/vimtex',
      ft = 'tex',
      init = function()
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
      end,
      keys = {
        { '<localLeader>l', '', desc = '+vimtex', ft = 'tex' },
      },
    },
  },
  install = { colorscheme = { 'everforest' } },
  checker = { enabled = true, notify = false },
  change_detection = { enabled = true, notify = false },
  defaults = { lazy = true },
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

keymap.set('n', '<leader>ll', ':Lazy<enter>')
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

vim.keymap.set('n', '<leader>li', ':LspInfo<enter>', { desc = 'LSP info' })

vim.keymap.set(
  'n',
  '<leader>ff',
  '<cmd>FzfLua files<cr>',
  { desc = 'Find Files' }
)
vim.keymap.set(
  'n',
  '<leader>fll',
  '<cmd>FzfLua lines<cr>',
  { desc = 'Open Buffers Lines' }
)
vim.keymap.set(
  'n',
  '<leader>flb',
  '<cmd>FzfLua blines<cr>',
  { desc = 'Current Buffer Lines' }
)
vim.keymap.set(
  'n',
  '<leader>fg',
  '<cmd>FzfLua live_grep<cr>',
  { desc = 'Live grep current project' }
)
vim.keymap.set(
  'n',
  '<leader>fb',
  '<cmd>FzfLua buffers<cr>',
  { desc = 'Find Buffers' }
)
vim.keymap.set(
  'n',
  '<leader>fh',
  '<cmd>FzfLua helptags<cr>',
  { desc = 'Find Helptags' }
)
vim.keymap.set(
  'n',
  '<leader>fm',
  ':FzfLua manpages<enter>',
  { desc = 'Find Manpages' }
)
vim.keymap.set(
  'n',
  '<leader>fc',
  ':FzfLua commands<enter>',
  { desc = 'Find Commands' }
)
vim.keymap.set(
  'n',
  '<leader>fs',
  '<cmd>FzfLua colorschemes<cr>',
  { desc = 'Color Schemes' }
)
vim.keymap.set(
  'n',
  '<leader>gf',
  '<cmd>FzfLua git_files<enter>',
  { desc = 'Git Files' }
)
vim.keymap.set(
  'n',
  '<leader>gst',
  '<cmd>FzfLua git_status<enter>',
  { desc = 'Git Status' }
)
vim.keymap.set(
  'n',
  '<leader>gc',
  '<cmd>FzfLua git_commits<enter>',
  { desc = 'Git Commits' }
)
vim.keymap.set(
  'n',
  '<leader>gbc',
  '<cmd>FzfLua git_bcommits<enter>',
  { desc = 'Git Buffer Commits' }
)
vim.keymap.set(
  'n',
  '<leader>gbb',
  '<cmd>FzfLua git_blame<enter>',
  { desc = 'Git Buffer Blame' }
)
vim.keymap.set(
  'n',
  '<leader>gss',
  '<cmd>FzfLua git_stash<enter>',
  { desc = 'Git Stash' }
)
vim.keymap.set(
  'n',
  '<leader>gbr',
  '<cmd>FzfLua git_branches	<enter>',
  { desc = 'Git Branches' }
)
