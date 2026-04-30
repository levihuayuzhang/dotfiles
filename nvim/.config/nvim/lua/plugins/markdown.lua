vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.wo.spell = true
    vim.bo.spelllang = "en_us"
    vim.bo.textwidth = 72
    vim.wo.colorcolumn = "73"
    vim.wo.wrap = true

    require("render-markdown").setup({})
  end,
})
