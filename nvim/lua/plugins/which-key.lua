return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    spec = {
      { '<leader>c', group = 'Code' },
      { '<leader>d', group = 'Diagnostic' },
      { '<leader>h', group = 'Hunk/Git' },
      { '<leader>r', group = 'Rename' },
      { '<leader>w', group = 'Workspace' },
    },
  },
}
