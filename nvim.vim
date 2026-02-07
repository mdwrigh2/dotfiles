if has('win32')
  set runtimepath^=~/vimfiles runtimepath+=~/vimfiles/after
  let &packpath = &runtimepath
  source ~/_vimrc
else
  set runtimepath^=~/.vim runtimepath+=~/.vim/after
  let &packpath = &runtimepath
  source ~/.vimrc
endif

