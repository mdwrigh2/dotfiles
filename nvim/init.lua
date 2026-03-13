require("options")

-- Set up runtimepath so Pathogen and bundles are available, then source vimrc
if vim.fn.has('win32') == 1 then
  vim.opt.runtimepath:prepend('~/vimfiles')
  vim.opt.runtimepath:append('~/vimfiles/after')
  vim.opt.packpath = vim.opt.runtimepath:get()
  vim.cmd('source ~/_vimrc')
else
  vim.opt.runtimepath:prepend('~/.vim')
  vim.opt.runtimepath:append('~/.vim/after')
  vim.opt.packpath = vim.opt.runtimepath:get()
  vim.cmd('source ~/.vimrc')
end
