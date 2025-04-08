return {
  'lervag/vimtex',
  lazy = false, -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.vimtex_mappings_disable = { ['n'] = { 'K' } } -- disable `K` as it conflicts with LSP hover
    -- vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_view_general_viewer = 'sioyek'
    vim.g.vimtex_view_method = 'sioyek'
    vim.g.vimtex_compiler_method = 'latexmk'
    vim.g.vimtex_compiler_latexmk = {
      options = {
        '-synctex=1',
        '-interaction=nonstopmode',
        -- '-file-line-error',
        '-xelatex',
        -- "-pdf",
        '-outdir=./build',
      },
    }
    vim.g.vimtex_quickfix_open_on_warning = 0
    -- vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
  end,
  keys = {
    { '<localLeader>l', '', desc = '+vimtex', ft = 'tex' },
  },
}
