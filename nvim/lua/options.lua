-- Core editor options

-- Persistent undos
vim.opt.undofile = true

-- Keep backup/tmp files in one place
vim.opt.backup = true
if vim.fn.has('win32') == 1 then
  vim.opt.backupdir = vim.fn.expand('~/vimfiles/backup')
  vim.opt.directory = vim.fn.expand('~/vimfiles/tmp')
else
  vim.opt.backupdir = vim.fn.expand('~/.vim/backup')
  vim.opt.directory = vim.fn.expand('~/.vim/tmp')
end

-- Editing behavior
vim.opt.number = true
vim.opt.confirm = true
vim.opt.clipboard = 'unnamedplus'

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Display
vim.opt.linebreak = true

-- Indentation defaults
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Text width
vim.opt.textwidth = 99
vim.opt.colorcolumn = '+1'
vim.opt.shiftround = true

-- Wildcard ignore
vim.opt.wildignore = { '*.o', '*.obj', '*.bak', '*.exe', '*.hi', '*.6' }

-- Whitespace characters
vim.opt.list = true
vim.opt.listchars = { tab = '»·', trail = '·', nbsp = '·' }

-- LaTeX flavor
vim.g.tex_flavor = 'latex'
