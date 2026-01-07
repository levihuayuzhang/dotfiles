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
  vim.keymap.set({ "n", "x" }, "<leader>r", function()
    vscode.action("editor.action.rename")
  end)
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
  vim.keymap.set({ "n", "x" }, "<leader>re", function()
    vscode.call("rust-analyzer.expandMacro") -- vscode keymap right click -> Copy Command ID
    vscode.call("workbench.action.focusNextGroup")
  end)
  vim.keymap.set({ "n", "x" }, "<leader>rh", function()
    vscode.call("rust-analyzer.viewHir")
    vscode.call("workbench.action.focusNextGroup")
  end)
  vim.keymap.set({ "n", "x" }, "<leader>rm", function()
    vscode.call("rust-analyzer.viewMir")
    vscode.call("workbench.action.focusNextGroup")
  end)
  vim.keymap.set({ "n", "x" }, "<leader>rb", function()
    vscode.call("rust-analyzer.rebuildProcMacros")
  end)
  vim.keymap.set({ "n", "x" }, "<leader>rod", function()
    vscode.call("rust-analyzer.openDocs")
  end)
  vim.keymap.set({ "n", "x" }, "<leader>roc", function()
    vscode.call("rust-analyzer.openCargoToml")
  end)
  vim.keymap.set({ "n", "x" }, "<leader>rcg", function()
    vscode.call("rust-analyzer.viewFullCrateGraph")
  end)
  vim.keymap.set({ "n", "x" }, "<leader>rml", function()
    vscode.call("rust-analyzer.viewMemoryLayout")
  end)
  vim.keymap.set({ "n", "x" }, "<leader>rmu", function()
    vscode.call("rust-analyzer.memoryUsage")
  end)
  vim.keymap.set({ "n", "x" }, "<leader>rpm", function()
    vscode.call("rust-analyzer.parentModule")
  end)
  vim.keymap.set({ "n", "x" }, "<leader>rcm", function()
    vscode.call("rust-analyzer.childModules")
  end)
  vim.keymap.set({ "n", "x" }, "<leader>rst", function()
    vscode.call("rustSyntaxTree.focus")
  end)
  vim.keymap.set({ "n", "x" }, "<leader>rpt", function()
    vscode.call("rust-analyzer.peekTests")
  end)
  vim.keymap.set({ "n", "x" }, "<leader>rr", function()
    vscode.call("rust-analyzer.run")
  end)
  vim.keymap.set({ "n", "x" }, "<leader>rf", function()
    vscode.call("rust-analyzer.runFlycheck")
  end)
  vim.keymap.set({ "n", "x" }, "<leader>rtc", function()
    vscode.call("rust-analyzer.toggleCheckOnSave")
  end)
  vim.keymap.set({ "n", "x" }, "<leader>rssr", function()
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
  -- lazy config
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--branch=stable",
      lazyrepo,
      lazypath,
    })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup({
    spec = {
      -- -- -- :help everforest.txt
      -- {
      --   "sainnhe/everforest",
      --   enabled = false,
      --   lazy = false,
      --   priority = 1000,
      --   config = function()
      --     -- if opt.termguicolors then
      --     -- enable 24-bit colour
      --     opt.termguicolors = true
      --     -- end
      --
      --     vim.g.everforest_transparent_background = 2
      --     vim.g.everforest_float_style = "dim"
      --     vim.g.everforest_dim_inactive_windows = 1
      --     vim.g.everforest_diagnostic_text_highlight = 1
      --     vim.g.everforest_diagnostic_line_highlight = 1
      --     vim.g.everforest_diagnostic_virtual_text = "highlighted"
      --     vim.g.everforest_inlay_hints_background = "dimmed"
      --     vim.g.everforest_better_performance = 1
      --     vim.g.everforest_enable_italic = 1
      --     vim.g.everforest_disable_italic_comment = 0
      --     vim.g.everforest_sign_column_background = "grey"
      --     -- vim.g.everforest_ui_contrast = "high"
      --     -- vim.g:everforest_background = "soft" -- 'hard'
      --
      --     vim.o.background = "dark" -- or "light" for light mode
      --     vim.cmd.colorscheme("everforest")
      --   end,
      -- },
      -- for 256 colors terminals (not support true color)
      -- {
      --   "morhetz/gruvbox",
      --   enabled = false,
      --   lazy = false,
      --   config = function()
      --     vim.cmd([[set t_Co=256]])
      --     vim.g.gruvbox_termcolors = 256
      --     vim.g.gruvbox_italic = 1
      --     vim.g.gruvbox_transparent_bg = 1
      --     vim.g.gruvbox_contrast_dark = "hard"
      --     vim.o.background = "dark" -- or "light" for light mode
      --     vim.cmd([[colorscheme gruvbox]])
      --   end,
      -- },
      {
        "ellisonleao/gruvbox.nvim",
        -- enabled = false,
        lazy = false,
        priority = 1000,
        config = function()
          -- if opt.termguicolors then
          -- enable 24-bit colour
          opt.termguicolors = true
          -- end

          require("gruvbox").setup({
            dim_inactive = false,
            contrast = "hard", -- can be "hard", "soft" or empty string
            -- transparent_mode = true,
          })

          vim.o.background = "dark" -- or "light" for light mode
          vim.cmd([[colorscheme gruvbox]])
        end,
      },
      {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = {
          {
            "nvim-tree/nvim-web-devicons",
            -- event = "VeryLazy",
          },
        },
        config = function()
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

          opt.showmode = false
        end,
      },
      {
        "williamboman/mason.nvim",
        event = "VeryLazy",
        keys = {
          { "<leader>m", ":Mason<enter>", desc = "Open Mason" },
        },
        config = function()
          require("mason").setup({})
        end,
      },
      {
        "williamboman/mason-lspconfig.nvim",
        lazy = true,
        dependencies = {
          "williamboman/mason.nvim",
        },
        config = function()
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
        end,
      },
      {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "LspInfo", "LspInstall", "LspUninstall" },
        dependencies = {
          "williamboman/mason-lspconfig.nvim",
          "saghen/blink.cmp",
          "fzf-lua",
        },
        config = function()
          vim.lsp.semantic_tokens.enable = true

          -- https://neovim.io/doc/user/lsp.html#vim.lsp.config()
          local servers = {
            -- "rust_analyzer",
            "clangd",
            "ty",
            "ruff",
            "pyright",
            "lua_ls",
            "asm_lsp",
            -- "texlab",
            -- "mutt_ls",
            "bashls",
            "cmake",
            -- "ocamllsp",
            -- "vsrocq",
            -- "fortls",
            -- "ts_ls",
            "nixd",
          }
          vim.lsp.enable(servers)

          vim.lsp.config["*"] = {
            -- common settings (redefine)
            capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()),
          }

          -- -- rust
          -- -- local lsp_work_by_client_id = {}
          -- -- local time = 0
          -- vim.lsp.config("rust_analyzer", {
          --   settings = {
          --     ["rust-analyzer"] = {
          --       diagnostics = {
          --         enable = true,
          --         experimental = { enable = true },
          --         styleLints = { enable = true },
          --       },
          --       cargo = { features = "all" },
          --       checkOnSave = true,
          --       check = {
          --         command = "clippy",
          --         features = "all",
          --       },
          --       files = {
          --         -- watcher = 'server',
          --         watcher = "client",
          --       },
          --       inlayHints = {
          --         typeHints = { enable = true },
          --         chainingHints = { enable = true },
          --         closingBraceHints = { enable = true },
          --         bindingModeHints = { enable = true },
          --         closureCaptureHints = { enable = true },
          --         closureReturnTypeHints = {
          --           enable = "always",
          --         },
          --         discriminantHints = { enable = "always" },
          --         expressionAdjustmentHints = {
          --           enable = "always",
          --         },
          --         genericParameterHints = {
          --           const = { enable = true },
          --           lifetime = { enable = true },
          --           type = { enable = true },
          --         },
          --         implicitDrops = { enable = true },
          --         implicitSizedBoundHints = { enable = true },
          --         maxLength = nil,
          --         reborrowHints = { enable = "always" },
          --         renderColons = true,
          --         lifetimeElisionHints = {
          --           enable = true,
          --           useParameterNames = true,
          --         },
          --       },
          --     },
          --   },
          --   --   -- on_attach = function(client, bufnr)
          --   --   --   -- require "lsp_signature".on_attach({
          --   --   --   --   always_trigger = true,
          --   --   --   --   transparency = 10,
          --   --   --   --
          --   --   --   -- }, bufnr)
          --   --   --
          --   --   --   -- enable inlay hints at buffer open
          --   --   --   -- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          --   --   --   --
          --   --   --   -- pcall(vim.api.nvim_create_autocmd, "LspProgress", {
          --   --   --   --   callback = function(event)
          --   --   --   --     local kind = event.data.params.value.kind
          --   --   --   --     local client_id = event.data.client_id
          --   --   --   --     local work = lsp_work_by_client_id[client_id] or 0
          --   --   --   --     local work_change = kind == "begin" and 1 or (kind == "end" and -1 or 0)
          --   --   --   --     lsp_work_by_client_id[client_id] = math.max(work + work_change, 0)
          --   --   --   --
          --   --   --   --     if
          --   --   --   --       vim.lsp.inlay_hint.is_enabled({
          --   --   --   --         bufnr = bufnr,
          --   --   --   --       }) and lsp_work_by_client_id[client_id] == 0
          --   --   --   --     then
          --   --   --   --       vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
          --   --   --   --       vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          --   --   --   --       time = time + 1
          --   --   --   --       print(string.format("inlay hints redrew %d times", time))
          --   --   --   --     end
          --   --   --   --   end,
          --   --   --   -- })
          --   --   -- end,
          -- })

          -- clangd
          -- local nproc
          -- -- local jit = require("jit")
          -- if jit.os == "OSX" then
          --   nproc = vim.fn.systemlist("sysctl -n hw.physicalcpu")[1]
          -- elseif jit.os == "Linux" then
          --   nproc = vim.fn.systemlist("nproc")[1]
          -- end
          local function enable_inlay_hint_for_buf(bufnr)
            if not vim.lsp.inlay_hint.is_enabled() then
              vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
              -- print("Inlay Hints is enabled: " .. tostring(vim.lsp.inlay_hint.is_enabled()) .. "...")
            end
          end
          local function change_indent_based_on_clang_format_file(bufnr)
            local cwd = vim.fn.getcwd()
            local clang_format_cmd = "clang-format --dump-config " .. cwd .. "/.clang-format"
            -- get indent settings in .clang-format file and change nvim's accordingly.
            local output = vim.fn.systemlist(clang_format_cmd)
            if vim.v.shell_error ~= 0 then
              -- print(clang_format_cmd)
              -- print(output)
              print("Read .clang-formt failed... Using default tab width settings...")
              return
            end
            for _, line in ipairs(output) do
              if line:match("^IndentWidth:") then
                local width = tonumber(line:match("%d+"))
                if width then
                  vim.bo[bufnr].shiftwidth = width
                  vim.bo[bufnr].tabstop = width
                  vim.bo[bufnr].softtabstop = width
                  -- print("shiftwidth is: " .. width .. ".")
                end
              elseif line:match("^UseTab:") then
                local val = line:match(":%s*(%w+)")
                if val == "Never" then
                  vim.bo[bufnr].expandtab = true
                else
                  vim.bo[bufnr].expandtab = false
                end
                -- print("UseTab is: " .. val)
                -- print("expandtab is: " .. tostring(vim.bo[bufnr].expandtab))
              end
            end
          end
          vim.lsp.config("clangd", {
            cmd = {
              "clangd",
              -- https://github.com/llvm/llvm-project/blob/03d9daeee67459c5854676bfacf5018ece6245fe/clang-tools-extra/clangd/tool/ClangdMain.cpp#L352
              -- https://github.com/llvm/llvm-project/blob/25ef609d06990f8fa326e920f050ca35a7cf7b55/clang-tools-extra/clangd/TUScheduler.cpp#L1615
              -- https://github.com/llvm/llvm-project/blob/0915bb9b42b63445797695df7fdc5506433dfe7b/llvm/include/llvm/Support/Threading.h#L133
              -- https://github.com/llvm/llvm-project/blob/25ef609d06990f8fa326e920f050ca35a7cf7b55/llvm/include/llvm/Support/Threading.h#L163
              -- "-j=" .. nproc, -- use this to enable hyper-threading (if SMT enabled but not work with llvm) not physical cores.
              "--background-index",
              "--background-index-priority=low", -- https://github.com/llvm/llvm-project/blob/03d9daeee67459c5854676bfacf5018ece6245fe/clang-tools-extra/clangd/tool/ClangdMain.cpp#L186
              "--pch-storage=memory",
              "--clang-tidy",
              "--all-scopes-completion",
              "--completion-style=detailed",
              "--header-insertion=iwyu",
              "--header-insertion-decorators",
              "--import-insertions",
              "--function-arg-placeholders=1",
              "--limit-references=0",
              "--limit-results=0",
              "--rename-file-limit=0",
              -- "--offset-encoding=utf-8",
              "--fallback-style=Chromium",
              -- "--log=verbose",
              "--pretty",
              "--compile-commands-dir=build",
              "--experimental-modules-support",
            },
            on_attach = function(_, bufnr)
              -- print("clangd running with " .. nproc .. " jobs...")

              -- enable_inlay_hint_for_buf(bufnr)

              change_indent_based_on_clang_format_file(bufnr)
            end,
            -- -- https://github.com/Civitasv/cmake-tools.nvim/blob/master/docs/howto.md
            -- on_new_config = function(new_config, new_cwd)
            --   local status, cmake = pcall(require, "cmake-tools")
            --   if status then
            --     cmake.clangd_on_new_config(new_config)
            --   end
            -- end,
          })

          -- python
          vim.lsp.config("ty", {
            cmd = { "ty", "server" },
            filetypes = { "python" },
            root_dir = vim.fs.root(0, { ".git/", "pyproject.toml" }),
          })
          -- ruff - use defaults
          vim.lsp.config("ruff", {
            -- https://docs.astral.sh/ruff/editors/setup/#neovim
          })
          -- pyright - work with ruff
          vim.lsp.config("pyright", {
            settings = {
              python = {
                analysis = {
                  typeCheckingMode = "off",
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                  diagnosticMode = "off",
                  autoImportCompletions = false,
                },
                linting = {
                  enabled = false,
                },
              },
            },
            -- Disable all diagnostics from Pyright
            handlers = {
              ["textDocument/publishDiagnostics"] = function() end,
            },
          })

          --lua
          vim.lsp.config("lua_ls", {
            settings = {
              Lua = {
                hint = {
                  enable = true,
                  setType = true,
                  arrayIndex = "Enable",
                },
              },
            },
            -- on_attach = function(_, bufnr)
            --   vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            -- end,
            on_init = function(client)
              if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if
                  path ~= vim.fn.stdpath("config")
                  and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
                then
                  return
                end
              end

              client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                runtime = {
                  version = "LuaJIT",
                },
                diagnostics = {
                  globals = {
                    "vim",
                    "describe",
                    "pending",
                    "it",
                    "before_each",
                    "after_each",
                  },
                  disable = { "missing-fields" },
                },
                telemetry = { enable = false },
                workspace = {
                  library = {
                    "lua",
                    -- "$VIMRUNTIME/lua",
                    vim.env.VIMRUNTIME,
                    vim.fn.stdpath("data") .. "/lazy/",
                    "${3rd}/luv/library", -- in lazydev
                    "${3rd}/busted/library",
                  },
                  checkThirdParty = false,
                  maxPreload = 2000,
                  preloadFileSize = 1000,
                },
              })
            end,
          })

          -- asm
          vim.lsp.config("asm_lsp", {
            -- https://github.com/bergercookie/asm-lsp
          })

          -- texlab
          vim.lsp.config("texlab", {
            settings = {
              texlab = {
                build = {
                  onSave = false, -- use <leader>tb to build
                  forwardSearchAfter = true,
                  -- fallback if reading .latexmkrc/latexmkrc failed
                  auxDirectory = "build",
                  logDirectory = "build",
                  pdfDirectory = "build",
                  executable = "latexmk",
                  args = {
                    -- "-pv", -- preview
                    "-synctex=1",
                    "-interaction=nonstopmode",
                    "-file-line-error",
                    "-pdf",
                    "-outdir=build",
                    "%f",
                  },
                },
                chktex = {
                  onOpenAndSave = true,
                  onEdit = true,
                },
                latexFormatter = "none", -- defined in conform config
                -- latexFormatter = "latexindent",
                -- latexindent = {
                --   modifyLineBreaks = true,
                -- },
                -- <leader>tt to forwardSearch, right click in sioyek to inverse search
                forwardSearch = {
                  executable = "sioyek",
                  args = {
                    "--reuse-window",
                    "--execute-command",
                    "turn_on_synctex;turn_on_presenation_mode",
                    "--inverse-search",

                    -- -- stylua: ignore
                    -- "texlab inverse-search -i \"%%1\" -l \"%%2\"", -- would offset by one line down

                    -- stylua: ignore
                    string.format("bash -c %s", string.format(
                      "\"nvim --headless --noplugin --server %s --remote \"%s\" && nvim --headless --noplugin --server %s --remote-send \"gg%sjk0%slh\"\"",
                      vim.v.servername,
                      "%%1",
                      vim.v.servername,
                      "%%2",
                      "%%3"
                    )),

                    "--forward-search-file",
                    "%f",
                    "--forward-search-line",
                    "%l",
                    "%p",
                  },
                },
              },
            },
          })
          vim.api.nvim_create_autocmd("VimEnter", {
            pattern = "*.tex",
            callback = function()
              local build_dir = vim.fn.expand("%:p:h") .. "/build"
              if vim.fn.isdirectory(build_dir) == 0 then
                vim.fn.mkdir(build_dir, "p")
              end
            end,
          })

          -- mutt
          vim.lsp.config("mutt_ls", {})

          -- bash
          vim.lsp.config("bashls", {})

          -- nixd
          -- https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md#where-to-place-the-configuration
          vim.lsp.config("nixd", {
            cmd = { "nixd" },
            settings = {
              nixd = {
                nixpkgs = {
                  expr = "import <nixpkgs> { }",
                },
                formatting = {
                  command = { "nixfmt" },
                },
                options = {
                  nixos = {
                    expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.k-on.options',
                  },
                  home_manager = {
                    expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."ruixi@k-on".options',
                  },
                },
              },
            },
          })

          vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
              -- Enable completion triggered by <c-x><c-o>
              vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
              local buffer = ev.buf

              -- lsp keymap
              keymap.set("n", "<leader>lr", ":LspRestart<cr>", { desc = "LSP restart" })
              keymap.set("n", "<leader>li", "<cmd>checkhealth vim.lsp<cr>", { desc = "LSP info" })
              keymap.set("n", "<leader>i", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
              end, { desc = "Toggle inlay hints", buffer = buffer })
              keymap.set(
                "n",
                "<leader>d",
                vim.diagnostic.open_float,
                { desc = "open float diagnostic", buffer = buffer }
              )
              keymap.set(
                "n",
                "<leader>q",
                vim.diagnostic.setloclist,
                { desc = "diagnostic set loc list", buffer = buffer }
              )
              keymap.set(
                "n",
                "gD",
                -- vim.lsp.buf.declaration,
                "<cmd>FzfLua lsp_declarations<cr>",
                { desc = "go to declaration", buffer = buffer }
              )
              keymap.set(
                "n",
                "gd",
                -- vim.lsp.buf.definition,
                "<cmd>FzfLua lsp_definitions<cr>",
                { desc = "go to definition", buffer = buffer }
              )
              keymap.set("n", "<leader>k", vim.lsp.buf.hover, {
                desc = "open hover, x2 into hover window, q to exit",
                buffer = buffer,
              })
              keymap.set(
                "n",
                "gi",
                -- vim.lsp.buf.implementation,
                "<cmd>FzfLua lsp_implementations<cr>",
                { desc = "go to implementation", buffer = buffer }
              )
              -- C-k: normal mode - lsp signature; insert mode - blink.cmp signature
              keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "signature help", buffer = buffer })
              keymap.set(
                "n",
                "<leader>wa",
                vim.lsp.buf.add_workspace_folder,
                { desc = "add add workspace folder", buffer = buffer }
              )
              keymap.set(
                "n",
                "<leader>wr",
                vim.lsp.buf.remove_workspace_folder,
                { desc = "remove workspace folder", buffer = buffer }
              )
              keymap.set("n", "<leader>wl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
              end, {
                desc = "list workspace folders",
                buffer = buffer,
              })
              keymap.set(
                "n",
                "<space>D",
                -- vim.lsp.buf.type_definition,
                "<cmd>FzfLua lsp_typedefs<cr>",
                { desc = "type definition", buffer = buffer }
              )
              keymap.set("n", "<leader>br", vim.lsp.buf.rename, { desc = "rename buffer", buffer = buffer })
              keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, { desc = "Code Actions", buffer = buffer })
              keymap.set(
                { "n", "v" },
                "<leader>fa",
                "<cmd>FzfLua lsp_code_actions<cr>",
                { desc = "Find Code Action", buffer = buffer }
              )
              keymap.set(
                "n",
                "gr",
                -- vim.lsp.buf.references,
                "<cmd>FzfLua lsp_references<cr>",
                { desc = "references", buffer = buffer }
              )

              keymap.set("n", "gI", "<cmd>FzfLua lsp_incoming_calls<cr>", { desc = "Goto Parent", buffer = buffer })
              keymap.set("n", "gO", "<cmd>FzfLua lsp_outgoing_calls<cr>", { desc = "Goto Child", buffer = buffer })

              -- texlab (the cmd is relied on nvim-lspconfig)
              vim.keymap.set("n", "<leader>tt", "<cmd>TexlabForward<cr>", { desc = "Texlab Forward Search" })
              vim.keymap.set("n", "<leader>tb", "<cmd>TexlabBuild<cr>", { desc = "Texlab Build" })
            end,
          })
        end,
      },
      -- completion
      {
        "saghen/blink.cmp",
        event = "VeryLazy",
        build = "cargo build --release",
        dependencies = {
          "rafamadriz/friendly-snippets",
          {
            "L3MON4D3/LuaSnip",
            build = "make install_jsregexp",
          },
          -- {
          --   "folke/lazydev.nvim",
          --   ft = "lua",
          --   opts = {
          --     library = {
          --       { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          --     },
          --   },
          -- },
          {
            "xzbdmw/colorful-menu.nvim",
          },
        },
        opts = {
          keymap = {
            preset = "super-tab", -- https://cmp.saghen.dev/configuration/keymap.html#super-tab
          },
          appearance = {
            nerd_font_variant = "mono",
          },
          completion = {
            documentation = {
              auto_show = true,
            },
            ghost_text = { enabled = true },
            -- list = { -- https://cmp.saghen.dev/configuration/completion#list
            --   selection = {
            --     preselect = function(ctx)
            --       return not require("blink.cmp").snippet_active({ direction = 1 })
            --     end,
            --   },
            -- },
            menu = {
              draw = {
                columns = { { "kind_icon" }, { "label", gap = 1 } },
                components = {
                  label = {
                    text = function(ctx)
                      return require("colorful-menu").blink_components_text(ctx)
                    end,
                    highlight = function(ctx)
                      return require("colorful-menu").blink_components_highlight(ctx)
                    end,
                  },
                },
              },
            },
          },
          fuzzy = { implementation = "rust" },
          cmdline = {
            enabled = true,
            keymap = {
              preset = "super-tab",
            },
            completion = { menu = { auto_show = true } },
          },
          snippets = { preset = "luasnip" },
          -- sources = {
          --   default = { "lsp", "lazydev", "path", "snippets", "buffer" },
          --   providers = {
          --     lazydev = {
          --       name = "LazyDev",
          --       module = "lazydev.integrations.blink",
          --       score_offset = 100,
          --     },
          --   },
          -- },
          signature = {
            enabled = true,
            window = {
              show_documentation = true,
            },
          },
        },
        opts_extend = { "sources.default" },
      },
      -- {
      --   "ray-x/lsp_signature.nvim",
      --   -- enabled = false, -- use float signature from blink.cmp instead
      --   event = "InsertEnter",
      --   opts = {
      --     doc_lines = 0, -- Get signatures (and _only_ signatures) when in argument lists.
      --     handler_opts = {
      --       border = "none",
      --     },
      --   },
      -- },
      -- work with morden fmt tools
      {
        "stevearc/conform.nvim",
        lazy = true,
        cmd = "ConformInfo",
        event = { "BufWritePre", "BufReadPre", "BufNewFile" },
        config = function()
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

          keymap.set("n", "<leader>lc", "<cmd>ConformInfo<cr>", { desc = "Conform Info" })
        end,
      },
      -- basic highlighting
      {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        config = function()
          require("nvim-treesitter.configs").setup({
            ensure_installed = {
              "rust",
              "toml",
              "c",
              "cpp",
              "cuda",
              "latex",
              "bibtex",
              "zig",
              "python",
              "go",
              "gomod",
              "gosum",
              "make",
              "cmake",
              "gn",
              "meson",
              "ninja",
              "asm",
              "nasm",
              "mlir",
              "objdump",
              "devicetree",
              "disassembly",
              "pem",
              "nginx",
              "glsl",
              "sql",
              "lua",
              "vim",
              "vimdoc",
              "markdown",
              "markdown_inline",
              "tsx",
              "typescript",
              "javascript",
              "html",
              "css",
              "scss",
              "regex",
              "json",
              "yaml",
              "xml",
              "vue",
              "java",
              "javadoc",
              "git_config",
              "gitcommit",
              "gitignore",
              "git_rebase",
              "diff",
              "doxygen",
              "dockerfile",
              "desktop",
              "hyprlang",
              "kdl",
              "ocaml",
              "bash",
              "fish",
              "gpg",
              -- "norg",
            },

            sync_install = false,
            auto_install = true,
            ignore_install = {
              -- "javascript",
            },
            highlight = {
              enable = true,
              disable = {
                -- "latex",
                -- "c",
                -- "cpp",
                -- "cuda",
                -- "rust",
              },
              additional_vim_regex_highlighting = false,
            },
            autotag = {
              enable = true,
            },
            indent = {
              enable = true,
            },
            -- incremental_selection = {
            --   enable = true,
            --   keymaps = {
            --     init_selection = "gnn", -- set to `false` to disable one of the mappings
            --     node_incremental = "grn",
            --     scope_incremental = "grc",
            --     node_decremental = "grm",
            --   },
            -- },
          })
        end,
      },
      -- -- quick search and jump to char in screen
      -- {
      --   "folke/flash.nvim",
      --   opts = {},
      --   keys = {
      --     {
      --       "s",
      --       mode = { "n", "x", "o" },
      --       function()
      --         require("flash").jump()
      --       end,
      --       desc = "Flash",
      --     },
      --     {
      --       "S",
      --       mode = { "n", "x", "o" },
      --       function()
      --         require("flash").treesitter()
      --       end,
      --       desc = "Flash Treesitter",
      --     },
      --     {
      --       "r",
      --       mode = "o",
      --       function()
      --         require("flash").remote()
      --       end,
      --       desc = "Remote Flash",
      --     },
      --     {
      --       "R",
      --       mode = { "o", "x" },
      --       function()
      --         require("flash").treesitter_search()
      --       end,
      --       desc = "Treesitter Search",
      --     },
      --     {
      --       "<c-s>",
      --       mode = { "c" },
      --       function()
      --         require("flash").toggle()
      --       end,
      --       desc = "Toggle Flash Search",
      --     },
      --   },
      -- },
      -- fuzzy finding, lua version
      {
        "ibhagwan/fzf-lua",
        -- lazy = false,
        -- priority = 1000,
        event = "VeryLazy",
        dependencies = {
          "nvim-tree/nvim-web-devicons",
          {
            "junegunn/fzf",
            dir = "~/builds/fzf",
            build = "./install --all",
          },
          { "neovim/nvim-lspconfig" },
        },
        config = function()
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
        end,
      },
      -- -- keymap hints
      -- {
      --   "folke/which-key.nvim",
      --   -- enabled = false,
      --   dependencies = { "nvim-tree/nvim-web-devicons" },
      --   event = "VeryLazy",
      --   keys = {
      --     {
      --       "<leader>?",
      --       function()
      --         require("which-key").show({ global = false })
      --       end,
      --       desc = "Buffer Local Keymaps (which-key)",
      --     },
      --   },
      -- },
      -- :h nvim-surround.usage
      {
        "kylechui/nvim-surround",
        -- version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
        -- event = "VeryLazy",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
          require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
            -- https://github.com/kylechui/nvim-surround/blob/main/lua/nvim-surround/config.lua
          })
        end,
      },
      -- hex color render
      {
        "echasnovski/mini.hipatterns",
        version = false,
        -- event = { "BufReadPost", "BufNewFile" },
        ft = { "lua", "css", "html", "cpp" },
        config = function()
          local hipatterns = require("mini.hipatterns")
          hipatterns.setup({
            highlighters = {
              hex_color = hipatterns.gen_highlighter.hex_color(),
            },
          })
        end,
      },
      -- {
      --   "folke/snacks.nvim",
      --   -- lazy = false,
      --   -- priority = 1000,
      --   event = { "BufReadPost", "BufNewFile" },
      --   opts = {
      --     animate = {
      --       enabled = true,
      --       fps = 240,
      --     },
      --     indent = {
      --       indent = {
      --         enabled = true,
      --       },
      --       scope = {
      --         enabled = true,
      --         hl = {
      --           "RainbowRed",
      --           "RainbowYellow",
      --           "RainbowBlue",
      --           "RainbowOrange",
      --           "RainbowGreen",
      --           "RainbowViolet",
      --           "RainbowCyan",
      --         },
      --       },
      --     },
      --   },
      -- },
      -- todo
      {
        "folke/todo-comments.nvim",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
          {
            "]t",
            function()
              require("todo-comments").jump_next()
            end,
            desc = "Next todo comment",
          },
          {
            "[t",
            function()
              require("todo-comments").jump_prev()
            end,
            desc = "Previous todo comment",
          },
          {
            "<leader>tf",
            "<cmd>TodoFzfLua<cr>",
            desc = "TODO Search",
          },
        },
        opts = {},
      },
      -- -- usage indication
      -- {
      --   "RRethy/vim-illuminate",
      --   event = {
      --     -- "CursorHold",
      --     -- "CursorHoldI",
      --     "LspAttach",
      --   },
      --   -- dependencies = { "neovim/nvim-lspconfig" },
      --   config = function()
      --     require("illuminate").configure({
      --       providers = {
      --         "lsp",
      --         -- "treesitter",
      --         -- "regex",
      --       },
      --       delay = 0,
      --       modes_denylist = { "i", "v", "V" },
      --     })
      --   end,
      -- },
      -- render markdown
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = "markdown",
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
          "nvim-tree/nvim-web-devicons",
        }, -- if you prefer nvim-web-devicons
        opts = {},
      },
      {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
      },
      {
        "stevearc/oil.nvim",
        opts = {},
        -- Optional dependencies
        -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
        dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
        lazy = false,
        config = function()
          require("oil").setup({
            columns = {
              "icon",
              "permissions",
              "size",
              "mtime",
            },
            keymaps = {
              ["g?"] = { "actions.show_help", mode = "n" },
              ["<CR>"] = "actions.select",
              ["<C-s>"] = { "actions.select", opts = { vertical = true } },
              ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
              ["<C-t>"] = { "actions.select", opts = { tab = true } },
              ["<C-p>"] = "actions.preview",
              -- ["<C-c>"] = { "actions.close", mode = "n" },
              ["q"] = { "actions.close", mode = "n" },
              ["<C-l>"] = "actions.refresh",
              ["-"] = { "actions.parent", mode = "n" },
              ["_"] = { "actions.open_cwd", mode = "n" },
              ["`"] = { "actions.cd", mode = "n" },
              ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
              ["gs"] = { "actions.change_sort", mode = "n" },
              ["gx"] = "actions.open_external",
              ["g."] = { "actions.toggle_hidden", mode = "n" },
              ["g\\"] = { "actions.toggle_trash", mode = "n" },
            },
            float = {
              -- Padding around the floating window
              padding = 2,
              -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
              max_width = 0.8,
              max_height = 0.5,
              border = "rounded",
              win_options = {
                winblend = 0,
              },
              -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
              get_win_title = nil,
              -- preview_split: Split direction: "auto", "left", "right", "above", "below".
              preview_split = "auto",
              -- This is the config that will be passed to nvim_open_win.
              -- Change values here to customize the layout
              override = function(conf)
                return conf
              end,
            },
            view_options = {
              show_hidden = true,
            },

            vim.keymap.set("n", "<leader>e", "<CMD>Oil --float<CR>", { desc = "Open parent directory" }),
          })
        end,
      },
      -- {
      --   "Civitasv/cmake-tools.nvim",
      --   -- enabled = false,
      --   ft = { "cpp", "c", "cuda", "cmake" },
      --   -- event = { "BufReadPre", "BufNewFile" },
      --   -- cond = function()
      --   --   local cwd = vim.fn.getcwd()
      --   --   return vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1
      --   -- end,
      --   opts = {},
      --   dependencies = {
      --     "nvim-lua/plenary.nvim",
      --     {
      --       "akinsho/toggleterm.nvim",
      --       opts = {},
      --     },
      --     {
      --       "stevearc/overseer.nvim",
      --       version = "v1.6.0",
      --       opts = {},
      --     },
      --   },
      --   config = function()
      --     -- https://github.com/Civitasv/cmake-tools.nvim?tab=readme-ov-file#balloon-configuration
      --     -- https://github.com/Civitasv/cmake-tools.nvim/blob/master/docs/sessions.md
      --     local osys = require("cmake-tools.osys")
      --     require("cmake-tools").setup({
      --       cmake_generate_options = { "-GNinja", "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" },
      --       cmake_build_options = {},
      --       -- support macro expansion:
      --       --       ${kit}
      --       --       ${kitGenerator}
      --       --       ${variant:xx}
      --       cmake_build_directory = function()
      --         if osys.iswin32 then
      --           return "build\\${variant:buildType}"
      --         end
      --         return "build/${variant:buildType}"
      --       end,
      --       cmake_compile_commands_options = {
      --         action = "soft_link", -- available options: soft_link, copy, lsp, none
      --         target = vim.loop.cwd() .. "/build", -- path to directory, this is used only if action == "soft_link" or action == "copy"
      --       },
      --       cmake_compile_commands_from_lsp = true,
      --       cmake_kits_path = "~/.local/share/CMakeTools/cmake-tools-kits.json",
      --
      --       cmake_executor = { -- executor to use
      --         name = "overseer", -- name of the executor
      --         default_opts = { -- a list of default and possible values for executors
      --           overseer = {
      --             new_task_opts = {
      --               strategy = { -- https://github.com/stevearc/overseer.nvim/blob/master/doc/strategies.md#toggletermopts
      --                 "toggleterm",
      --                 auto_scroll = true,
      --                 quit_on_exit = "success",
      --                 direction = "float",
      --                 -- direction = "horizontal",
      --                 -- size = 30,
      --               },
      --             }, -- options to pass into the `overseer.new_task` command
      --             on_new_task = function(task)
      --               -- require("overseer").open({ enter = true, direction = "left" }) -- https://github.com/stevearc/overseer.nvim/blob/master/doc/reference.md#openopts
      --               -- require("overseer").open({ enter = true }) -- https://github.com/stevearc/overseer.nvim/blob/master/doc/reference.md#openopts
      --             end, -- a function that gets overseer.Task when it is created, before calling `task:start`
      --           },
      --         },
      --       },
      --       cmake_runner = { -- runner to use
      --         name = "overseer", -- name of the runner
      --         default_opts = { -- a list of default and possible values for runners
      --           overseer = {
      --             new_task_opts = {
      --               strategy = { -- https://github.com/stevearc/overseer.nvim/blob/master/doc/strategies.md#toggletermopts
      --                 "toggleterm",
      --                 autos_croll = true,
      --                 quit_on_exit = "success",
      --                 direction = "float",
      --                 -- direction = "horizontal",
      --                 -- size = 30,
      --               },
      --             }, -- options to pass into the `overseer.new_task` command
      --             on_new_task = function(task)
      --               -- require("overseer").open({ enter = true, direction = "left" }) -- https://github.com/stevearc/overseer.nvim/blob/master/doc/reference.md#openopts
      --               -- require("overseer").open({ enter = true }) -- https://github.com/stevearc/overseer.nvim/blob/master/doc/reference.md#openopts
      --             end, -- a function that gets overseer.Task when it is created, before calling `task:start`
      --           },
      --         },
      --       },
      --     })
      --
      --     vim.keymap.set("n", "cmr", ":CMakeRun<cr>", { silent = true, desc = "CMakeRun" })
      --     vim.keymap.set("n", "cmb", ":CMakeBuild<cr>", { silent = true, desc = "CMakeBuild" })
      --     vim.keymap.set("n", "cmc", ":CMakeGenerate<cr>", { silent = true, desc = "CMakeGenerate" })
      --     vim.keymap.set("n", "cmst", ":CMakeStopRunner<cr>", { silent = true, desc = "CMakeStopRunner" })
      --     vim.keymap.set("n", "cmsbbt", ":CMakeSelectBuildType<cr>", { silent = true, desc = "CMakeSelectBuildType" })
      --     vim.keymap.set(
      --       "n",
      --       "cmsbt",
      --       ":CMakeSelectBuildTarget<cr>",
      --       { silent = true, desc = "CMakeSelectBuildTarget" }
      --     )
      --     vim.keymap.set(
      --       "n",
      --       "cmslt",
      --       ":CMakeSelectLaunchTarget<cr>",
      --       { silent = true, desc = "CMakeSelectLaunchTarget" }
      --     )
      --     vim.keymap.set(
      --       "n",
      --       "cmscp",
      --       ":CMakeSelectConfigurePreset<cr>",
      --       { silent = true, desc = "CMakeSelectConfigurePreset" }
      --     )
      --     vim.keymap.set(
      --       "n",
      --       "cmsbp",
      --       ":CMakeSelectBuildPreset<cr>",
      --       { silent = true, desc = "CMakeSelectConfigurePreset" }
      --     )
      --     vim.keymap.set("n", "cmsk", ":CMakeSelectKit<cr>", { silent = true, desc = "CMakeSelectKit" })
      --   end,
      -- },
      -- {
      --   "sphamba/smear-cursor.nvim",
      --   enabled = false,
      --   event = {
      --     "VeryLazy",
      --     -- "BufReadPre",
      --     -- "BufNewFile",
      --   },
      --   opts = {
      --     -- Smear cursor when switching buffers or windows.
      --     smear_between_buffers = true,
      --
      --     -- Smear cursor when moving within line or to neighbor lines.
      --     -- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control
      --     smear_between_neighbor_lines = true,
      --
      --     -- Draw the smear in buffer space instead of screen space when scrolling
      --     scroll_buffer_space = true,
      --
      --     -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
      --     -- Smears will blend better on all backgrounds.
      --     legacy_computing_symbols_support = false,
      --
      --     -- Smear cursor in insert mode.
      --     -- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
      --     smear_insert_mode = true,
      --   },
      -- },
      -- {
      --   "karb94/neoscroll.nvim",
      --   enabled = false,
      --   event = {
      --     -- "VeryLazy",
      --     "BufReadPre",
      --     "BufNewFile",
      --   },
      --   opts = {},
      --   config = function()
      --     require("neoscroll").setup({
      --       mappings = { -- Keys to be mapped to their corresponding default scrolling animation
      --         "<C-u>",
      --         "<C-d>",
      --         "<C-b>",
      --         "<C-f>",
      --         "<C-y>",
      --         "<C-e>",
      --         "zt",
      --         "zz",
      --         "zb",
      --       },
      --       hide_cursor = true, -- Hide cursor while scrolling
      --       stop_eof = true, -- Stop at <EOF> when scrolling downwards
      --       respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
      --       cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
      --       duration_multiplier = 1.0, -- Global duration multiplier
      --
      --       -- easing = "linear", -- Default easing function
      --       easing = "quadratic", -- https://github.com/karb94/neoscroll.nvim?tab=readme-ov-file#easing-functions
      --       -- easing = "sine", -- https://github.com/karb94/neoscroll.nvim?tab=readme-ov-file#easing-functions
      --
      --       pre_hook = nil, -- Function to run before the scrolling animation starts
      --       post_hook = nil, -- Function to run after the scrolling animation ends
      --       performance_mode = false, -- Disable "Performance Mode" on all buffers.
      --       ignored_events = { -- Events ignored while scrolling
      --         "WinScrolled",
      --         "CursorMoved",
      --       },
      --     })
      --   end,
      -- },
      -- {
      --   "nvim-neotest/neotest",
      --   dependencies = {
      --     "nvim-neotest/nvim-nio",
      --     "nvim-lua/plenary.nvim",
      --     "antoinemadec/FixCursorHold.nvim",
      --     "nvim-treesitter/nvim-treesitter",
      --   },
      --   config = function()
      --     require("neotest").setup({
      --       adapters = {
      --         require("neotest-python")({
      --           dap = { justMyCode = false },
      --         }),
      --         require("neotest-plenary"),
      --         require("neotest-vim-test")({
      --           ignore_file_types = { "python", "vim", "lua" },
      --         }),
      --       },
      --     })
      --   end,
      -- },
      {
        "mrcjkb/rustaceanvim",
        -- version = "^6", -- Recommended
        -- lazy = false, -- This plugin is already lazy
        ft = {
          "rust",
          "toml",
        },
        -- event = { "BufReadPre", "BufNewFile" },
        config = function()
          vim.g.rustaceanvim = {
            -- Plugin configuration
            tools = {},
            -- LSP configuration
            server = {
              on_attach = function(client, bufnr)
                vim.keymap.set("n", "<leader>a", function()
                  vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
                  -- vim.lsp.buf.codeAction() -- if you don't want grouping.
                end, { silent = true, buffer = bufnr })
                vim.keymap.set(
                  "n",
                  "<leader>k", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
                  function()
                    vim.cmd.RustLsp({ "hover", "actions" })
                  end,
                  { silent = true, buffer = bufnr }
                )
              end,
              default_settings = {
                ["rust-analyzer"] = {
                  diagnostics = {
                    enable = true,
                    experimental = { enable = true },
                    styleLints = { enable = true },
                  },
                  cargo = { features = "all" },
                  checkOnSave = true,
                  check = {
                    command = "clippy",
                    features = "all",
                  },
                  files = {
                    -- watcher = 'server',
                    watcher = "client",
                  },
                  semanticHighlighting = {
                    operator = true,
                    punctuation = true,
                    strings = true,
                  },
                  inlayHints = {
                    typeHints = { enable = true },
                    chainingHints = { enable = true },
                    closingBraceHints = { enable = true },
                    bindingModeHints = { enable = true },
                    closureCaptureHints = { enable = true },
                    closureReturnTypeHints = {
                      enable = "always",
                    },
                    discriminantHints = { enable = "always" },
                    expressionAdjustmentHints = {
                      enable = "always",
                    },
                    genericParameterHints = {
                      const = { enable = true },
                      lifetime = { enable = true },
                      type = { enable = true },
                    },
                    implicitDrops = { enable = true },
                    implicitSizedBoundHints = { enable = true },
                    maxLength = nil,
                    reborrowHints = { enable = "always" },
                    renderColons = true,
                    lifetimeElisionHints = {
                      enable = true,
                      useParameterNames = true,
                    },
                  },
                },
              },
            },
            -- DAP configuration
            dap = {},
          }
        end,
      },
      {
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        -- tag = "stable",
        config = function()
          -- https://github.com/Saecki/crates.nvim/wiki/Documentation-unstable
          -- https://github.com/YaQia/.dotfile/blob/master/nvim/lua/plugins/crates.lua
          require("crates").setup()
        end,
      },
      -- -- pairs
      -- {
      --   "windwp/nvim-autopairs",
      --   event = "InsertEnter",
      --   opts = {},
      -- },
      {
        "saghen/blink.pairs",
        event = { "BufReadPost", "BufNewFile" },
        build = "cargo build --release",
        --- @module 'blink.pairs'
        --- @type blink.pairs.Config
        opts = {
          mappings = {
            -- you can call require("blink.pairs.mappings").enable()
            -- and require("blink.pairs.mappings").disable()
            -- to enable/disable mappings at runtime
            enabled = true,
            cmdline = true,
            -- or disable with `vim.g.pairs = false` (global) and `vim.b.pairs = false` (per-buffer)
            -- and/or with `vim.g.blink_pairs = false` and `vim.b.blink_pairs = false`
            disabled_filetypes = {},
            -- see the defaults:
            -- https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L14
            pairs = {},
          },
          highlights = {
            enabled = true,
            -- requires require('vim._extui').enable({}), otherwise has no effect
            cmdline = true,
            -- groups = {
            --   "BlinkPairsOrange",
            --   "BlinkPairsPurple",
            --   "BlinkPairsBlue",
            -- },
            unmatched_group = "BlinkPairsUnmatched",

            -- highlights matching pairs under the cursor
            matchparen = {
              enabled = true,
              -- known issue where typing won't update matchparen highlight, disabled by default
              cmdline = false,
              -- also include pairs not on top of the cursor, but surrounding the cursor
              include_surrounding = false,
              group = "BlinkPairsMatchParen",
              priority = 250,
            },
          },
          debug = false,
        },
      },
      -- {
      --   "saghen/blink.indent",
      --   enabled = false,
      --   event = { "BufReadPost", "BufNewFile" },
      --   opts = {},
      --   config = function()
      --     require("blink.indent").setup({
      --       blocked = {
      --         -- default: 'terminal', 'quickfix', 'nofile', 'prompt'
      --         buftypes = { include_defaults = true },
      --         -- default: 'lspinfo', 'packer', 'checkhealth', 'help', 'man', 'gitcommit', 'dashboard', ''
      --         filetypes = { include_defaults = true },
      --       },
      --       static = {
      --         enabled = true,
      --         char = "▎",
      --         priority = 1,
      --         -- specify multiple highlights here for rainbow-style indent guides
      --         -- highlights = { 'BlinkIndentRed', 'BlinkIndentOrange', 'BlinkIndentYellow', 'BlinkIndentGreen', 'BlinkIndentViolet', 'BlinkIndentCyan' },
      --         highlights = { "BlinkIndent" },
      --       },
      --       scope = {
      --         enabled = true,
      --         char = "▎",
      --         priority = 1000,
      --         -- set this to a single highlight, such as 'BlinkIndent' to disable rainbow-style indent guides
      --         -- highlights = { 'BlinkIndentScope' },
      --         -- optionally add: 'BlinkIndentRed', 'BlinkIndentCyan', 'BlinkIndentYellow', 'BlinkIndentGreen'
      --         highlights = { "BlinkIndentOrange", "BlinkIndentViolet", "BlinkIndentBlue" },
      --         -- enable to show underlines on the line above the current scope
      --         underline = {
      --           -- enabled = true,
      --           -- optionally add: 'BlinkIndentRedUnderline', 'BlinkIndentCyanUnderline', 'BlinkIndentYellowUnderline', 'BlinkIndentGreenUnderline'
      --           highlights = { "BlinkIndentOrangeUnderline", "BlinkIndentVioletUnderline", "BlinkIndentBlueUnderline" },
      --         },
      --       },
      --     })
      --   end,
      -- },
      -- {
      --   "rcarriga/nvim-notify",
      --   event = { "BufReadPost", "BufNewFile" },
      --   opts = {},
      --   config = function()
      --     keymap.set("n", "<leader>nt", ":Notifications<cr>", { desc = "Show notify history." })
      --   end,
      -- },
      -- {
      --   "Mythos-404/xmake.nvim",
      --   ft = { "c", "cpp", "cuda" },
      --   event = { "BufRead xmake.lua" },
      --   dependencies = {
      --     "akinsho/toggleterm.nvim",
      --     -- "mfussenegger/nvim-dap",
      --     -- "folke/snacks.nvim",
      --     "rcarriga/nvim-notify",
      --   },
      --   config = function()
      --     require("xmake").setup({})
      --
      --     --  https://github.com/Mythos-404/xmake.nvim?tab=readme-ov-file#-commands
      --     keymap.set("n", "<leader>xr", ":Xmake run<cr>", { desc = "xmake run" })
      --     keymap.set("n", "<leader>xb", ":Xmake build<cr>", { desc = "xmake build" })
      --     -- keymap.set("n", "<leader>xd", ":Xmake debug<cr>", { desc = "xmake debug" })
      --     keymap.set("n", "<leader>xc", ":Xmake clean<cr>", { desc = "xmake clean" })
      --     keymap.set("n", "<leader>xm", ":Xmake mode<cr>", { desc = "xmake mode" })
      --     keymap.set("n", "<leader>xa", ":Xmake arch<cr>", { desc = "xmake arch" })
      --     keymap.set("n", "<leader>xp", ":Xmake plat<cr>", { desc = "xmake plat" })
      --     keymap.set("n", "<leader>xt", ":Xmake toolchain<cr>", { desc = "xmake toolchain" })
      --   end,
      -- },
      -- {
      --   "cordx56/rustowl",
      --   version = "*", -- Latest stable version
      --   build = "cargo install rustowl",
      --   lazy = false, -- This plugin is already lazy
      --   opts = {},
      -- },
    },
    install = {
      colorscheme = {
        "gruvbox",
        "everforest",
      },
    },
    checker = { enabled = true, notify = false },
    change_detection = { enabled = true, notify = false },
    defaults = { lazy = true },
  })
end -- if vim.g.vscode then -- VSCode extension
