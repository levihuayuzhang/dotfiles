return {
    'neovim/nvim-lspconfig',
    config = function()
        local lspconfig = require 'lspconfig'

        -- Rust
        lspconfig.rust_analyzer.setup {
            -- Server-specific settings. See `:help lspconfig-setup`
            settings = {
                ['rust-analyzer'] = {
                    cargo = {
                        allFeatures = true,
                    },
                    imports = {
                        group = {
                            enable = false,
                        },
                    },
                    completion = {
                        postfix = {
                            enable = false,
                        },
                    },
                },
            },
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

        -- Global mappings.
        -- See `:help vim.diagnostic.*` for documentation on any of the below functions
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

        -- Use LspAttach autocommand to only map the following keys
        -- after the language server attaches to the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                -- Enable completion triggered by <c-x><c-o>
                vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf }
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                vim.keymap.set(
                    'n',
                    '<leader>wa',
                    vim.lsp.buf.add_workspace_folder,
                    opts
                )
                vim.keymap.set(
                    'n',
                    '<leader>wr',
                    vim.lsp.buf.remove_workspace_folder,
                    opts
                )
                vim.keymap.set('n', '<leader>wl', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, opts)
                --vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
                vim.keymap.set(
                    { 'n', 'v' },
                    '<leader>a',
                    vim.lsp.buf.code_action,
                    opts
                )
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', '<leader>f', function()
                    vim.lsp.buf.format { async = true }
                end, opts)

                local client = vim.lsp.get_client_by_id(ev.data.client_id)

                client.server_capabilities.semanticTokensProvider = nil
            end,
        })
    end,
}
