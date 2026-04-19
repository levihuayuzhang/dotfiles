vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {},
  -- LSP configuration
  server = {
    on_attach = function(client, bufnr)
      -- vim.api.nvim_set_hl(0, "@lsp.typemod.method.call", {
      --   underline = true,
      -- })
      -- vim.api.nvim_set_hl(0, "@lsp.type.method", {
      --   underline = true,
      -- })
      -- vim.api.nvim_set_hl(0, "@method", {
      --   underline = true,
      -- })

      vim.keymap.set("n", "<leader>a", function()
        vim.cmd.RustLsp("codeAction") -- grouping code actions
        -- vim.lsp.buf.codeAction() -- no grouping.
      end, { silent = true, buffer = bufnr, desc = "Grouped code actions" })

      vim.keymap.set(
        "n",
        "<leader>k", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
        function()
          vim.cmd.RustLsp({ "hover", "actions" })
        end,
        { silent = true, buffer = bufnr, desc = "Hover actions" }
      )

      vim.keymap.set({ "n", "x" }, "<leader>rem", function()
        vim.cmd.RustLsp("expandMacro")
      end, { desc = "Expand macros recursively" })

      vim.keymap.set({ "n", "x" }, "<leader>rhi", function()
        vim.cmd.RustLsp({ "view", "hir" })
      end, { desc = "View HIR" })

      vim.keymap.set({ "n", "x" }, "<leader>rmi", function()
        vim.cmd.RustLsp({ "view", "mir" })
      end, { desc = "View MIR" })

      vim.keymap.set({ "n", "x" }, "<leader>rb", function()
        vim.cmd.RustLsp("rebuildProcMacros")
      end, { desc = "Rebuild proc macros" })

      vim.keymap.set({ "n", "x" }, "<leader>rod", function()
        vim.cmd.RustLsp("openDocs")
      end, { desc = "Open docs.rs documentation" })

      vim.keymap.set({ "n", "x" }, "<leader>roc", function()
        vim.cmd.RustLsp("openCargo")
      end, { desc = "Open Cargo.toml" })

      vim.keymap.set({ "n", "x" }, "<leader>rcg", function()
        vim.cmd.RustLsp({ "crateGraph", "[backend]", "[output]" })
      end, { desc = "View crate graph" })

      vim.keymap.set({ "n", "x" }, "<leader>rpm", function()
        vim.cmd.RustLsp("parentModule")
      end, { desc = "Parent Module" })

      vim.keymap.set({ "n", "x" }, "<leader>rst", function()
        vim.cmd.RustLsp("syntaxTree")
      end, { desc = "View syntax tree" })

      vim.keymap.set({ "n", "x" }, "<leader>rf", function()
        vim.cmd.RustLsp("flyCheck") -- defaults to 'run'
        -- vim.cmd.RustLsp({ "flyCheck", "run" })
        -- vim.cmd.RustLsp({ "flyCheck", "clear" })
        -- vim.cmd.RustLsp({ "flyCheck", "cancel" })
      end, { desc = "Fly check" })

      vim.keymap.set({ "n", "x" }, "<leader>ree", function()
        vim.cmd.RustLsp("explainError") -- default to 'cycle'
        -- vim.cmd.RustLsp({ "explainError", "cycle" })
        -- vim.cmd.RustLsp({ "explainError", "cycle_prev" })
        -- vim.cmd.RustLsp({ "explainError", "current" })
      end, { desc = "Explain errors" })

      vim.keymap.set({ "n", "x" }, "<leader>rhr", function()
        vim.cmd.RustLsp({ "hover", "range" })
      end, { desc = " Hover range" })

      vim.keymap.set({ "n", "x" }, "<leader>rdr", function()
        vim.cmd.RustLsp("renderDiagnostic") -- defaults to 'cycle'
        -- vim.cmd.RustLsp({ "renderDiagnostic", "cycle" })
        -- vim.cmd.RustLsp({ "renderDiagnostic", "cycle_prev" })
        -- vim.cmd.RustLsp({ "renderDiagnostic", "current" })
      end, { desc = "Render diagnostics" })

      vim.keymap.set({ "n", "x" }, "<leader>rdj", function()
        vim.cmd.rustlsp("relateddiagnostics")
      end, { desc = "Jump to related diagnostics" })
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
          enable = true,
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

require("crates").setup()
