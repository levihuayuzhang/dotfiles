return {
  'neovim/nvim-lspconfig',
  config = function()
    local lspconfig = require 'lspconfig'

    -- Rust
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    lspconfig.rust_analyzer.setup {

      on_attach = function(client, bufnr)
        -- use defer func as workaround for start with inlay hint
        -- (which enabled but not shown)
        -- so use this for now as a late loding
        vim.defer_fn(function()
          vim.lsp.inlay_hint.enable(true)
        end, 2500)
      end,

      capabilities = capabilities,
      filetypes = { 'rust' },
      settings = {
        ['rust-analyzer'] = {
          cargo = { allFeatures = true },
          diagnostics = {
            enable = true,
          },
          checkOnSave = {
            command = 'clippy',
            allFeatures = true,
          },
          imports = {
            group = {
              enable = false,
            },
          },
          assist = {
            importEnforceGranularity = true,
            importPrefix = 'create',
          },
          completion = {
            postfix = {
              enable = false,
            },
          },
          inlayHints = {
            typeHints = { enable = true },
            renderColons = { enable = true },
            chainingHints = { enable = true },
            closingBraceHints = { enable = true },
            bindingModeHints = { enable = true },
            closureCaptureHints = { enable = true },
            lifetimeElisionHints = {
              enable = true,
              useParameterNames = true,
            },
          },
        },
      },
    }

    -- Python ruff: https://docs.astral.sh/ruff/editors/setup/
    lspconfig.ruff.setup {}

    -- golang
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*.go',
      callback = function()
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { 'source.organizeImports' } }
        -- buf_request_sync defaults to a 1000ms timeout. Depending on your
        -- machine and codebase, you may want longer. Add an additional
        -- argument after params if you find that you have to write the file
        -- twice for changes to be saved.
        -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
        local result =
          vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params)
        for cid, res in pairs(result or {}) do
          for _, r in pairs(res.result or {}) do
            if r.edit then
              local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding
                or 'utf-16'
              vim.lsp.util.apply_workspace_edit(r.edit, enc)
            end
          end
        end
        vim.lsp.buf.format { async = false }
      end,
    })

    local on_attach = function(client, bufnr)
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    end

    lspconfig.gopls.setup {
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
          },
          staticcheck = true,
          gofumpt = true,
        },
      },
      on_attach = on_attach,
    }

    -- lua
    lspconfig.lua_ls.setup {
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
        },
      },
      capabilities = capabilities,
    }

    -- Global mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
    vim.diagnostic.config { virtual_text = true }

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set(
          'n',
          '<leader>wa',
          vim.lsp.buf.add_workspace_folder,
          opts
        )
        vim.keymap.set(
          'n',
          '<leader>wr',
          vim.lsp.buf.remove_workspace_folder,
          opts
        )
        vim.keymap.set('n', '<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        --vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>f', function()
          vim.lsp.buf.format { async = true }
        end, opts)

        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        -- inlay hints not working (not showing but loaded)
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { ev.buf })
        end

        client.server_capabilities.semanticTokensProvider = nil

        -- keymap for inlay hint switch
        vim.keymap.set('n', '<leader>h', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, { desc = 'Toggle inlay hints' })
      end,
    })
  end,
}
