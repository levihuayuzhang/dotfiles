-- :help everforest.txt
return {
  'sainnhe/everforest',
  priority = 1000,
  config = function()
    if vim.o.termguicolors then
      vim.o.termguicolors = true
    end
    vim.g.everforest_transparent_background = 2
    vim.g.everforest_float_style = 'dim'
    vim.g.everforest_dim_inactive_windows = 1
    vim.g.everforest_diagnostic_text_highlight = 1
    vim.g.everforest_diagnostic_line_highlight = 1
    vim.g.everforest_diagnostic_virtual_text = 'highlighted'
    vim.g.everforest_inlay_hints_background = 'dimmed'
    vim.g.everforest_better_performance = 1
    vim.g.everforest_enable_italic = 1
    vim.g.everforest_disable_italic_comment = 0
    vim.g.everforest_sign_column_background = 'grey'
    vim.g.everforest_ui_contrast = 'high'
    -- vim.g:everforest_background = 'soft' -- 'hard'
    vim.o.background = 'dark' -- or "light" for light mode
    vim.cmd.colorscheme 'everforest'
  end,
}
