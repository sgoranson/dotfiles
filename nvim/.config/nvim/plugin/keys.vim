scriptencoding utf-8

" NOTE: :help <prefix> will bring you to a list of buildins starting w prefix
"       also: :h insert-index | :h normal-index | :h visual-index h: objects

let g:mapleader = '\'
let g:maplocalleader = '\'


map ' `
nnoremap <silent> <Esc>     :<C-u>:nohlsearch<CR><Esc>

map  <C-h>  <Plug>(easymotion-bl)
map  <C-l>  <Plug>(easymotion-wl)

noremap <RightMouse> "0p

map  <C-j> <Plug>(easymotion-W)
map  <C-k> <Plug>(easymotion-B)

noremap <C-u> 2<C-u>
noremap <C-d> 2<C-d>


vnoremap s :s//cg<Left><left><left>

nnoremap ( [(
nnoremap ) ])
tnoremap <silent> <C-z> <C-\><C-n>:call spg#terminal#()<Enter>
nnoremap <silent> <C-z> :call spg#terminal#()<Enter>
nnoremap <leader><c-z> :stop<CR>

" easy macro usage
vnoremap <C-q>     :<C-U>'<,'>g/./ norm @q<CR>
nnoremap <C-q>     @q

nnoremap <silent> #         <C-^>
nnoremap <silent> <M-Space> i<Space><Esc>
" vnoremap <silent> <Space>   I<Space><Esc>gv
nnoremap <silent> <CR>      za

"nnoremap Q :Bclose<CR>
nnoremap <silent><expr>  Q &ft != 'help' ? ':Bclose<CR>' : ':close<CR>'
nmap vv viW
nmap vq viq


map  H  <Plug>(easymotion-bl)
map  L  <Plug>(easymotion-wl)

nmap F <plug>(easymotion-Fl)
nmap f <plug>(easymotion-fl)

nnoremap <silent> M  :normal <C-R>=(virtcol('$')/2)<CR>\|<CR>

nmap     <silent> Y  yiW
nmap     <silent> K  ciW
" nmap     <silent> Q  cib
" nmap     <silent> ^  viW
nmap     <silent> S  :w<CR>
nnoremap <silent> <C-w><C-v> :<C-u>vsplit<CR>:wincmd w<CR>
nnoremap <silent> <C-w>v :<C-u>vsplit<CR>:wincmd w<CR>
" nnoremap <silent> <leader>wo  :<C-u>only<CR>
" nnoremap <silent> <leader>ww      :wincmd w<CR>
nnoremap <silent> <leader>w      :set wrap!<CR>

inoremap <C-H> <Left>
inoremap <C-L> <Right>
inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-u>

" paste clipboard during insert
" inoremap <silent>  <C-p>  <C-r>+<Esc>'[=']']

" textobjs for folds
onoremap if :<c-u>normal! [zv]z<cr>
onoremap af :<c-u>normal! [zV]z<cr>
vnoremap if :<c-u>normal! ]zv[z<cr>
vnoremap af :<c-u>normal! ]zV[z<cr>

"  just use cgn and .
"
" " change this word, repeatable
" nnoremap    cn *``cgn
" nnoremap    cN *``cgN

"xnoremap s :s//g<Left><Left>
" }}}

"  gX Key (level 2) {{{
"  Ergo comfort:    80%
"  Ergo speed:      90% (g+single keystroke)
"  Available slots: ~10 (use sparingly, careful about builtins)

" align
nmap                    ga <Plug>(EasyAlign)
xmap                    ga <Plug>(EasyAlign)

nmap                    gcc  <Plug>CommentaryLine
map                     gc   <Plug>Commentary

function! VisualStarSearchSet(cmdtype,...) " {{{
    let temp = @"
    normal! gvy
    if !a:0 || a:1 != 'raw'
        let @" = escape(@", a:cmdtype.'\*')
    endif
    let @/ = substitute(@", '\n', '\\n', 'g')
    let @" = temp
endfunction

" replace vim's built-in visual * and # behavior
xnoremap * :<C-u>call VisualStarSearchSet('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call VisualStarSearchSet('?')<CR>?<C-R>=@/<CR><CR>



" last change
nnoremap <silent>       gi   '.

" insert a blank line and paste
"noremap <silent>        gp    o<Esc>p'[=']']o<Esc>

" reselect after paste
nnoremap <expr> gv    "`[".getregtype(v:register)[0]."`]"
nnoremap ,v `[V`]
nnoremap ,[ `[V`]<
nnoremap ,] `[V`]>


nmap <leader>o [<space>]<space>
" }}}

"  Alt Key (level 3) {{{
"  Ergo comfort:    70% (odd reach to alt)
"  Ergo speed:      90% (single+mod keystroke)
"  Available slots: ~50 (use sparingly. also, will likely require OS remap schenanigans)

" alt-s surround
nmap <M-s> ysiW
nmap <M-S> ysiw

" <M-d> welete inner worw
nnoremap <M-d> "zdiW
nnoremap <M-D> "zdiw

" <M-c>  change inner word
nnoremap <M-w> "zciW
nnoremap <M-W> "zciw


" nnoremap <C-x>d :r!date +'\%F \%T'<CR>
noremap <leader>t :SGTimestamp<CR>
" # }}}



"  Brackets  {{{1
"  Ergo comfort:    70%
"  Ergo speed:      90% (bracket + key)
"  Available slots: ~30 (save for things that have pairs, e.g. up/down left/right)

" inserting blank lines
nmap [<space> <Plug>unimpairedBlankUp
nmap ]<space> <Plug>unimpairedBlankDown

" git change hunks
nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk

nnoremap [B :bp<cr>
nnoremap ]B :bn<cr>
nnoremap [b :BuffergatorMruCyclePrev<CR>
nnoremap ]b :BuffergatorMruCycleNext<CR>

" changelist
nnoremap [c g;
nnoremap ]c g,

" put locations
" nnoremap [p '[
" nnoremap ]p ']

" reselect recent paste
nnoremap vp `[v`]

" visual start/end
nnoremap [v '<
nnoremap ]v '>

" errors
nmap ]e <Plug>(ale_next_wrap)
nmap ]e <Plug>(ale_previous_wrap)

" # }}}

"  Leader (level 4) {{{1
"  Ergo comfort:    50% (must leave home for leader. unless space?)
"  Ergo speed:      60% (leader+{1,2} keystrokes)
"  Available slots: effectively unlimited

nnoremap <silent><leader>al  :call SGToggleAle()<CR>

nnoremap <silent><leader>ba  :UniteBookmarkAdd<CR><CR>

" cd current dir of buffer
nnoremap <silent><leader>cd  :cd %:p:h<bar>:pwd<CR>
" cd root of git project
nnoremap <silent><leader>cg  :Gcd<CR>

nnoremap <silent><leader>cl  :set cursorline!<CR>

noremap  <silent><leader>d       "_d

nnoremap <silent><leader>ed  :e <C-R>=expand('%:h').'/'<cr>

" hi groups (from sjl)
nnoremap <silent><leader>hl  :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" remember gitgutter hunks!
" nmap ghp <Plug>GitGutterPreviewHunk
" nmap ghs <Plug>GitGutterStageHunk
" nmap ghu <Plug>GitGutterUndoHunk

nnoremap <silent><leader>ll  :source $MYVIMRC<CR>

" sessions
" nnoremap <silent><leader>sel  :source ~/.cache/vimses/*<CR>
" nnoremap <silent><leader>ses  :wa<Bar>exe "mksession! ~/.cache/vimses/"<CR>
nnoremap <silent><leader>ses  :OpenSession<Space>

noremap  <leader>m :exec &mouse!=""? "set mouse=" : "set mouse=nv"<CR>
noremap  <silent><leader>ss      :exe ':split ' . g:scratch  <CR>:setlocal nobuflisted<CR>


" snip dat azz ('comm' for folds)
imap <silent><leader>sn  <Plug>(neosnippet_expand_or_jump)
smap <silent><leader>sn  <Plug>(neosnippet_expand_or_jump)
xmap <silent><leader>sn <Plug>(neosnippet_expand_target)


function! Paste(regname, pasteType, pastecmd)
    let reg_type = getregtype(a:regname)
    call setreg(a:regname, getreg(a:regname), a:pasteType)
    exe 'normal "'.a:regname . a:pastecmd
    call setreg(a:regname, getreg(a:regname), reg_type)
endfunction

nmap <Leader>lP :call Paste(v:register, "l", "P")<CR>
nmap <Leader>lp :call Paste(v:register, "l", "p")<CR>
nmap <Leader>cP :call Paste(v:register, "v", "P")<CR>
nmap <Leader>cp :call Paste(v:register, "v", "p")<CR>

imap <C-x>lp <C-o>:call Paste(v:register, "l", "P")<CR>
imap <C-x>lP <C-o>:call Paste(v:register, "l", "p")<CR>
imap <C-x>cp <C-o>:call Paste(v:register, "v", "P")<CR>
imap <C-x>cP <C-o>:call Paste(v:register, "v", "p")<CR>
" clipboard yank
noremap  <silent><leader>y       "+y
noremap Y "+
noremap! Y "+

" clipboard paste
" noremap  <silent><leader>p       o<Esc>"+p'[=']']o<Esc>
nmap  <silent><leader>p       "+]p
nmap  <silent><leader>P       "+]P
" alt-p regular paste (insert)
inoremap <M-p> <C-R><C-O>"

inoremap <M-=> <C-R><C-O>+

cnoremap <M-p> <C-R><C-O>"
nnoremap <M-=> "+p
nnoremap <M-+> "+P

noremap  <silent>,p       "0p 
inoremap <M-y> <C-o>:Denite neoyank -default-action=yank<CR> 

nnoremap <leader>u :UndotreeToggle<CR>



"
nnoremap <silent><Leader>ww :!google-chrome-stable %<CR>
nnoremap <silent><Leader>q :quitall!<CR>

" toggle all/none folds
nnoremap <silent><expr><leader>z  &foldlevel > 0 ? ':norm zMzz<CR>' : ':norm zRzz<CR>'

if &diff
    unmap [c
    unmap ]c
    map <leader>L :diffget LOCAL<CR>
    map <leader>B :diffget BASE<CR>
    map <leader>R :diffget REMOTE<CR>
endif


" # }}}

"  Tabs  {{{1
nnoremap [t :tabprev<CR>
nnoremap ]t :tabnext<CR>

nnoremap tc  :tabclose<CR>
nnoremap tq  :tabclose<CR>

" Alternatively use
nnoremap tl :tabnext<CR>
nnoremap th :tabprev<CR>
nnoremap tn :tabnew<CR>

nnoremap tm  :tabm<Space>
nnoremap tj  :-tabm<CR>
nnoremap tk  :+tabm<CR>


nnoremap <C-t>l :tabnext<CR>
nnoremap <C-t>h :tabprev<CR>
nnoremap <C-t>q  :tabclose<CR>
nnoremap <C-t>c  :tabclose<CR>
nnoremap <C-t>n  :tabnew<CR>
nnoremap <C-t>e  :tabedit %<CR>
tnoremap <C-t>l  <C-\><C-n>:tabnext<CR>
tnoremap <C-t>h  <C-\><C-n>:tabprev<CR>
tnoremap <C-t>q  <C-\><C-n>:tabclose<CR>
tnoremap <C-t>c  <C-\><C-n>:tabclose<CR>
tnoremap <C-t>n  <C-\><C-n>:tabnew<CR>
tnoremap <C-t>e  <C-\><C-n>:tabedit %<CR>

" nnoremap <C-t>l  :tabnext<CR>
" nnoremap <C-t>h  :tabprev<CR>
" nnoremap <C-t>e  :tabedit<CR>
" nnoremap <C-t>c  :tabclose<CR>
" nnoremap <C-t>q  :echo 'try \<C-t\>c like c for close shithead'<CR>
" nnoremap <C-t>m  :tabm<Space>



" # }}}

"  Terminal  {{{1
tnoremap <Esc> <C-\><C-n>
tnoremap <M-[> <C-\><C-n>
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
" # }}}

"  Ex Mode  {{{1
if ! has('win32')
    cmap <C-H> <Left>
endif

cmap <C-A> <Home>
cmap <C-E> <End>
cmap <C-J> <S-Left>
cmap <C-K> <S-Right>
cmap <C-L> <Right>
cmap <C-p> <Up>
cmap <C-n> <Down>
cnoremap <C-f> <C-n>
cnoremap <C-b> <C-p>
" # }}}

"  Denite  {{{1


  nnoremap <silent> <space>/      :<C-u>Denite -buffer-name=search -auto-highlight line<CR>
  nnoremap <silent> <space>*           :<C-u>DeniteCursorWord -buffer-name=search -auto-highlight -mode=normal line<CR>
  nnoremap <silent> ;;          :<C-u>Denite command_history<CR>

  nnoremap <silent> ;r          :<C-u>Denite -buffer-name=register neoyank<CR>
  xnoremap <silent> ;r          :<C-u>Denite -default-action=replace -buffer-name=register neoyank<CR>

noremap <silent> <C-p>  :<C-u>Denite  -mode=insert -highlight-mode-insert=CursorLine buffer<CR>



noremap <silent> <Space>/  :<C-u>Denite  -mode=insert -highlight-mode-insert=CursorLine line<CR>
noremap <silent> <Space>a  :<C-u>Denite  -mode=insert -highlight-mode-insert=CursorLine tag:include<CR>
noremap <silent> <Space>b  :<C-u>Denite  -mode=insert -highlight-mode-insert=CursorLine buffer<CR>
noremap <silent> <Space>B  :<C-u>Denite  -mode=insert -highlight-mode-insert=CursorLine unite:bookmark<CR>
noremap <silent> <Space>c  :<C-u>Denite  -mode=insert -highlight-mode-insert=CursorLine  change<CR>
" noremap <silent> <Space>Co  :<C-u>Denite  -mode=insert -highlight-mode-insert=CursorLine  colorscheme<CR>
noremap <silent> <Space>C  :<C-u>Denite  -mode=insert -highlight-mode-insert=CursorLine  command_history<CR>
noremap <silent> <Space>d :<C-u>Denite  -mode=insert -highlight-mode-insert=CursorLine  directory_mru<CR>
noremap <silent> <Space>e :<C-u>Denite -buffer-name='mru' -mode=insert -highlight-mode-insert=CursorLine file_mru<CR>

nnoremap <silent> <Space>f :<C-u>Denite  -mode=insert -highlight-mode-insert=CursorLine
            \ `finddir('.git', ';') != '' ? 'file_rec/git' : 'file_rec'`<CR>

nnoremap <silent> <Space>gr :<C-u>Denite  -mode=normal -highlight-mode-insert=CursorLine -buffer-name='grepit' -vertical-preview -resume<CR>
nnoremap <silent> <Space>gp :<C-u>Denite  -mode=normal  -highlight-mode-normal=CursorLine  -post-action=open
            \ -buffer-name='grepit' -no-empty
            \ `finddir('.git', ';') != '' ? 'grep/git' : 'grep'`<CR>

noremap <silent> <Space>h  :<C-u>Denite  -mode=insert -highlight-mode-insert=CursorLine -smartcase help<CR>
noremap <silent> <Space>j  :<C-u>Denite  -mode=insert -highlight-mode-insert=CursorLine jump<CR>
nnoremap <silent> <Space>M  :<C-u>Denite -mode=insert -highlight-mode-insert=CursorLine unite:mapping<CR>
noremap <silent> <Space>m  :<C-u>Denite  -mode=insert -highlight-mode-insert=CursorLine  mark<CR>
noremap <silent> <Space>o  :<C-u>Denite  -mode=insert -highlight-mode-insert=CursorLine outline<CR>
noremap <silent> <Space>r  :<C-u>Denite  -mode=insert -highlight-mode-insert=CursorLine file_mru/git<CR>
noremap <silent> <Space>t  :<C-u>Denite  -mode=insert -highlight-mode-insert=CursorLine  unite:tab<CR>


nnoremap <silent> ]d :<C-u>Denite -resume -buffer-name='grepit' -select=+1 -immediately<CR>
nnoremap <silent> [d :<C-u>Denite -resume -buffer-name='grepit' -select=-1 -immediately<CR>

nnoremap <silent> <Space>v :Defx `expand('%:p:h')`-auto-cd -toggle -split=vertical -winwidth=50 -direction=topleft<CR>
nnoremap <silent> <Space>V :Defx -auto-cd `expand('%:p:h')`<CR>




nnoremap <silent> <Space>* :<C-u>DeniteCursorWord  -mode=insert -highlight-mode-insert=CursorLine
            \ `finddir('.git', ';') != '' ? 'grep/git' : 'grep'`<CR>

noremap <silent> <Space>y  :<C-u>Denite  -input=^ -sorters='sorter/word' -matchers='matcher/regexp' -mode=insert -default-action=yank -highlight-mode-insert=CursorLine neoyank<CR>


" # }}}

"  Completion  {{{1






" # }}}


"  Ambient Tweaks  {{{1
" noremap <ScrollWheelUp> <C-U>
" noremap <ScrollWheelDown> <C-D>

nnoremap <S-ScrollWheelUp> :vertical resize +5<cr>
nnoremap <S-ScrollWheelDown> :vertical resize -5<cr>

" Smart <C-f>, <C-b>.
noremap <expr> <C-f> max([winheight(0) - 2, 1]) . "\<C-d>" . (line('w$') >= line('$') ? "L" : "M")
noremap <expr> <C-b> max([winheight(0) - 2, 1]) . "\<C-u>" . (line('w0') <= 1 ? "H" : "M")
" map <C-o> <C-o>zz
" map <C-i> <C-i>zz

nnoremap ZZ  <Nop>

"noremap      x  "_x
vnoremap     y  ygv<Esc>
vnoremap     <  <gv
vnoremap     >  >gv


nnoremap zO zCzO

" # }}}

