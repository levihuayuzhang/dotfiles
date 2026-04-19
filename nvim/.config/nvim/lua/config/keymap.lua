  -- keymap config
  -- tip: use gx to open link in browser
  -- ctrl w + h,j,k,l to move among splited window buffer

  -- set leader keys before lazy
  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"


  -- force not using arrow keys
  vim.keymap.set("i", "<up>", "<nop>")
  vim.keymap.set("i", "<down>", "<nop>")
  vim.keymap.set("i", "<left>", "<nop>")
  vim.keymap.set("i", "<right>", "<nop>")
  -- completion selection using ctrl+n/p
  vim.keymap.set("n", "<up>", "<nop>")
  vim.keymap.set("n", "<down>", "<nop>")
  -- or use gt / gT to navigate among tabs
  -- vim.keymap.set("n", "<up>", "<cmd>tabprevious<cr>")
  -- vim.keymap.set("n", "<down>", "<cmd>tabnext<cr>")
  -- navigate among buffers
  vim.keymap.set("n", "<left>", "<nop>")
  vim.keymap.set("n", "<right>", "<nop>")
  -- vim.keymap.set("n", "<left>", ":bp<cr>")
  -- vim.keymap.set("n", "<right>", ":bn<cr>")
  -- -- toggle between (most recent two) buffers
  vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
  vim.keymap.set("n", "<leader><leader>", "<c-6>")

  local jit = require("jit")
  if jit.os == "Linux" then -- wayland clipboard
    vim.keymap.set("n", "<leader>c", "<cmd>w !wl-copy<cr><cr>")
    vim.keymap.set("n", "<leader>p", "<cmd>read !wl-paste<cr>")
  end

  -- keymap.set("n", "<leader>e", "<cmd>Explore<cr>") -- netrw disabled
  vim.keymap.set("n", "<leader>ll", "<cmd>Lazy<cr>")

