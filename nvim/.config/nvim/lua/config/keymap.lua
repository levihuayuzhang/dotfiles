-- use gx to open link in browser

local keymap = vim.keymap
-- force not using arrow keys
-- keymap.set('n', '<up>', '<nop>')
-- keymap.set('n', '<down>', '<nop>')
-- keymap.set('i', '<up>', '<nop>')
-- keymap.set('i', '<down>', '<nop>')
-- keymap.set('i', '<left>', '<nop>')
-- keymap.set('i', '<right>', '<nop>')
keymap.set('n', '<leader>l', ':Lazy<enter>')
keymap.set('n', '<leader>m', ':Mason<enter>')
keymap.set('n', '<leader>e', ':Explore<enter>')
