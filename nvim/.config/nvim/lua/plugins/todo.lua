vim.keymap.set("n", "<leader>]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "<leader>[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

vim.keymap.set("n", "<leader>tf", "<cmd>TodoFzfLua<cr>", { desc = "TODO search" })
