vim.loader.enable(true)

-- VSCode extension
if vim.g.vscode then
  local opt = vim.opt
  local api = vim.api
  local vscode = require("vscode")

  opt.number = true
  opt.relativenumber = true

  opt.clipboard = "unnamedplus,unnamed"

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
else -- ordinary Neovim
  local opt = vim.opt
  local api = vim.api

  -- https://neovim.io/doc/user/options.html
  opt.number = true
  opt.relativenumber = true

  opt.mouse = "" -- disable mouse
  -- opt.mouse:append("a") -- use mouse scroll to preview in fzf-lua
  -- opt.mousemoveevent = true
  opt.clipboard = "unnamedplus,unnamed"

  opt.hlsearch = true
  opt.incsearch = true
  opt.jumpoptions = "stack"

  opt.shiftwidth = 4
  opt.tabstop = 4
  opt.softtabstop = 4
  opt.expandtab = true
  opt.smartindent = true
  opt.autoindent = true
  opt.copyindent = true

  -- opt.listchars = "space:·,nbsp:○,trail:␣,tab:>-,eol:↵,extends:◣,precedes:◢"
  -- opt.list = true
  -- opt.showbreak = "> "

  opt.ignorecase = true
  opt.smartcase = true

  opt.undofile = true -- ~/.local/state/nvim/undo/
  opt.swapfile = true
  opt.backup = false
  opt.autoread = true
  -- opt.updatetime = 300

  opt.foldenable = false
  opt.foldmethod = "manual"
  opt.foldlevelstart = 99
  -- vim.wo.foldmethod = 'expr'
  -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

  opt.vb = true
  -- opt.laststatus = 3 -- means statuscolumn will only on the bottom
  opt.wrap = false -- display lines as one long line
  opt.signcolumn = "yes"
  opt.colorcolumn = "80"
  -- opt.colorcolumn = { 80, 100 }
  opt.fileencoding = "utf-8"
  -- opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal,globals"
  opt.splitbelow = true
  opt.splitright = true

  opt.scrolloff = 8
  opt.sidescrolloff = 8
  -- opt.cursorline = true
  opt.termguicolors = true

  -- vim.g.loaded_netrw = 1
  -- vim.g.loaded_netrwPlugin = 1

  -- opt.completeopt = { "menuone", "noselect" } -- completion will pop up when there is only one match
  -- opt.conceallevel = 0 -- no hide for ``

  opt.wildmode = "list:longest"
  opt.wildignore = ".hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site"

  -- nvim -d
  opt.diffopt:append("iwhite") -- ignoring whitespace
  opt.diffopt:append("algorithm:histogram")
  opt.diffopt:append("indent-heuristic")

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
      -- api.nvim_set_hl(0, "IlluminatedWordText", { underline = true })
      -- api.nvim_set_hl(0, "IlluminatedWordRead", { underline = true })
      -- api.nvim_set_hl(0, "IlluminatedWordWrite", { underline = true })
      -- vscode like background for same symbols
      api.nvim_set_hl(0, "IlluminatedWordText", { bg = get_visual_highlight_bg_color_hex() })
      api.nvim_set_hl(0, "IlluminatedWordRead", { bg = get_visual_highlight_bg_color_hex() })
      api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = get_visual_highlight_bg_color_hex() })

      api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
      api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
      api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
      api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
      api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
      api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
      api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
    end,
  })

  -- language specific settings
  api.nvim_create_autocmd("Filetype", {
    pattern = "lua",
    callback = function()
      vim.bo.tabstop = 2
      vim.bo.shiftwidth = 2
      vim.bo.softtabstop = 2
      vim.wo.colorcolumn = "80"
    end,
  })
  api.nvim_create_autocmd("Filetype", {
    pattern = "rust",
    command = "set colorcolumn=100",
  })
  api.nvim_create_autocmd("Filetype", {
    pattern = "cpp",
    -- command = "set colorcolumn=100",
    command = "set colorcolumn=80",
  })
  -- set spell check (use `z=` to get suggestions)
  api.nvim_create_autocmd("Filetype", {
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
    -- "markdown",
    -- "gitcommit",
  }) do
    vim.api.nvim_create_autocmd("Filetype", {
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
  api.nvim_create_autocmd("TextYankPost", {
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

  -------------------------------------------------------------------------------
  -- keymap config
  -- tip: use gx to open link in browser
  -- ctrl w + h,j,k,l to move among splited window buffer

  -- set leader keys before lazy
  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"

  local keymap = vim.keymap

  -- force not using arrow keys
  keymap.set("i", "<up>", "<nop>")
  keymap.set("i", "<down>", "<nop>")
  keymap.set("i", "<left>", "<nop>")
  keymap.set("i", "<right>", "<nop>")
  -- completion selection using ctrl+n/p
  keymap.set("n", "<up>", "<nop>")
  keymap.set("n", "<down>", "<nop>")
  -- or use gt / gT to navigate among tabs
  -- keymap.set("n", "<up>", "<cmd>tabprevious<cr>")
  -- keymap.set("n", "<down>", "<cmd>tabnext<cr>")
  -- navigate among buffers
  keymap.set("n", "<left>", "<nop>")
  keymap.set("n", "<right>", "<nop>")
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
  keymap.set("n", "<leader>ll", "<cmd>Lazy<cr>")

  -------------------------------------------------------------------------------
end -- if vim.g.vscode then -- VSCode extension
