return {
    'hrsh7th/nvim-cmp',
    -- load cmp on InsertEnter
    event = 'InsertEnter',
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
        'neovim/nvim-lspconfig',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-cmdline',
    },
    config = function()
        local cmp = require 'cmp'
        cmp.setup {
            snippet = {},
            mapping = cmp.mapping.preset.insert {
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                -- Accept currently selected item.
                -- Set `select` to `false` to only confirm explicitly selected items.
                -- ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<Enter>'] = cmp.mapping.confirm { select = true },
            },
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'crates' },
            }, {
                { name = 'path' },
                { name = 'buffer' },
            }),
            experimental = {
                ghost_text = true,
            },
        }

        -- Enable completing paths in :
        cmp.setup.cmdline(':', {
            sources = cmp.config.sources {
                { name = 'path' },
            },
        })
    end,
}
