scriptencoding utf-8

" NOTE: :help <prefix> will bring you to a list of buildins starting w prefix
"       also: :h insert-index | :h normal-index | :h visual-index h: objects

let g:mapleader = '\'
let g:maplocalleader = '\'

"  F keys (level 0) {{{1
"  Ergo comfort:    80% (bit of a reach)
"  Ergo speed:      100% (single keystroke)
"  Available slots: ~12 (use sparingly)
nnoremap <F1> :vertical resize +5<cr>
nnoremap <F2> :vertical resize -5<cr>


noremap! <F2> <C-R>"

noremap  <F3> "zy
noremap  <F4> "zp
noremap! <F4> <C-R>z

" # }}}

"  Ctrl + [A-Z] (Level 1) {{{1
"  Ergo comfort:    100% (never leaves home)
"  Ergo speed:      90% (single+mod keystroke)
"  Available slots: ~50 (use sparingly)
" nmap <C-o>   <Plug>EnhancedJumpsLocalOlder zz
" nmap <C-i>   <Plug>EnhancedJumpsLocalNewer zz
" <C-S-o>
" nmap <F17>   <Plug>EnhancedJumpsRemoteOlder
" <C-S-i>
" nmap <F16>   <Plug>EnhancedJumpsRemoteNewer
"nmap <C-x>   :bd<CR>

" nmap <c-h> :exe 'normal ' . (virtcol('$')/2) . '|'





	" noremap <MiddleMouse> <LeftMouse><MiddleMouse>

	" noremap <LeftRelease> <LeftRelease>y


map  <C-h>  <Plug>(easymotion-bl)
map  <C-l>  <Plug>(easymotion-wl)

" map <RightMouse> "+P
" fold open
" noremap <2-LeftMouse> zA
noremap <RightMouse> "0p

map  <C-j> <Plug>(easymotion-W)
map  <C-k> <Plug>(easymotion-sol-k)

" if has('macunix')
"     map  <Down> <Plug>(easymotion-sol-j)
"     map  <Up>   <Plug>(easymotion-sol-k)
" else
"     map  <C-j> <Plug>(easymotion-sol-j)
"     map  <C-k> <Plug>(easymotion-sol-k)
" endif


noremap <C-u> 2<C-u>
noremap <C-d> 2<C-d>

nnoremap <S-Insert> "+p
inoremap <S-Insert> <C-R>+

vnoremap s :s//cg<Left><left><left>

nnoremap ( [(
nnoremap ) ])
" <C-9>
nnoremap <F18>  ?{<CR>:nohlsearch<CR>
" <C-0>
nnoremap <F19>  /{<CR>:nohlsearch<CR>
" <C-S-9>
nnoremap <F20>  ?{<CR>:nohlsearch<CR>
" <C-S-0>
nnoremap <F21>  /{<CR>:nohlsearch<CR>

" easy macro usage
vnoremap <C-q>     :<C-U>'<,'>g/./ norm @q<CR>
nnoremap <C-q>     @q

nnoremap <silent> #         <C-^>
nnoremap <silent> <S-space> i<Space><Esc>
nnoremap <silent> <Esc>     :<C-u>:nohlsearch<CR><Esc>
" vnoremap <silent> <Space>   I<Space><Esc>gv
nnoremap <silent> <CR>      za

autocmd FileType qf unmap <CR>
" noremap  <silent> H  ^
" noremap  <silent> L  $
map  H  <Plug>(easymotion-bl)
map  L  <Plug>(easymotion-wl)

nnoremap <silent> M  :normal <C-R>=(virtcol('$')/2)<CR>\|<CR>

nmap     <silent> Y  yiW
nmap     <silent> K  ciW
" nmap     <silent> Q  cib
" nmap     <silent> ^  viW
nmap     <silent> S  :w<CR>
nmap     <silent> X  :bd<CR>
" nnoremap <silent><expr> Q winnr('$') != 1 ? ':<C-u>close<CR>' : ":echo 'no sir i wont'<CR>"
nnoremap <silent> Q :Bclose<CR>

nnoremap <silent> <C-w><C-v> :<C-u>vsplit<CR>:wincmd w<CR>
" nnoremap <silent> <leader>wo  :<C-u>only<CR>
" nnoremap <silent> <leader>ww      :wincmd w<CR>

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
nnoremap <expr> gV    "`[".getregtype(v:register)[0]."`]"
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

" <M-y>  yank inner word
nnoremap <M-y> yiW
nnoremap <M-Y> yiw

" alt-p align paste (normal)
nnoremap <M-p> p'[=']']o<Esc>
nnoremap <M-P> P'[=']']o<Esc>

" alt-p regular paste (insert)
inoremap <M-p> <C-R>"<Esc>
" alt-v regular paste (insert, normal, visual)
inoremap <M-v> <C-R>"<Esc>
noremap <M-v> p
noremap <M-V> P

" <M-a>/<M-x> inc/dec number
nnoremap <silent> <M-a> :<C-u>call AddSubtract("\<C-a>", '')<CR>
nnoremap <silent> <M-A> :<C-u>call AddSubtract("\<C-a>", 'b')<CR>
nnoremap <silent> <M-x> :<C-u>call AddSubtract("\<C-x>", '')<CR>
nnoremap <silent> <M-X> :<C-u>call AddSubtract("\<C-x>", 'b')<CR>
" nnoremap <C-x>d :r!date +'\%F \%T'<CR>
noremap <C-x>t :SGTimestamp<CR>
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

" clipboard delete
noremap  <silent><leader>d       "+d

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

" clipboard paste
" noremap  <silent><leader>p       o<Esc>"+p'[=']']o<Esc>
nnoremap  <silent><leader>p       "+p
nnoremap  <silent><leader>P       "+P
noremap  <silent>,p       "0p

nnoremap  <leader>r      :registers<CR>

nnoremap <silent><Leader>tq :ThesaurusQueryReplaceCurrentWord<CR>


nnoremap <silent><Leader>q :wqa<CR>

nnoremap <silent><Leader>ww :!google-chrome-stable %<CR>

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

nnoremap tt  :tabedit %<CR>
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

" nnoremap <C-t>l  :tabnext<CR>
" nnoremap <C-t>h  :tabprev<CR>
" nnoremap <C-t>e  :tabedit<CR>
" nnoremap <C-t>c  :tabclose<CR>
" nnoremap <C-t>q  :echo 'try \<C-t\>c like c for close shithead'<CR>
" nnoremap <C-t>m  :tabm<Space>



" # }}}

"  Terminal  {{{1
tnoremap <Esc> <C-\><C-n>
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


noremap <silent> <Space>y  :<C-u>Denite  -input=^ -sorters='sorter/word' -matchers='matcher/regexp' -mode=insert -highlight-mode-insert=CursorLine register<CR>

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
noremap <silent> <Space>S  :<C-u>Denite  -mode=insert -highlight-mode-insert=CursorLine  unite:neosnippet<CR>
noremap <silent> <Space>s  :<C-u>Startify<CR>
noremap <silent> <Space>t  :<C-u>Denite  -mode=insert -highlight-mode-insert=CursorLine  unite:tab<CR>


noremap <silent> <C-s> :<C-u>Denite  -mode=insert -highlight-mode-insert=CursorLine  unite:neosnippet<CR>
noremap <silent> <C-p> :<C-u>Denite  -mode=insert -highlight-mode-insert=CursorLine source<CR>

nnoremap <silent> ]d :<C-u>Denite -resume -buffer-name='grepit' -select=+1 -immediately<CR>
nnoremap <silent> [d :<C-u>Denite -resume -buffer-name='grepit' -select=-1 -immediately<CR>


nnoremap <silent> ]B :<C-u>Denite -resume -buffer-name='mru' file_mru -select=+1 -immediately <CR>
nnoremap <silent> [B :<C-u>Denite -resume -buffer-name='mru' file_mru -select=-1 -immediately <CR>

" nnoremap <silent> <Space>v   :<C-u>VimFilerBufferDir -buffer-name=vimf  -split -force-quit<CR>
" nnoremap <silent> <Space>v   :<C-u>VimFilerBufferDir -buffer-name=vimf  -split -force-quit<CR>
nnoremap <silent> <Space>v :Defx `expand('%:p:h')`-auto-cd -toggle -split=vertical -winwidth=50 -direction=topleft<CR>
nnoremap <silent> <Space>V :Defx -auto-cd `expand('%:p:h')`<CR>




nnoremap <silent> <Space>* :<C-u>DeniteCursorWord  -mode=insert -highlight-mode-insert=CursorLine
            \ `finddir('.git', ';') != '' ? 'grep/git' : 'grep'`<CR>
" # }}}

"  Completion  {{{1
inoremap <silent><expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr><TAB>    pumvisible() ? "\<C-n>" : <SID>check_back_space() ?
            \ "\<TAB>" : deoplete#manual_complete()

function! s:check_back_space() abort
  let l:col = col('.') - 1
  return !l:col || getline('.')[l:col - 1]  =~# '\s'
endfunction



" <C-h>, <BS>: close popup and delete backword char.
inoremap <silent><expr><C-h> deoplete#smart_close_popup()."\<C-h>"
inoremap <silent><expr><BS>  deoplete#smart_close_popup()."\<C-h>"

inoremap <silent><expr><C-g>       deoplete#refresh()
inoremap <silent><expr><C-l>       deoplete#complete_common_string()

"imap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"function! s:my_cr_function() abort
""  return deoplete#cancel_popup() . "\<CR>"
"   if  pumvisible()
"       "return deoplete#close_popup()."\<C-y>"
"       return deoplete#close_popup()
"   else
"       return "\<CR>"
"   endif"
"endfunction
inoremap <silent><expr><CR> pumvisible() ? deoplete#close_popup() : "\<CR>"

" <C-j>, <C-k>"
 imap <expr><Down>  pumvisible() ? "\<Tab>" : "\<Down>"
 imap <expr><Up>  pumvisible() ? "\<S-Tab>" : "\<Up>"





 inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
 inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

 " <C-h>, <BS>: close popup and delete backword char.
 inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
 inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"

 " <CR>: close popup and save indent.
 inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
 function! s:my_cr_function() abort
   return deoplete#close_popup() . "\<CR>"
 endfunction




 imap <C-s>  <Plug>(neosnippet_expand_or_jump)
 smap <C-s>  <Plug>(neosnippet_expand_or_jump)
 xmap <C-s>  <Plug>(neosnippet_expand_target)
" # }}}

"  Plumbing  {{{1
" TODO I am depending on the OS to remap <C-j>/<C-k> to <Up>/<Down>.
" <C-j>/<C-k> are frequently unable to stop being LF/VF and that sucks.
"
" <S-space> == <F13>
" map <F13> <S-Space>
" map! <F13> <S-Space>
" map ∑ <M-w>
" map! ∑ <M-w>
" map „ <M-W>
" map! „ <M-W>
" map ¥ <M-y>
" map! ¥ <M-y>
" map Á <M-Y>
" map! Á <M-Y>
" map ß <M-s>
" map! ß <M-s>
" map Í <M-S>
" map! Í <M-S>
" map π <M-p>
" map! π <M-p>
" map ∏ <M-P>
" map! ∏ <M-P>
" map ∂ <M-d>
" map! ∂ <M-d>
" map Î <M-D>
" map! Î <M-D>
" map å <M-a>
" map! å <M-a>
" map Å <M-A>
" map! Å <M-A>
" map ≈ <M-x>
" map! ≈ <M-x>
" map ˛ <M-X>
" map! ˛ <M-X>
" map ç <M-c>
" map! ç <M-c>
" map Ç <M-C>
" map! Ç <M-C>
" map! √ <M-v>
" map √ <M-v>
" map! ◊ <M-V>
" map ◊ <M-V>
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

