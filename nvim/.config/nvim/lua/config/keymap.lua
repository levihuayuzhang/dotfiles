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

keymap.set(
    'n',
    '<leader>df',
    vim.diagnostic.open_float,
    { desc = 'open float diagnostic' }
)
keymap.set(
    'n',
    '<leader>q',
    vim.diagnostic.setloclist,
    { desc = 'diagnostic set loc list' }
)
keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'go to declaration' })
keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'go to definition' })
keymap.set(
    'n',
    '<leader>k',
    vim.lsp.buf.hover,
    { desc = 'open hover, x2 into hover window, q to exit' }
)
keymap.set(
    'n',
    'gi',
    vim.lsp.buf.implementation,
    { desc = 'go to implementation' }
)
keymap.set(
    'n',
    '<C-k>',
    vim.lsp.buf.signature_help,
    { desc = 'signature help' }
)
vim.keymap.set(
    'n',
    '<leader>wa',
    vim.lsp.buf.add_workspace_folder,
    { desc = 'add add workspace folder' }
)
vim.keymap.set(
    'n',
    '<leader>wr',
    vim.lsp.buf.remove_workspace_folder,
    { desc = 'remove workspace folder' }
)
vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = 'list workspace folders' })
vim.keymap.set(
    'n',
    '<space>D',
    vim.lsp.buf.type_definition,
    { desc = 'type definition' }
)
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { desc = 'rename buffer' })
vim.keymap.set(
    { 'n', 'v' },
    '<leader>a',
    vim.lsp.buf.code_action,
    { desc = 'code action' }
)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'references' })
--[[ vim.keymap.set('n', '<leader>f', function()
    vim.lsp.buf.format { async = true }
end, { desc = 'format buffer' }) ]]

-- keymap for inlay hint switch
vim.keymap.set('n', '<leader>i', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle inlay hints' })

-- ctrl w + h,j,k to move among splited window buffer
vim.keymap.set(
    'n',
    '<leader>to',
    ':NvimTreeOpen<enter>',
    { desc = 'Open Tree' }
)

vim.keymap.set(
    'n',
    '<leader>tq',
    ':NvimTreeClose<enter>',
    { desc = 'Close Tree' }
)
