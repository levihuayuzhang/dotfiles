return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPre', 'BufNewFile' },
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'rust',
          'toml',
          'zig',
          'python',
          'go',
          'gomod',
          'gosum',
          'c',
          'asm',
          'glsl',
          'sql',
          'lua',
          'vim',
          'vimdoc',
          'markdown',
          'markdown_inline',
          'tsx',
          'typescript',
          'javascript',
          'html',
          'css',
          'scss',
          'regex',
          'json',
          'yaml',
          'xml',
          'vue',
          'java',
          'javadoc',
          'git_config',
          'gitcommit',
          'gitignore',
          'git_rebase',
          'doxygen',
          'dockerfile',
          'desktop',
          'hyprlang',
          -- 'latex',
        },

        sync_install = false,

        auto_install = true,

        highlight = {
          enable = true,

          additional_vim_regex_highlighting = false,
        },
        autotag = {
          enable = true,
        },
        indent = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<enter>',
            node_incremental = '<enter>',
            scope_incremental = false,
            node_decremental = '<bs>',
          },
        },
      }
    end,
  },
}
