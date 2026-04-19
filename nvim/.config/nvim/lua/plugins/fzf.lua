require("fzf-lua").setup({
  -- https://github.com/ibhagwan/fzf-lua/blob/main/OPTIONS.md
  -- https://github.com/ibhagwan/fzf-lua/tree/main/lua/fzf-lua/profiles
  -- {
  --   "fzf-native",
  --   -- "hide"
  -- }, -- https://github.com/ibhagwan/fzf-lua/issues/1974#issuecomment-2816996592

  -- fzf_opts = { ["--tmux"] = "center,80%,80%" },

  winopts = { preview = { layout = "vertical", vertical = "up:75%" } },

  --[[ -- preview code_actions, set in ~/.gitconfig, require `dandavison/delta`
            [core]
              editor = nvim
                pager = delta
            [interactive]
                diffFilter = delta --color-only
            [delta]
                # dark = true      # or light = true, or omit for auto-detection
                navigate = true  # use n and N to move between diff sections
                line-numbers = true
                side-by-side = true
                hyperlinks = true
            [merge]
                conflictstyle = zdiff3
          --]]
  -- lsp = {
  --   code_actions = {
  --     preview_pager = "delta --navigate --line-numbers --hyperlinks --side-by-side --width=$FZF_PREVIEW_COLUMNS",
  --   },
  -- },
})

vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fr", "<cmd>lua require('fzf-lua').resume()<cr>", { desc = "Resume FZF Work" })
vim.keymap.set("n", "<leader>fll", "<cmd>FzfLua lines<cr>", { desc = "Open Buffers Lines" })
vim.keymap.set("n", "<leader>flb", "<cmd>FzfLua blines<cr>", { desc = "Current Buffer Lines" })
vim.keymap.set("n", "<leader>g", "<cmd>FzfLua blines<cr>", { desc = "Current Buffer Lines" })
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { desc = "Live grep current project" })
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua helptags<cr>", { desc = "Find Helptags" })
vim.keymap.set("n", "<leader>fm", "<cmd>FzfLua manpages<cr>", { desc = "Find Manpages" })
vim.keymap.set("n", "<leader>fk", "<cmd>FzfLua keymaps<cr>", { desc = "Find Keymaps" })
vim.keymap.set("n", "<leader>fc", "<cmd>FzfLua commands<cr>", { desc = "Find Commands" })
vim.keymap.set("n", "<leader>fx", "<cmd>FzfLua changes<cr>", { desc = "Find Changes" })
vim.keymap.set("n", "<leader>fs", "<cmd>FzfLua colorschemes<cr>", { desc = "Color Schemes" })
-- vim.keymap.set("n", "<leader>gf", "<cmd>FzfLua git_files<cr>", { desc = "Git Files" })
-- vim.keymap.set("n", "<leader>gst", "<cmd>FzfLua git_status<cr>", { desc = "Git Status" })
-- vim.keymap.set("n", "<leader>gc", "<cmd>FzfLua git_commits<cr>", { desc = "Git Commits" })
-- vim.keymap.set("n", "<leader>gbc", "<cmd>FzfLua git_bcommits<cr>", { desc = "Git Buffer Commits" })
-- vim.keymap.set("n", "<leader>gbb", "<cmd>FzfLua git_blame<cr>", { desc = "Git Buffer Blame" })
-- vim.keymap.set("n", "<leader>gss", "<cmd>FzfLua git_stash<cr>", { desc = "Git Stash" })
-- vim.keymap.set("n", "<leader>gbr", "<cmd>FzfLua git_branches<cr>", { desc = "Git Branches" })
vim.keymap.set(
  "n",
  "<leader>ft",
  -- vim.lsp.buf.declaration,
  "<cmd>FzfLua tmux_buffers<cr>",
  { desc = "list tmux paste buffers" }
)
