return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPre', 'BufNewFile' },
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          -- 'rust',
          -- 'latex',
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
        },

        sync_install = false,

        auto_install = true,

        highlight = {
          enable = true,
          disable = {
            'latex', -- use vimtex
            'rust', -- use rust-analyzer
          },
          additional_vim_regex_highlighting = true,
        },
        autotag = {
          enable = true,
        },
        indent = {
          enable = true,
        },
        --[[ incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<enter>',
            node_incremental = '<enter>',
            scope_incremental = false,
            node_decremental = '<bs>',
          },
        }, ]]
      }
    end,
  },
}
