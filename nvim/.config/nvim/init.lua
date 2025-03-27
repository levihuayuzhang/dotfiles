
local opt = vim.opt
local api = vim.api

opt.number = true
opt.relativenumber = true
opt.clipboard = 'unnamedplus,unnamed'
opt.tabstop = 8
opt.shiftwidth = 8
opt.softtabstop = 8
opt.expandtab = false
opt.ignorecase = true
opt.smartcase = true
opt.undofile = true
opt.vb = true
opt.wrap = false
opt.colorcolumn = '80'
api.nvim_create_autocmd('Filetype', { pattern = 'rust', command = 'set colorcolumn=100' })
api.nvim_create_autocmd('TextYankPost', {
	callback=function ()
		vim.highlight.on_yank({
			timeout=300
		})
	end
})

local keymap = vim.keymap
-- force not using arrow keys
keymap.set('n', '<up>', '<nop>')
keymap.set('n', '<down>', '<nop>')
keymap.set('i', '<up>', '<nop>')
keymap.set('i', '<down>', '<nop>')
keymap.set('i', '<left>', '<nop>')
keymap.set('i', '<right>', '<nop>')
