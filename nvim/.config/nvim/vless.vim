set encoding=utf-8
scriptencoding utf-8

set runtimepath&
set mouse=a
"let g:os = 'unknown'
"if (has('win16') || has('win32') || has('win64')) && !has("win32unix")
"    let g:os = 'win'
"elseif (has('win32unix'))
"    let g:os = 'cygwin'
"elseif (has('unix') || has('macunix'))
"    let g:os = 'unix'
"endif

"if (g:os ==# 'win') || (g:os ==# 'cygwin')
"    let g:Psep = ';'
"    let g:Fsep = '\'
"else
"    let g:Psep = ':'
"    let g:Fsep = '/'
"endif

""let g:python_host_prog  = 'python'
"let g:python3_host_prog = 'python3'

"let g:cache_home =  exists('$XDG_CACHE_HOME') ? '$XDG_CACHE_HOME' : '$HOME/.cache'
"let g:config_home =  exists('$XDG_CONFIG_HOME') ? '$XDG_CONFIG_HOME' : '$HOME/.config'

""""" DIRECTORIES

"if has('nvim')
"    let g:vim_home_dir = g:config_home . '/nvim/'
"    let g:plugin_dir = g:cache_home . '/nvim/nvimplugs/'
"    let g:backup_dir = g:cache_home . '/nvim/backup/'
"    let g:vim_snips_dir = g:vim_home_dir . '/snippets/'
"endif

"let g:autoload_dir = g:vim_home_dir . 'autoload/'
"let g:rc_dir = g:vim_home_dir . 'rc/'

"let g:vim_home_dir = fnameescape(expand(g:vim_home_dir))
"let g:plugin_dir   = fnameescape(expand(g:plugin_dir))
"let g:backup_dir   = fnameescape(expand(g:backup_dir))
"let g:rc_dir       = fnameescape(expand(g:rc_dir))
"let g:autoload_dir = fnameescape(expand(g:autoload_dir))

"if !isdirectory(g:plugin_dir)
"    call mkdir(g:plugin_dir, 'p')
"endif

"if !isdirectory(g:autoload_dir)
"    call mkdir(g:autoload_dir, 'p')
"endif

"if !isdirectory(g:backup_dir)
"    call mkdir(g:backup_dir, 'p')
"endif

"let $NVIM_PYTHON_LOG_FILE = g:backup_dir . "/nvimpython.log"


"let g:clipboard = {
"      \   'name': 'myClipboard',
"      \   'copy': {
"      \      '+': 'xclip -i',
"      \      '*': 'xclip -i',
"      \    },
"      \   'paste': {
"      \      '+': 'xclip -o',
"      \      '*': 'xclip -o',
"      \   },
"      \   'cache_enabled': 1,
"      \ }













"if empty(glob(g:vim_home_dir . g:Fsep . 'autoload' . g:Fsep . 'plug.vim'))
"    !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
"                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"endif

"call plug#begin(g:plugin_dir)


"Plug 'powerman/vim-plugin-AnsiEsc'           " gets rid of ^H shit


"call plug#end()




filetype plugin indent on
syn on

colorscheme spg-gruvbox

if argc() > 0
  let s:i = 0
  while 1
    if filereadable(argv(s:i))
      if s:i != 0
    sleep 3
      endif
      break
    endif
    if isdirectory(argv(s:i))
      echomsg "Skipping directory " . argv(s:i)
    elseif getftime(argv(s:i)) < 0
      echomsg "Skipping non-existing file " . argv(s:i)
    else
      echomsg "Skipping unreadable file " . argv(s:i)
    endif
    echo "\n"
    let s:i = s:i + 1
    if s:i == argc()
      quit
    endif
    next
  endwhile
endif

set nocp
"set ft=man
" set so=0
set noignorecase
set hlsearch
set incsearch
set nofoldenable

" Don't remember file names and positions
set shada=
set nows
set noautoindent

setlocal nolist
setlocal tabstop=8
setlocal buftype=nofile
setlocal bufhidden=hide
setlocal nobuflisted
setlocal noswapfile

set termguicolors

" When reading from stdin don't consider the file modified.
au VimEnter * set nomod

noremap <script> % %<SID>L
map p %

" Quitting
nnoremap q :q!<CR>
nnoremap <Esc><Esc> :set hlsearch!<CR>
noremap <C-u> 1<C-u>
noremap <C-d> 1<C-d>
