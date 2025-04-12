local opt = vim.opt
local api = vim.api

-- opt.syntax = 'on'
opt.number = true
opt.relativenumber = true

opt.mouse:append 'a'
opt.clipboard = 'unnamedplus,unnamed'

opt.hlsearch = true
opt.incsearch = true

opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.autoindent = true
opt.listchars =
    'space:·,nbsp:○,trail:␣,tab:>-,eol:↵,extends:◣,precedes:◢'
opt.list = true

opt.ignorecase = true
opt.smartcase = true

opt.undofile = true
opt.swapfile = true
opt.autoread = true
vim.bo.autoread = true

opt.vb = true
opt.wrap = false
opt.signcolumn = 'yes'
opt.colorcolumn = '80'
api.nvim_create_autocmd(
    'Filetype',
    { pattern = 'rust', command = 'set colorcolumn=100' }
)

api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank {
            timeout = 300,
        }
    end,
})

opt.scrolloff = 5
opt.sidescrolloff = 5
opt.cursorline = true
-- enable 24-bit colour
opt.termguicolors = true
vim.diagnostic.config { virtual_text = true }
