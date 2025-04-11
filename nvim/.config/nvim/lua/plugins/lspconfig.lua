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
    end,
}
