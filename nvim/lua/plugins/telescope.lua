return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  keys = {
    { '<leader>o', '<cmd>Telescope find_files<cr>', desc = 'Find files' },
    { '<leader>m', '<cmd>Telescope buffers<cr>', desc = 'Buffers' },
    { '<leader>/', '<cmd>Telescope live_grep<cr>', desc = 'Live grep' },
    { '<leader>?', '<cmd>Telescope oldfiles<cr>', desc = 'Recent files' },
    { '<leader>s', '<cmd>Telescope lsp_document_symbols<cr>', desc = 'Document symbols' },
    { '<leader>ws', '<cmd>Telescope lsp_workspace_symbols<cr>', desc = 'Workspace symbols' },
  },
  config = function()
    require('telescope').setup({
      defaults = {
        file_ignore_patterns = {
          '%.git/',
          'node_modules/',
          'out/',
          '%.class$',
          '%.o$',
          '%.so$',
          '%.a$',
          'target/',
          'dist/',
        },
      },
    })
    require('telescope').load_extension('fzf')
  end,
}
