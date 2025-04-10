return {
    'stevearc/conform.nvim',
    lazy = true,
    event = { 'BufWritePre', 'BufReadPre', 'BufNewFile' }, -- to disable, comment this out
    config = function()
        require('conform').setup {
            formatters_by_ft = {
                rust = { 'rustfmt', lsp_format = 'fallback' },
                python = { 'isort', 'black' },
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
            format_on_save = {
                -- These options will be passed to conform.format()
                -- timeout_ms = 500,
                lsp_format = 'fallback',
            },
            formatters = {
                black = {
                    prepend_args = { '--fast' },
                },
            },
        }
    end,
}
