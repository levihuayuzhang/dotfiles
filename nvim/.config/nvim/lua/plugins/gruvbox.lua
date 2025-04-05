return {
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
}
