"3 ʕ◔ϖ◔ʔ Environment variable
if has("win64")
  let $XDG_CONFIG_HOME = expand($LOCALAPPDATA)
  let $XDG_DATA_HOME = expand($LOCALAPPDATA)
  let $XDG_CACHE_HOME  = expand($LOCALAPPDATA.'/nvim/cache')
else
  let $XDG_CONFIG_HOME = expand($HOME.'/.config')
  let $XDG_DATA_HOME = expand($HOME.'/.local/share')
  let $XDG_CACHE_HOME  = expand($HOME.'/.cache')
endif

augroup MyAutoCmd
    autocmd!
augroup END

"" ʕ◔ϖ◔ʔ disable python2
let g:session_directory=expand("~/data/nvim/session")    
let g:loaded_python_provider = 1
let g:python3_host_prog  = '/usr/bin/python'
"let g:python2_host_prog  = 'python2'

" ʕ◔ϖ◔ʔ Define dein repo path
let s:dein_dir = expand($XDG_CACHE_HOME) . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let $NVIM_PYTHON_LOG_FILE = s:dein_dir . '/nvimpython.log'

let g:dein#enable_notification = 1
let g:dein#install_log_filename = '~/dein.log'


" ʕ◔ϖ◔ʔ Clone dein.vim repository if it's not exits.
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif

" ʕ◔ϖ◔ʔ Add the dein installation directory into runtimepath
let &runtimepath = s:dein_repo_dir .",". &runtimepath
let g:dein#install_process_timeout = 9600

if dein#load_state(expand(s:dein_dir))
  call dein#begin(expand(s:dein_dir), [expand('<sfile>')])


  " ʕ◔ϖ◔ʔ Define dein toml file
  let s:toml_dir  = expand($XDG_CONFIG_HOME) . '/nvim'
  let s:toml_file = s:toml_dir . '/dein.toml'
  let s:toml_lazy_file = s:toml_dir . '/lazy.toml'
  call dein#load_toml(s:toml_file, {'trusted': 1, 'merged': 0, 'lazy': 0,})
  call dein#load_toml(s:toml_lazy_file, {'trusted': 1, 'merged': 0, 'lazy': 1,})



  call dein#end()
  call dein#save_state()
endif

" ʕ◔ϖ◔ʔ Installation check
if dein#check_install()
  call dein#install()
endif


"" ʕ◔ϖ◔ʔ Your settings here
" set ambiwidth=double   " for multibyte char
if has('nvim')
  set shada=!,'300,<50,s10,h
else
  set viminfo=!,'300,<50,s10,h
endif

" ʕ◔ϖ◔ʔ Useful setting
let mapleader = "\\"
nnoremap <Esc> :nohlsearch<CR>


filetype plugin indent on
syn on


" fix dein syntax hilight
autocmd MyAutoCmd BufNewFile,BufRead *.toml call s:syntax_range_dein()

function! s:syntax_range_dein() abort
  let start = '^\s*hook_\%('.
  \           'add\|source\|post_source\|post_update'.
  \           '\)\s*=\s*%s'

  call SyntaxRange#Include(printf(start, "'''"), "'''", 'vim', '')
  call SyntaxRange#Include(printf(start, '"""'), '"""', 'vim', '')
endfunction



