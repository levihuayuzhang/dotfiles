-- VSCode extension
local vscode = require("vscode")

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.clipboard = "unnamedplus,unnamed"

-- highlight while yank
vim.api.nvim_create_autocmd("TextYankPost", {
callback = function()
vim.highlight.on_yank({
timeout = 300,
})
end,
})

-- set leader keys before lazy
-- `cmd/ctrl + shift + space` for fuction signatures
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
local keymap = vim.keymap
vim.keymap.set({ "n", "x" }, "<leader>k", function()
vscode.action("editor.action.showHover")
end)
-- vim.keymap.set({ "n", "x" }, "<leader>r", function()
--   vscode.action("editor.action.rename")
-- end)
vim.keymap.set({ "n", "x" }, "[d", function()
vscode.action("editor.action.marker.prev")
end)
vim.keymap.set({ "n", "x" }, "]d", function()
vscode.action("editor.action.marker.next")
end)
vim.keymap.set({ "n", "x" }, "<leader>a", function()
vscode.action("editor.action.quickFix")
end)

-- rust-analyzer
vim.keymap.set({ "n", "x" }, "<leader>e", function()
vscode.call("rust-analyzer.expandMacro") -- vscode keymap right click -> Copy Command ID
vscode.call("workbench.action.focusNextGroup")
end)
vim.keymap.set({ "n", "x" }, "<leader>h", function()
vscode.call("rust-analyzer.viewHir")
vscode.call("workbench.action.focusNextGroup")
end)
vim.keymap.set({ "n", "x" }, "<leader>m", function()
vscode.call("rust-analyzer.viewMir")
vscode.call("workbench.action.focusNextGroup")
end)
vim.keymap.set({ "n", "x" }, "<leader>rm", function()
vscode.call("rust-analyzer.rebuildProcMacros")
end)
vim.keymap.set({ "n", "x" }, "<leader>od", function()
vscode.call("rust-analyzer.openDocs")
end)
vim.keymap.set({ "n", "x" }, "<leader>oc", function()
vscode.call("rust-analyzer.openCargoToml")
end)
vim.keymap.set({ "n", "x" }, "<leader>cg", function()
vscode.call("rust-analyzer.viewFullCrateGraph")
end)
vim.keymap.set({ "n", "x" }, "<leader>ml", function()
vscode.call("rust-analyzer.viewMemoryLayout")
end)
vim.keymap.set({ "n", "x" }, "<leader>mu", function()
vscode.call("rust-analyzer.memoryUsage")
end)
vim.keymap.set({ "n", "x" }, "<leader>pm", function()
vscode.call("rust-analyzer.parentModule")
end)
vim.keymap.set({ "n", "x" }, "<leader>cm", function()
vscode.call("rust-analyzer.childModules")
end)
vim.keymap.set({ "n", "x" }, "<leader>st", function()
vscode.call("rustSyntaxTree.focus")
end)
vim.keymap.set({ "n", "x" }, "<leader>pt", function()
vscode.call("rust-analyzer.peekTests")
end)
vim.keymap.set({ "n", "x" }, "<leader>rr", function()
vscode.call("rust-analyzer.run")
end)
vim.keymap.set({ "n", "x" }, "<leader>rf", function()
vscode.call("rust-analyzer.runFlycheck")
end)
vim.keymap.set({ "n", "x" }, "<leader>tc", function()
vscode.call("rust-analyzer.toggleCheckOnSave")
end)
vim.keymap.set({ "n", "x" }, "<leader>ssr", function()
vscode.call("rust-analyzer.ssr")
end)
