scriptencoding utf-8


" shift tab sux
" exe 'set t_kB=' . nr2char(27) . '[Z'


" Gui {{{

set switchbuf=useopen,
set mouse=a
set updatetime=300
set clipboard=unnamed
set inccommand=split                   " holycrap there's interactive %s colors now!!!!
set cursorline                         " highlight current line
set colorcolumn=102                    " try not to code paste here
set foldcolumn=2                       " pretty column display folds

"set synmaxcol=200
"syn sync minlines=256

" set redrawtime=10000
" syn sync maxlines=500
""set conceallevel=2                    " plz dont hide stuff
set sessionoptions-=globals

set foldenable                        " fold by default
set foldlevelstart=99                 " 0 is start folded
set foldlevel=99                      " 0 is start folded
set foldmethod=marker                 " default marker folding
"set foldnestmax=20                   " deepest fold is 3 levels

set noruler
set nolazyredraw                        " supposedly speeds things up
set number                            " Line numbers are good
set showcmd                           " Show incomplete cmds down the bottom
set showmode                          " Show current mode down the bottom
set showmatch                         " matching parens highlight
set title
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)
" set guicursor=n-v-c:ver90,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:Cursor/Cursor
set guicursor&
set hlsearch                        " Highlight searches off by default
set incsearch                         " Find the next match as we type the search
set linebreak                         " Wrap lines at convenient points
set laststatus=2                      " always show statusline
set list                              " enable showing the chars above
set guioptions=egrLtmc
set showtabline=1
set guifont=Consolas\ NF:style=Book:h12
" set guifont=Consolas_for_Powerline_FixedD:h12:cANSI:qDRAFT
" set tabline=%!Tabline()
" let &showbreak = '+++ '

if ! has('win32')
    "set listchars=tab:→\ ,eol:↲,nbsp:␣,extends:⟩,precedes:⟨
    set listchars=tab:→\ ,nbsp:␣,extends:⟩,precedes:⟨
else
    set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
endif

set mousefocus
set mousemodel=popup
set scrolloff=2                       " Start scrolling when we're 8 lines away from margins
set sidescrolloff=2
set sidescroll=1
set signcolumn=yes
set wrap                            " Don't wrap lines

set t_vb=                             " disable the fk'ing bell
set novisualbell                      " No sounds
set noerrorbells                      " third time's the charm
set belloff=all                       " fourth try?


" # }}}

" Statusline {{{
function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? '' : printf(
    \   '%dW %dE',
    \   l:all_non_errors,
    \   l:all_errors
    \)
endfunction


let g:sg_mode_map = {
      \     'n': 'NORMAL', 'i': 'INSERT', 'R': 'REPLACE', 'v': 'VISUAL', 'V': 'V-LINE',
      \      "\<C-v>": 'V-BLOCK', 'c': 'COMMAND', 's': 'SELECT', 'S': 'S-LINE', "\<C-s>": 'S-BLOCK',
      \      't': 'TERMINAL'
      \   }

" let g:active_statusline='%#StatMode1#'
" let g:active_statusline.="%( %{get(g:sg_mode_map, mode(),'')} %)"  " insert/normal/visual
let g:active_statusline='%#StatMode1#'
let g:active_statusline.='%#warningmsg#'
" let g:active_statusline.='%{LinterStatus()}'
let g:active_statusline.='%#StatDark2#'
let g:active_statusline.='%{(&paste)||(&readonly)?"|":""}'         " paste toggle
let g:active_statusline.='%(%{&paste?"PASTE":""}%)'
let g:active_statusline.='%{(&paste)&&((&readonly))?"|":""}'
let g:active_statusline.='%( %R %)'                                " readonly
let g:active_statusline.='%( %h %q %)'                             " help flag
let g:active_statusline.='%( %F %)'                                " relative path
let g:active_statusline.='%{(&modified||!&modifiable)?"|":""}'
let g:active_statusline.='%( %M %)'                                " modified
let g:active_statusline.='%#StatDark3#'
" let g:active_statusline.='%(%{g:ale_enabled?"AleOn |":"AleOff"}%)'
let g:active_statusline.='%(%2p%% %)'                             " percent scrolled
let g:active_statusline.='%='
let g:active_statusline.=' %(%{&ff}%) |'                           " file format (line ending style)
let g:active_statusline.="%( %{&fenc!=#''?&fenc:&enc}%) |"         " file encoding
let g:active_statusline.="%( %{&ft!=#''?&ft:'no ft'} %)"           " file type
let g:active_statusline.='%#StatDark4#'
let g:active_statusline.=' [%3b][0x%2B]'                          " [dec][hex] curByte
let g:active_statusline.='%#StatDark5#'
let g:active_statusline.='%( %-2v/%l/%L %)'               " curLine/maxLine : colNum

let g:inactive_statusline = '%#StatDark2#'
let g:inactive_statusline.="%( %{get(g:sg_mode_map, mode(),'')} %)"
let g:inactive_statusline.='%{(&paste)||(&readonly)?"|":""}'
let g:inactive_statusline.='%(%{&paste?"PASTE":""}%)'
let g:inactive_statusline.='%{(&paste)&&((&readonly))?"|":""}'
let g:inactive_statusline.='%( %R %)'
let g:inactive_statusline.='%( %h %q %)'
let g:inactive_statusline.='%( %f %)'
let g:inactive_statusline.='%{(&modified||!&modifiable)?"|":""}'
let g:inactive_statusline.='%( %M %)'
"let g:inactive_statusline.='%(%{g:ale_enabled?" Lint |":""}%)'
let g:inactive_statusline.=' %(%2p%% %)'

" let &statusline = g:active_statusline

" # }}}

" Etc {{{
set shellcmdflag&
set shell=/usr/bin/zsh\ -l
set shellxquote&
set formatoptions=jql
set gdefault                         " s///g implied
set noautoread                        " dont silently reload files changed outside vim
set autowriteall
set backspace=indent,eol,start        " Allow backspace in insert mode
set expandtab
set fileencoding=utf-8                " The encoding written to file.

set viewoptions-=options              " when we save a view dont save options
set hidden                            " buffers can exist sans window
set history=10000                     " Store lots of :cmdline history
set ignorecase                        " Ignore case when searching...
set smartcase                         " ...unless we type a capital
" set iskeyword+=_,$,@,%,-

set nowritebackup
set nobackup
set noswapfile
set undofile
set backupdir-=.
set directory-=.                      " plz stop leaving swp files errywhere
set undodir-=.
set nopaste
set nostartofline                     " scroll w/ switching to sol
set nocindent
set autoindent
set smartindent
set smarttab
set softtabstop=4
set tabstop=4
set shiftwidth=4
set timeoutlen=1000 ttimeoutlen=0
set wildignore+=*.gem
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*DS_Store*
set wildignore+=*sass-cache*
set wildignore+=*vim/backups*
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=vendor/cache/**
set wildignore+=vendor/rails/**
set wildignore=*.o,*.obj,*~           "stuff to ignore when tab completing
set nowildignorecase
set wildmenu                          "enable ctrl-n and ctrl-p to scroll thru matches
set wildmode=list:longest            " shows a list
" set helpheight=50
" set wildmode=longest:full,full
" setglobal fileencoding=utf-8          " The encoding written to file.
" set fileformat=unix                     " attempt to always use <NL>
" set fileformats=unix

set nospell
let g:ft_man_folding_enable=1
" # }}}
