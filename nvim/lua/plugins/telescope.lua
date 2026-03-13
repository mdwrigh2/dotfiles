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
  },
  config = function()
    require('telescope').load_extension('fzf')
  end,
}
