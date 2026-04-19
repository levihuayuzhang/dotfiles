require("blink.cmp").setup({
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
})
