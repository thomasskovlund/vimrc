"""""""""""""""""""""""""""""""""""""
" Written by:
"	Thomas Skovlund Hansen
"
" Inspired by:
"	Amir Salihefendic
"	http://amix.dk - amix@amix.dk
"	Syntax highlighted version: http://amix.dk/vim/vimrc.html
"	Raw version: http://amix.dk/vim/vimrc.txt
"	
" Version:
"	0.1 - 25/12/2016
"
" Sections:
"    1. General
"    2. VIM user interface
"    3. Colors and fonts
"    4. Text, tab and indent related 
"    5. Visual mode related
"    6. Moving around, tabs, windows and buffers 
"    7. Status line 
"    8. Helper functions
"
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" 1. General
"""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" Ask to save a document instead of saying that it is not saved
set confirm

"""""""""""""""""""""""""""""""""""""
" 2. VIM user interface
"""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*.class

" Always show current position
set ruler

" Enable line numbers
set number

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Configure indents
set autoindent
set smartindent

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase
set infercase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a seconds to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Make system clipboard interact with VIM
set clipboard=unnamedplus


"""""""""""""""""""""""""""""""""""""
" 3. Colors and fonts
"""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

colorscheme desert
set background=dark

" Set utf8 as standard encoding
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

"""""""""""""""""""""""""""""""""""""
" 4. Text, tab and indent related 
"""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 charactors
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Toggle unmodified (un-auto-indented) paste on and off
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

""" Set format options to don't auto comment a new line
" Don't auto-wrap comments using textwidth, inserting the current comment leader automatically.
autocmd FileType * setlocal formatoptions-=c 
" Don't automatically insert the current comment leader after hitting <Enter> in Insert mode.
autocmd FileType * setlocal formatoptions-=r 
" Don't automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode.
autocmd FileType * setlocal formatoptions-=o 

" Try to handle pasting from system clipboard cleverly 
" (ie. without indenting an already indented file)

" Code from:
" http://stackoverflow.com/questions/5585129/pasting-code-into-terminal-window-into-vim-on-mac-os-x
" then https://coderwall.com/p/if9mda
" and then https://github.com/aaronjensen/vimfiles/blob/59a7019b1f2d08c70c28a41ef4e2612470ea0549/plugin/terminaltweaks.vim
" to fix the escape time problem with insert mode.
"
" Docs on bracketed paste mode:
" http://www.xfree86.org/current/ctlseqs.html
" Docs on mapping fast escape codes in vim
" http://vim.wikia.com/wiki/Mapping_fast_keycodes_in_terminal_Vim

if !exists("g:bracketed_paste_tmux_wrap")
  let g:bracketed_paste_tmux_wrap = 1
endif

function! WrapForTmux(s)
  if !g:bracketed_paste_tmux_wrap || !exists('$TMUX') || system('tmux -V')[5] >= '2'
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_ti .= WrapForTmux("\<Esc>[?2004h")
let &t_te .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin(ret)
  set pastetoggle=<f29>
  set paste
  return a:ret
endfunction

execute "set <f28>=\<Esc>[200~"
execute "set <f29>=\<Esc>[201~"
map <expr> <f28> XTermPasteBegin("i")
imap <expr> <f28> XTermPasteBegin("")
vmap <expr> <f28> XTermPasteBegin("c")
cmap <f28> <nop>
cmap <f29> <nop>

"""""""""""""""""""""""""""""""""""""
" 5. Visual mode related
"""""""""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

"""""""""""""""""""""""""""""""""""""
" 6. Moving around, tabs, windows and buffers 
"""""""""""""""""""""""""""""""""""""
" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\   exe "normal! g`\"" |
	\ endif
" Remember info about open buffers on close
set viminfo^=%

"""""""""""""""""""""""""""""""""""""
" 7. Status line 
"""""""""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the statusline
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l 

"""""""""""""""""""""""""""""""""""""
" 8. Helper functions 
"""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction
