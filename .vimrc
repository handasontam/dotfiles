let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/Vundle.vim/README.md')
if !filereadable(vundle_readme)
  echo "Installing Vundle.."
  echo ""
  silent !mkdir -p ~/.vim/bundle
  silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  let iCanHazVundle=0
endif
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
if iCanHazVundle == 0
    echo "Installing Bundles, please ignore key map error messages"
    echo ""
    :PluginInstall
endif
" END - Setting up Vundle - the vim plugin bundler
Plugin 'tpope/vim-fugitive'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'godlygeek/tabular'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'kien/ctrlp.vim'
Plugin 'lilydjwg/colorizer'
Plugin 'maverickg/stan.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'sjl/gundo.vim'


" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

Plugin 'itchyny/lightline.vim'

Plugin 'terryma/vim-multiple-cursors'

" Vim
Plugin 'lervag/vimtex'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" System Settings
set encoding=utf-8
set showcmd                            " Display partial commands
augroup stahp
    autocmd!
    autocmd GUIEnter * set visualbell t_vb=  " Disable error bells
augroup END
" Auto-cd into the file's dir
augroup autocd
  autocmd BufEnter * silent! lcd %:p:h
augroup END
set hidden                             " Change buffers without saving
set shortmess=I                        " Disable intro message
set mouse=a                            " Mouse support in terminal
set autoread                           " Reload files outside vim
set clipboard=unnamed                  " Set to system's clipboard register

" Temp Directories
set backup                             " Enable backups
set noswapfile                         " It's the 21st century, Vim
set undofile                           " Enable persistent undo
set backupdir=~/.vim/tmp/backup
set undodir=~/.vim/tmp/undo
set viminfo='10,\"100,:20,%

" Searching, Highlighting, Replacing Settings
set ignorecase                         " Case-insensitive matching...
set smartcase                          "  except case-sensitive searches
set incsearch                          " Incremental searching
set gdefault                           " Substitute all occurrences only in line
set modelines=1                        " Let OS X read ft commands in files
set wildmenu                           " Tab-completion features in cmd-line mode
set wildmode=list:full


" Formatting
set backspace=indent,eol,start         " Expected backspacing
set linebreak                          " Don't linebreak words in the middle
set display=lastline                   " Displays partial wrapped lines
set tw=80                              " Auto linebreak at 80 characters
"set tw=70                              " Auto linebreak at 70 characters
set formatoptions=rotcq                " Format options with new lines
set autoindent                         " Hard wrap with autoindent
set cursorline                         " Cursor Highlight, Color
set number                             " Show absolute number for cursor line
set relativenumber                     " Line numbers relative to cursor line
set cmdwinheight=1                     " Self-explanatory
set ttyscroll=3                        " Speeds up screen redrawing
set lazyredraw                         " To avoid scroll lag on long ass lines
set scrolloff=10                       " Minimum # of lines shown above/below cursor
set splitbelow                         " Split windows as expected
set splitright
set wmh=0 wmw=0                        " Only see filename when minimized
augroup no_indent
  autocmd!
  autocmd FileType text set formatoptions=rol
augroup END

" Colors & Statusline
" Statusline modified from
" https://medium.com/@kadek/the-last-statusline-for-vim-a613048959b2
if has('gui_running')
  set guioptions=
  set guifont=Monaco
  colorscheme monokai
else
  set t_Co=256
  " set termguicolors
  colorscheme molokai
endif
syntax on
syntax enable
set noshowmode
set notitle
set laststatus=2
set statusline=
set statusline+=%2*\ %{fugitive#head()}
set statusline+=%2*\ ››
set statusline+=\ %*
set statusline+=%1*\ %m             " Modified flag
set statusline+=%1*\ %r             " Read-only flag
set statusline+=%1*\ %f\ %*         " Relative path to file
set statusline+=%1*\ ››
set statusline+=%=                  " Switch to right-hand-side
set statusline+=%3*\ ‹‹
set statusline+=%3*\ %{&ft}         " Filetype
set statusline+=%3*\ %cC            " Column number
set statusline+=%3*\ %p%%\ %*       " Percentage through file
hi User1 guifg=#FFFFFF guibg=#191f26 gui=BOLD
hi User2 guifg=#000000 guibg=#959ca6
hi User3 guifg=#000000 guibg=#4cbf99

" Tab Settings
set expandtab                          " Spaces as tabs
set shiftwidth=2                       " 4-character tabs
set softtabstop=2                      " Fix it to 2

" 1 sec <Esc> delay in terminal? Vim pls
" set noesckeys
" nnoremap <Esc> <Nop>
set ttimeout
set ttimeoutlen=100
set timeoutlen=3000

"###############################################################################
" folding styles
"###############################################################################
function! FoldLevels()
  let thisline = getline(v:lnum)
  if thisline != ''
    let nextline = getline(v:lnum + 1)
    if match(nextline, '-\{5,\}$') >= 0
      return ">1"
    endif
  endif
  return "="
endfunction

function! NeatFoldText()
  let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
  let foldchar = matchstr(&fillchars, 'fold:\zs.')
  let foldtextstart = strpart('»' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(foldchar, 8)
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction

set foldmethod=expr
set foldexpr=FoldLevels()
set foldtext=NeatFoldText()

"###############################################################################
" When 'dd'ing blank lines, don't yank them into the register
"###############################################################################

function! DDWrapper()
  if getline('.') =~ '^\s*$'
    normal! "_dd
  else
    normal! dd
  endif
endfunction
nnoremap <silent> dd :call DDWrapper()<CR>

"###############################################################################
" Restore cursor to previous position and unfold just enough to see cursor line
"###############################################################################

function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

if has("folding")
  function! UnfoldCur()
  if !&foldenable
    return
  endif
  let cl = line(".")
  if cl <= 1
    return
  endif
  let cf  = foldlevel(cl)
  let uf  = foldlevel(cl - 1)
  let min = (cf > uf ? uf : cf)
  if min
    execute "normal!" min . "zo"
    return 1
  endif
  endfunction
endif

augroup resCur
  autocmd!
  if has("folding")
    autocmd BufWinEnter * if ResCur() | call UnfoldCur() | endif
  else
    autocmd BufWinEnter * call ResCur()
  endif
augroup END

"###############################################################################
" Fold all toggle
"###############################################################################

let g:foldtoggle = 0
function! FoldAllToggle()
  if g:foldtoggle == 0
    let g:foldtoggle = 1
    normal! zR
  else
    let g:foldtoggle = 0
    normal! zM
  endif
endfunction
noremap <silent> <S-Space> :call FoldAllToggle()<CR>
" A temporary workaround for terminal Vim, since foldlevelstart ain't working
"noremap <silent> <S-F1> :call FoldAllToggle()<CR>
if !has('gui_running')
augroup auto_fold
  autocmd!
  autocmd VimEnter * call FoldAllToggle()
augroup END
endif

" Mappings
" -----------------------------------------------------------------------------

"###############################################################################
" General
"###############################################################################

let mapleader = ","
nnoremap <silent> <C-e> :silent e#<CR>
noremap j gj
noremap gj j
noremap k gk
noremap gk k
noremap ; :
nnoremap <C-a> ggVG
nnoremap <Space> za
nnoremap <silent> <Leader><Space> :set hlsearch!<CR>
vnoremap < <gv
vnoremap > >gv
noremap <S-CR> O<Esc>
noremap <CR> o<Esc>
nnoremap x "_x
nnoremap Y y$
"cnoremap <C-v> <C-R>*<BS>
"inoremap <C-v> <C-R>*
noremap Q @
nnoremap ' '.
noremap <silent> <C-y> :let @+=expand("%:p:h")<CR>

"###############################################################################
" Buffers, Windows, & Tabs
"###############################################################################
" I use a combination of windows and tabs. I use netrw for a file
" explorer. I use fzf for farther searching across directories. I
" don't use buffers or markers.

noremap  <silent> <C-t> :tabe<CR>
noremap! <silent> <C-t> :tabe<CR>
" Lexplore doesn't toggle if directory or opened file changes. Use
" this hack instead.
let g:NetrwIsOpen = 0
function! ToggleLexplore()
  if g:NetrwIsOpen
    let i = bufnr("$")
    while (i >= 1)
      if (getbufvar(i, "&filetype") == "netrw")
        silent exe "bwipeout " . i
      endif
      let i-=1
    endwhile
    let g:NetrwIsOpen=0
  else
    let g:NetrwIsOpen=1
    silent Lexplore
  endif
endfunction
" TODO(trandustin): close netrw after opening
nnoremap <silent> <C-q> :call ToggleLexplore()<CR>
if !has('gui_running')
  nnoremap <silent> <Leader>q: call ToggleLexplore()<CR>
endif
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_list_hide = '.DS_Store,.*\.pyc$'
let g:netrw_liststyle = 3
let g:netrw_winsize = 30

" Plugins
" -----------------------------------------------------------------------------

"###############################################################################
" Ctrl-P
"###############################################################################

" nnoremap <C-p> :History<CR>
" let g:fzf_history_dir = '~/.cache/fzf'
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_show_hidden = 1
set wildignore+=*.doc,*.docx,*.ods,*.xlsx
set wildignore+=*.db,*.epub,*.lnk,*.mobi,*.pdf
set wildignore+=*.git,*.pyc,*.pyo,*.exe,*.dll,*.obj,*.o,*.a,*.lib,*.so,*.dylib
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*.flac,*.mp3
set wildignore+=*.mkv
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
