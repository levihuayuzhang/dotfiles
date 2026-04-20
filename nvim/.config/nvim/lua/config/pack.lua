vim.pack.add({ -- https://neovim.io/doc/user/pack/#vim.pack-examples
  -- "https://github.com/sainnhe/everforest",
  -- "https://github.com/morhetz/gruvbox",
  "https://github.com/ellisonleao/gruvbox.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/xzbdmw/colorful-menu.nvim",
  "https://github.com/saghen/blink.cmp",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/ibhagwan/fzf-lua",
  -- "https://github.com/folke/which-key.nvim",
  "https://github.com/nvim-mini/mini.hipatterns",
  "https://github.com/folke/todo-comments.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/mrcjkb/rustaceanvim",
  "https://github.com/saecki/crates.nvim",
  {
    src = "https://github.com/saghen/blink.pairs",
    version = vim.version.range("*"),
  },
})

require("plugins.theme")
require("plugins.lualine")
require("plugins.fmt")
require("plugins.cmp")
require("plugins.mason")
require("plugins.lsp")
require("plugins.fzf")
-- require("plugins.which-key")
require("plugins.mini")
require("plugins.todo")
require("plugins.treesitter")
require("plugins.markdown")
require("plugins.explorer")
require("plugins.rust")
require("plugins.pairs")

-- https://neovim.io/doc/user/plugins/#standard-plugin-list
vim.cmd.packadd("nvim.tohtml")
vim.cmd.packadd("nvim.undotree")
-- vim.cmd.packadd("spellfile")
-- vim.cmd.packadd("difftool")

vim.keymap.set("n", "<leader>pu", "<cmd>lua vim.pack.update()<cr>")
