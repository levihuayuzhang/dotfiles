
require("mason").setup({})
vim.keymap.set("n", "<leader>m", "<cmd>Mason<cr>", {desc = "Open Mason"})


require("mason-lspconfig").setup({
  ensure_installed = {
    -- "rust_analyzer",
    -- "clangd",
    -- "ruff",
    -- "pyright",
    -- "lua_ls",
    -- "texlab",
    -- "asm_lsp",
    -- "gopls",
    -- 'eslint',
    -- 'marksman',
  },
  automatic_installation = true,
})
