-- Leader keys
vim.g.mapleader = ','
vim.g.maplocalleader = '\\'

-- Clear search highlighting, diagnostics overlay, and quickfix/location lists
vim.keymap.set('n', '<leader><space>', function()
  vim.cmd.nohlsearch()
  vim.fn.clearmatches()
  vim.diagnostic.config({ virtual_lines = false })
  vim.cmd.cclose()
  vim.cmd.lclose()
end, { silent = true, desc = 'Clear' })

-- H/L go to first/last non-blank character on the line
vim.keymap.set('', 'H', '^')
vim.keymap.set('', 'L', 'g_')

-- Toggle folds with Space
vim.keymap.set('n', '<Space>', 'za')
vim.keymap.set('v', '<Space>', 'za')

-- :next / :previous
vim.keymap.set('n', '<C-N>', ':next<CR>')
vim.keymap.set('n', '<C-P>', ':previous<CR>')

-- Center search results
vim.keymap.set('', 'n', 'nzz')
vim.keymap.set('', 'N', 'Nzz')

-- Keep visual selection when indenting
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('v', '<', '<gv')

-- Window navigation
vim.keymap.set('', '<C-j>', '<C-w>j')
vim.keymap.set('', '<C-k>', '<C-w>k')
vim.keymap.set('', '<C-l>', '<C-w>l')
vim.keymap.set('', '<C-h>', '<C-w>h')

-- Wrapped line navigation
vim.keymap.set('', 'j', 'gj')
vim.keymap.set('', 'k', 'gk')

-- Last buffer
vim.keymap.set('n', '<leader>b', ':b#<CR>', { desc = 'Last buffer' })

-- Command typo fixes
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('WQ', 'wq', {})
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Q', 'q', {})

-- Text expansion
vim.cmd('iabbrev ldis ಠ_ಠ')
