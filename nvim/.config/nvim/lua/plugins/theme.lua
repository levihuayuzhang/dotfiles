-- -- everforest
-- -- if vim.opt.termguicolors then
-- -- enable 24-bit colour
-- vim.opt.termguicolors = true
-- -- end
--
-- vim.g.everforest_transparent_background = 2
-- vim.g.everforest_float_style = "dim"
-- vim.g.everforest_dim_inactive_windows = 1
-- vim.g.everforest_diagnostic_text_highlight = 1
-- vim.g.everforest_diagnostic_line_highlight = 1
-- vim.g.everforest_diagnostic_virtual_text = "highlighted"
-- vim.g.everforest_inlay_hints_background = "dimmed"
-- vim.g.everforest_better_performance = 1
-- vim.g.everforest_enable_italic = 1
-- vim.g.everforest_disable_italic_comment = 0
-- vim.g.everforest_sign_column_background = "grey"
-- -- vim.g.everforest_ui_contrast = "high"
-- -- vim.g:everforest_background = "soft" -- 'hard'
--
-- vim.o.background = "dark" -- or "light" for light mode
-- vim.cmd.colorscheme("everforest")

-- -- gruvbox 256
-- vim.cmd([[set t_Co=256]])
-- vim.g.gruvbox_termcolors = 256
-- vim.g.gruvbox_italic = 1
-- vim.g.gruvbox_transparent_bg = 1
-- vim.g.gruvbox_contrast_dark = "hard"
-- vim.o.background = "dark" -- or "light" for light mode
-- vim.cmd([[colorscheme gruvbox]])

-- gruvbox
-- if opt.termguicolors then
-- enable 24-bit colour
vim.opt.termguicolors = true
-- end

require("gruvbox").setup({
  dim_inactive = false,
  contrast = "hard", -- can be "hard", "soft" or empty string
  -- transparent_mode = true,
})

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

