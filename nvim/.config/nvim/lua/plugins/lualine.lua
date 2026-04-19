
require("lualine").setup({
options = {
  -- icons_enabled = false,
    -- theme = "auto",
    -- theme = "gruvbox_dark",
    theme = "powerline",
    section_separators = { left = "", right = "" },
    -- component_separators = { left = "|", right = "|" },
    component_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "lsp_status", "diagnostics" },
    lualine_c = {
      {
        "filename",
        file_status = true,
        newfile_status = true,
        path = 1,
      },
    },
    lualine_x = {
      "branch",
      {
        "diff",
        -- symbols = { added = " ", modified = " ", removed = " " },
      },
    },
    lualine_y = { "encoding", "fileformat", "filetype" },
    lualine_z = {
      -- "searchcount",
      "location",
      "progress",
    },
  },
  extensions = {
    "lazy",
    "fzf",
    "man",
    "mason",
    "fugitive",
    "neo-tree",
    "nvim-dap-ui",
    "oil",
    "trouble",
    "toggleterm",
    "overseer",
    "quickfix",
  },
})

vim.opt.showmode = false
