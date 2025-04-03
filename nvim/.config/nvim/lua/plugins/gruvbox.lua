return {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1001,
    config = function()
        require('gruvbox').setup {
            contrast = 'hard', -- can be "hard", "soft" or empty string
            transparent_mode = true,
            -- transparent_mode = false,
        }
        vim.o.background = 'dark' -- or "light" for light mode
        vim.cmd [[colorscheme gruvbox]]
    end,
}
