vim.loader.enable(true)

if vim.g.vscode then
  require("config.vscode") -- vscode extension
else
  require("config.base")
  require("config.keymap")
  require("config.autocmd") -- set before pack
  require("config.pack")
end
