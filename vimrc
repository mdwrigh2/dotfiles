" Enable Pathogen
filetype off
call pathogen#runtime_append_all_bundles()

" Turn on filetype based plugins
filetype plugin indent on

" Use VIM settings, rather than Vi settings
set nocompatible

" Always show the status line
set laststatus=2

set encoding=utf-8

set ttyfast

set history=1000

" Persistent undos
if v:version >= 703
  set undofile
  set undoreload=10000
endif

" Keep temporary files and backup files in one dir rather than cluttering
" source dirs.
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp

" Keep at least 5 lines around whever I'm scrolling
"set scrolloff=5
"set sidescrolloff=5

" Make backspace work on everything, everywhere
set backspace=indent,eol,start

" Turn on line numbers
set nu

" Set visual bell rather than audible bell
set vb

" Have ctags look all the way up to root for a tags file
set tags=tags;/

"Enable syntax highlighting
syntax on

" Auotmatically indent based on file type
set autoindent

" Setup cindent options
set cinkeys=0{,0},0),:,0#,!^F,o,O,e
set cinoptions=:0,l1,g0,+2s,j1,J1

" Case insensitive search (smartcase)
set ignorecase smartcase

" Highlight search
set hls

" Wrap text instead of being on one line
set lbr

" Turn the ruler on
set ruler

" Incremental search
set incsearch

" show commands as you're typing them
set showcmd

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Text expansion macros
iabbrev ldis ಠ_ಠ

" Fix the leader to be something a little nicer
let mapleader=","

" Make it easier to clear search results
noremap <leader><space> :noh<cr>:call clearmatches()<cr>

" Quick shortcut to open vimrc and another to resource it
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Make it easier to move around
noremap H ^
noremap L g_

" Set space to toggle folds
nnoremap <Space> za
vnoremap <Space> za

" Remap Ctrl-N and Ctrl-P to :next and :previous, respectively
nnoremap <C-N> :next<Enter>
nnoremap <C-P> :previous<Enter>
set confirm

" Have searches center the line the word is found on
map N Nzz
map n nzz

" Make block stay highlighted when changing indentation
vnoremap > >gv
vnoremap < <gv

" Bind NERDTree commands
map <F2> :NERDTreeToggle<CR>
map <C-c> <Leader>ci 

" Work better with splits
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
map <C-h> <C-w>h

" Make j/k work as expected with wrapped lines
map j gj
map k gk

" These don't have bindings anyways
command Wq wq
command WQ wq
command W w
command Q q

" Make it easier to go to the last buffer
nnoremap <leader>b :b#<CR>

if has("unix")
  let s:uname = system("echo -n $(uname)")
  if s:uname == "Darwin"
    " Mac specific bindings

    " Set font
    set gfn=Inconsolata:h14

  else
    " Linux specific bindings

    " Set font
    set gfn=Inconsolata\ 12

    "Bind copy and paste to Ctrl-Shift-C/V
    vnoremap <C-C> "+y
    nnoremap <C-C> "+yy
    noremap <C-V> "+p
    imap <C-V> <Esc><C-V>a
    cnoremap <C-V> <C-R>+
    cnoremap <C-V> <C-R>+

  endif
endif

" Setup Command-T bindings
noremap <Leader>o <Esc>:CommandT<CR>
noremap <Leader>O <Esc>:CommandTFlush<CR>
noremap <Leader>m <Esc>:CommandTBuffer<CR>
let g:CommandTCancelMap='<Esc>' " Not sure why this was getting unset

" Fugitive bindings
nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gw :Gwrite<cr>
nnoremap <leader>ga :Gadd<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gco :Gcheckout<cr>
nnoremap <leader>gci :Gcommit<cr>
nnoremap <leader>gm :Gmove<cr>
nnoremap <leader>gr :Gremove<cr>
nnoremap <leader>gl :Shell git gl -18<cr>:wincmd \|<cr>

vnoremap <leader>t :Tabularize /

" Set Powerline to use unicode rather than compatible
let g:Powerline_symbols="unicode"

" Turn off syntastics syntax highlighting and signs
let g:syntastic_enable_highlighting = 0
let g:syntastic_enable_signs = 0

" Highlight clojure's builtins
let vimclojure#HighlightParen = 1
" Rainbow parens for clojure
let vimclojure#ParenRainbow = 1

" Set slime-vim to use tmux (alternative to screen)
let g:slime_target = "tmux"

augroup ft_fugitive
    au!

    au BufNewFile,BufRead .git/index setlocal nolist
augroup END

" Built-in LISP settings
let g:lisp_rainbow = 1

" Set indentation to spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smarttab expandtab

set shiftround " Round to the nearest shiftwidth when indenting with > and <

" Have it keep changes to open buffers without saving to the files
set hidden

" Setup OmniComplete to be context aware
let g:SuperTabDefaultCompletionType="context"

" Prevents Vim 7.0 from setting filetype to 'plaintex'
let g:tex_flavor='latex'


" Ignore silly files
set wildignore=*.o,*.obj,*.bak,*.exe,*.hi,*.6

" Set colorscheme
set background=dark
colorscheme molokai

" Force vim to use 256 colors
set t_Co=256


" Mark trailing whitespace
set listchars=tab:\ \ ,trail:\ ,extends:»,precedes:«
if &background == "dark"
  highlight ExtraWhitespace ctermbg=Red guibg=Red
else
  highlight ExtraWhitespace ctermbg=Yellow guibg=Yellow
end
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()


" Remove the toolbar if it's macvim or gvim
if has("gui_running")
  set guioptions-=T
endif

" Set go filetype
au BufNewFile,BufRead *.go set filetype=go

" Set .y filetype to happy
"   This may need to be changed back if I need to write something with yacc
au BufNewFile,BufRead *.y set filetype=happy

" Setup custom notes filetype
au BufNewFile,BufRead *.notes nnoremap <leader>s :SPCheck<CR>

" Set alex filetype
au BufNewFile,BufRead *.x set filetype=alex

" Set sjs filetype
au BufNewFile,BufRead *.sjs set filetype=javascript
" Set njs filetype
au BufNewFile,BufRead *.njs set filetype=javascript
" Set asm to MASM
au BufNewFile,Bufread *.asm set filetype=masm
au BufNewFile,Bufread *.ASM set filetype=masm

" Setup django templating highlighting for all html
au BufNewFile,Bufread *.html set filetype=htmldjango tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" Setup the file type for EBNFs
au BufNewFile,BufRead *.ebnf set filetype=ebnf

" Setup the filetype for markdown
au BufNewFile,BufRead *.md set filetype=markdown

" Set indentation for Python according to Google Style Guide
au FileType python set tabstop=4 shiftwidth=4 softtabstop=4 expandtab textwidth=79

" Set indentation for Haskell according to the snap style guide
au FileType haskell set tabstop=4 shiftwidth=4 softtabstop=4 expandtab textwidth=78

" Set indentation for Ruby according to Google Style Guide
au Filetype ruby set tabstop=2 shiftwidth=2 expandtab

" Set indentation for C according to Google Style Guide
au Filetype c set tabstop=2 shiftwidth=2 expandtab

" Set indentation for C++ according to Google Style Guide
au Filetype cpp set tabstop=2 shiftwidth=2 expandtab

" Set indentention for Make files
au Filetype make set noexpandtab

" Set indentation for Go files
au Filetype go setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4

" Set indentation for HTML files
au Filetype html set tabstop=2 shiftwidth=2 expandtab
au FileType xhtml set tabstop=2 shiftwidth=2 expandtab

" Set settings for LaTeX files
au Filetype tex SPCheck
au Filetype tex let dialect='US'

" Set settings for XML files
au Filetype xml set tabstop=4 shiftwidth=4 softtabstop=4 expandtab


" Setup Binary Editing Mode
" autocmds to automatically enter hex mode and handle file writes properly
if has("autocmd")
  " vim -b : edit binary using xxd-format!
  augroup Binary
    au!

    " set binary option for all binary files before reading them
    au BufReadPre *.bin,*.hex setlocal binary

    " if on a fresh read the buffer variable is already set, it's wrong
    au BufReadPost *
          \ if exists('b:editHex') && b:editHex |
          \   let b:editHex = 0 |
          \ endif

    " convert to hex on startup for binary files automatically
    au BufReadPost *
          \ if &binary | Hexmode | endif

    " When the text is freed, the next time the buffer is made active it will
    " re-read the text and thus not match the correct mode, we will need to
    " convert it again if the buffer is again loaded.
    au BufUnload *
          \ if getbufvar(expand("<afile>"), 'editHex') == 1 |
          \   call setbufvar(expand("<afile>"), 'editHex', 0) |
          \ endif

    " before writing a file when editing in hex mode, convert back to non-hex
    au BufWritePre *
          \ if exists("b:editHex") && b:editHex && &binary |
          \  let oldro=&ro | let &ro=0 |
          \  let oldma=&ma | let &ma=1 |
          \  silent exe "%!xxd -r" |
          \  let &ma=oldma | let &ro=oldro |
          \  unlet oldma | unlet oldro |
          \ endif

    " after writing a binary file, if we're in hex mode, restore hex mode
    au BufWritePost *
          \ if exists("b:editHex") && b:editHex && &binary |
          \  let oldro=&ro | let &ro=0 |
          \  let oldma=&ma | let &ma=1 |
          \  silent exe "%!xxd" |
          \  exe "set nomod" |
          \  let &ma=oldma | let &ro=oldro |
          \  unlet oldma | unlet oldro |
          \ endif
  augroup END
endif


" Who doesn't live Nyan cat?
function! NyanMe() " {{{
    hi NyanFur             guifg=#BBBBBB
    hi NyanPoptartEdge     guifg=#ffd0ac
    hi NyanPoptartFrosting guifg=#fd3699 guibg=#fe98ff
    hi NyanRainbow1        guifg=#6831f8
    hi NyanRainbow2        guifg=#0099fc
    hi NyanRainbow3        guifg=#3cfa04
    hi NyanRainbow4        guifg=#fdfe00
    hi NyanRainbow5        guifg=#fc9d00
    hi NyanRainbow6        guifg=#fe0000


    echohl NyanRainbow1
    echon "≈"
    echohl NyanRainbow2
    echon "≋"
    echohl NyanRainbow3
    echon "≈"
    echohl NyanRainbow4
    echon "≋"
    echohl NyanRainbow5
    echon "≈"
    echohl NyanRainbow6
    echon "≋"
    echohl NyanRainbow1
    echon "≈"
    echohl NyanRainbow2
    echon "≋"
    echohl NyanRainbow3
    echon "≈"
    echohl NyanRainbow4
    echon "≋"
    echohl NyanRainbow5
    echon "≈"
    echohl NyanRainbow6
    echon "≋"
    echohl None
    echo ""

    echohl NyanRainbow1
    echon "≈"
    echohl NyanRainbow2
    echon "≋"
    echohl NyanRainbow3
    echon "≈"
    echohl NyanRainbow4
    echon "≋"
    echohl NyanRainbow5
    echon "≈"
    echohl NyanRainbow6
    echon "≋"
    echohl NyanRainbow1
    echon "≈"
    echohl NyanRainbow2
    echon "≋"
    echohl NyanRainbow3
    echon "≈"
    echohl NyanRainbow4
    echon "≋"
    echohl NyanRainbow5
    echon "≈"
    echohl NyanRainbow6
    echon "≋"
    echohl NyanFur
    echon "╰"
    echohl NyanPoptartEdge
    echon "⟨"
    echohl NyanPoptartFrosting
    echon "⣮⣯⡿"
    echohl NyanPoptartEdge
    echon "⟩"
    echohl NyanFur
    echon "⩾^ω^⩽"
    echohl None
    echo ""

    echohl NyanRainbow1
    echon "≈"
    echohl NyanRainbow2
    echon "≋"
    echohl NyanRainbow3
    echon "≈"
    echohl NyanRainbow4
    echon "≋"
    echohl NyanRainbow5
    echon "≈"
    echohl NyanRainbow6
    echon "≋"
    echohl NyanRainbow1
    echon "≈"
    echohl NyanRainbow2
    echon "≋"
    echohl NyanRainbow3
    echon "≈"
    echohl NyanRainbow4
    echon "≋"
    echohl NyanRainbow5
    echon "≈"
    echohl NyanRainbow6
    echon "≋"
    echohl None
    echon " "
    echohl NyanFur
    echon "”   ‟"
    echohl None

    sleep 1
    redraw
    echo " "
    echo " "
    echo "Noms?"
    redraw
endfunction " }}}
command! NyanMe call NyanMe()
