return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'mason.nvim',
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

        -- Python ruff: https://docs.astral.sh/ruff/editors/setup/
        lspconfig.ruff.setup {}

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
                    and client:supports_method(methods.textDocument_inlayHint)
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

        --[[ -- Global mappings.
        -- See `:help vim.diagnostic.*` for documentation on any of the below functions
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
        vim.diagnostic.config { virtual_text = true }

        -- Use LspAttach autocommand to only map the following keys
        -- after the language server attaches to the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                -- Enable completion triggered by <c-x><c-o>
                vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local optss = { buffer = ev.buf }
                -- use <c-t> or <c-o> or <c-i> to jump back
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, optss)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, optss)
                -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, optss)
                vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, optss)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, optss)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, optss)
                vim.keymap.set(
                    'n',
                    '<leader>wa',
                    vim.lsp.buf.add_workspace_folder,
                    optss
                )
                vim.keymap.set(
                    'n',
                    '<leader>wr',
                    vim.lsp.buf.remove_workspace_folder,
                    optss
                )
                vim.keymap.set('n', '<leader>wl', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, optss)
                --vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, optss)
                vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, optss)
                vim.keymap.set(
                    { 'n', 'v' },
                    '<leader>a',
                    vim.lsp.buf.code_action,
                    optss
                )
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, optss)
                vim.keymap.set('n', '<leader>f', function()
                    vim.lsp.buf.format { async = true }
                end, optss)
                -- keymap for inlay hint switch
                vim.keymap.set('n', '<leader>h', function()
                    vim.lsp.inlay_hint.enable(
                        not vim.lsp.inlay_hint.is_enabled()
                    )
                end, { desc = 'Toggle inlay hints' })

                -- local client = vim.lsp.get_client_by_id(ev.data.client_id)
                -- client.server_capabilities.semanticTokensProvider = nil
            end,
        }) ]]
    end,
}
