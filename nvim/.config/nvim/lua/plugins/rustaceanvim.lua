return {
    'mrcjkb/rustaceanvim',
    -- version = '^6', -- Recommended
    lazy = false, -- This plugin is already lazy
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
                            closureReturnTypeHints = { enable = 'always' },
                            discriminantHints = { enable = 'always' },
                            expressionAdjustmentHints = { enable = 'always' },
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
            -- dap = {},
        }
    end,
}
