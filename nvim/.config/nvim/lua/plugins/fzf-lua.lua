return {
    'ibhagwan/fzf-lua',
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
}
