require("conform").setup({
  default_format_opts = {
    lsp_format = "fallback",
  },
  format_on_save = function()
    local fname = vim.fn.expand("%:t")
    if fname == "xmake.lua" then
      return
    end
    return {
      timeout_ms = 300,
      async = false,
      quiet = false,
      lsp_format = "fallback",
    }
  end,
  -- format_after_save = function()
  --   local fname = vim.fn.expand("%:t")
  --   if fname == "xmake.lua" then
  --     return
  --   end
  --   return {
  --     lsp_format = "fallback",
  --   }
  -- end,
  notify_on_error = true,
  notify_no_formatters = true,
  formatters_by_ft = {
    cpp = { lsp_format = "prefer", "clang-format" },
    rust = { lsp_format = "prefer", "rustfmt" },
    lua = { "stylua" },
    python = function(bufnr)
      if require("conform").get_formatter_info("ruff_format", bufnr).available then
        return { "ruff_format" }
      else
        return { "isort", "black" }
      end
    end,
    javascript = {
      "prettier",
      "prettier",
      stop_after_first = true,
    },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    jsonc = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    graphql = { "prettier" },
    tex = { "tex-fmt" },
    bib = { "tex-fmt" },
    cls = { "tex-fmt" },
    sty = { "tex-fmt" },
    sh = { "shfmt" },
  },
  formatters = {
    black = {
      prepend_args = { "--fast" },
    },
  },
})

vim.keymap.set("n", "<leader>lc", "<cmd>ConformInfo<cr>", { desc = "Conform Info" })
