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
    vim.keymap.set("n", "<leader>lr", ":LspRestart<cr>", { desc = "LSP restart" })
    vim.keymap.set("n", "<leader>li", "<cmd>checkhealth vim.lsp<cr>", { desc = "LSP info" })
    vim.keymap.set("n", "<leader>i", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { desc = "Toggle inlay hints", buffer = buffer })
    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "open float diagnostic", buffer = buffer })
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "diagnostic set loc list", buffer = buffer })
    vim.keymap.set(
      "n",
      "gD",
      -- vim.lsp.buf.declaration,
      "<cmd>FzfLua lsp_declarations<cr>",
      { desc = "go to declaration", buffer = buffer }
    )
    vim.keymap.set(
      "n",
      "gd",
      -- vim.lsp.buf.definition,
      "<cmd>FzfLua lsp_definitions<cr>",
      { desc = "go to definition", buffer = buffer }
    )
    vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, {
      desc = "open hover, x2 into hover window, q to exit",
      buffer = buffer,
    })
    vim.keymap.set(
      "n",
      "gi",
      -- vim.lsp.buf.implementation,
      "<cmd>FzfLua lsp_implementations<cr>",
      { desc = "go to implementation", buffer = buffer }
    )
    -- C-k: normal mode - lsp signature; insert mode - blink.cmp signature
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "signature help", buffer = buffer })
    vim.keymap.set(
      "n",
      "<leader>wa",
      vim.lsp.buf.add_workspace_folder,
      { desc = "add add workspace folder", buffer = buffer }
    )
    vim.keymap.set(
      "n",
      "<leader>wr",
      vim.lsp.buf.remove_workspace_folder,
      { desc = "remove workspace folder", buffer = buffer }
    )
    vim.keymap.set("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, {
      desc = "list workspace folders",
      buffer = buffer,
    })
    vim.keymap.set(
      "n",
      "<space>D",
      -- vim.lsp.buf.type_definition,
      "<cmd>FzfLua lsp_typedefs<cr>",
      { desc = "type definition", buffer = buffer }
    )
    vim.keymap.set("n", "<leader>br", vim.lsp.buf.rename, { desc = "rename buffer", buffer = buffer })
    vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, { desc = "Code Actions", buffer = buffer })
    vim.keymap.set(
      { "n", "v" },
      "<leader>fa",
      "<cmd>FzfLua lsp_code_actions<cr>",
      { desc = "Find Code Action", buffer = buffer }
    )
    vim.keymap.set(
      "n",
      "gr",
      -- vim.lsp.buf.references,
      "<cmd>FzfLua lsp_references<cr>",
      { desc = "references", buffer = buffer }
    )

    vim.keymap.set("n", "gI", "<cmd>FzfLua lsp_incoming_calls<cr>", { desc = "Goto Parent", buffer = buffer })
    vim.keymap.set("n", "gO", "<cmd>FzfLua lsp_outgoing_calls<cr>", { desc = "Goto Child", buffer = buffer })

    -- texlab (the cmd is relied on nvim-lspconfig)
    vim.keymap.set("n", "<leader>tt", "<cmd>TexlabForward<cr>", { desc = "Texlab Forward Search" })
    vim.keymap.set("n", "<leader>tb", "<cmd>TexlabBuild<cr>", { desc = "Texlab Build" })
  end,
})
