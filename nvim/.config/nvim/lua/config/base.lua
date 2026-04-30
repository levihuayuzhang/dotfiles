-- https://neovim.io/doc/user/options.html
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = "" -- disable mouse
-- vim.opt.mouse:append("a") -- use mouse scroll to preview in fzf-lua
-- vim.opt.mousemoveevent = true
vim.opt.clipboard = "unnamedplus,unnamed"

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.jumpoptions = "stack"

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.copyindent = true

-- vim.opt.listchars = "space:·,nbsp:○,trail:␣,tab:>-,eol:↵,extends:◣,precedes:◢"
-- vim.opt.list = true
-- vim.opt.showbreak = "> "

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.undofile = true -- ~/.local/state/nvim/undo/
vim.opt.swapfile = true
vim.opt.backup = false
vim.opt.autoread = true
-- vim.opt.updatetime = 300

vim.opt.foldenable = false
vim.opt.foldmethod = "manual"
vim.opt.foldlevelstart = 99
-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

vim.opt.vb = true
-- vim.opt.laststatus = 3 -- means statuscolumn will only on the bottom
vim.opt.wrap = false -- display lines as one long line
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"
-- vim.opt.colorcolumn = { 80, 100 }
vim.opt.fileencoding = "utf-8"
-- vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal,globals"
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
-- opt.cursorline = true
vim.opt.termguicolors = true

-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- vim.opt.completeopt = { "menuone", "noselect" } -- completion will pop up when there is only one match
-- vim.opt.conceallevel = 0 -- no hide for ``

vim.opt.wildmode = "list:longest"
vim.opt.wildignore = ".hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site"

-- nvim -d
vim.opt.diffopt:append("iwhite") -- ignoring whitespace
vim.opt.diffopt:append("algorithm:histogram")
vim.opt.diffopt:append("indent-heuristic")

local function get_visual_highlight_bg_color_hex()
  local visual_hl = vim.api.nvim_get_hl(0, { name = "Visual" })
  local visual_bg = visual_hl.bg
  -- print("decimal of visual highlight bg is " .. visual_bg)
  local visual_bg_hex = string.format("#%06x", visual_bg)
  -- print("hex of visual highlight bg is " .. visual_bg_hex)
  return visual_bg_hex
end
-- override color
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = { "*" },
  callback = function()
    -- vim.api.nvim_set_hl(0, "IlluminatedWordText", { underline = true })
    -- vim.api.nvim_set_hl(0, "IlluminatedWordRead", { underline = true })
    -- vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { underline = true })
    -- vscode like background for same symbols
    vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = get_visual_highlight_bg_color_hex() })
    vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = get_visual_highlight_bg_color_hex() })
    vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = get_visual_highlight_bg_color_hex() })

    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
  end,
})

-- language specific settings
vim.api.nvim_create_autocmd("Filetype", {
  pattern = "lua",
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.wo.colorcolumn = "80"
  end,
})
vim.api.nvim_create_autocmd("Filetype", {
  pattern = "rust",
  command = "set colorcolumn=100",
})
vim.api.nvim_create_autocmd("Filetype", {
  pattern = "cpp",
  -- command = "set colorcolumn=100",
  command = "set colorcolumn=80",
})
-- set spell check (use `z=` to get suggestions)
vim.api.nvim_create_autocmd("Filetype", {
  pattern = "tex",
  callback = function()
    vim.g.tex_flavor = "latex"
    -- vim.wo.spell = true
    -- vim.bo.spelllang = "en_us"
    vim.bo.textwidth = 80
    vim.wo.colorcolumn = "81"
  end,
})
-- -- email
-- local email = vim.api.nvim_create_augroup('email', { clear = true })
-- vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
--   pattern = '/tmp/mutt*',
--   group = email,
--   command = 'setfiletype mail',
-- })
-- vim.api.nvim_create_autocmd('Filetype', {
--   pattern = 'mail',
--   group = email,
--   command = 'setlocal formatoptions+=w',
-- })

-- shorter columns in text because it reads better that way
local text = vim.api.nvim_create_augroup("text", { clear = true })
for _, pat in ipairs({
  "text",
  "mail",
  "gitcommit",
}) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = pat,
    group = text,
    callback = function()
      vim.wo.spell = true
      vim.bo.spelllang = "en_us"
      vim.bo.textwidth = 72
      vim.wo.colorcolumn = "73"
      vim.wo.wrap = true
    end,
  })
end

-- highlight while yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({
      timeout = 300,
    })
  end,
})

-------------------------------------------------------------------------------
-- vim.lsp.set_log_level("OFF") -- "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF"
-- vim.lsp.inlay_hint.enable(true) -- enable globally

vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  float = true,
  -- virtual_lines = true,
  -- update_in_insert = true,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "󰌶",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
})
