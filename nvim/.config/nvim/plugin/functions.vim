" ########### autocmds ########### {{{

"    " autocmd InsertEnter * highlight  CursorLine  guibg=Black
"    " autocmd InsertLeave * highlight  CursorLine guibg=#2c2421


"    "autocmd TextYankPost * echom 'spg: ' . join(v:event.regcontents, nr2char(0))
"    " autocmd TextYankPost * echom 'spg: ' . getreg('"')
"    " kill tabs
"    " let s:blacklist = ['make', 'neosnippet', 'quickfix', 'minimap', 'unite', 'denite']

"    let s:blacklisttrail = ['make', 'neosnippet', 'quickfix', 'unite', 'minimap', 'denite', 'fzf']
"    autocmd BufWinLeave *
"                \   if expand('%') != '' && &buftype !~ 'nofile' && index(s:blacklisttrail, &ft) < 0
"                \|      mkview 1
"                \|  endif
"    autocmd BufWinEnter *
"                \   if expand('%') != '' && &buftype !~ 'nofile' && index(s:blacklisttrail, &ft) < 0
"                \|      silent! loadview 1
"                \|  endif

"    " kill trailing whitespace
"    autocmd BufWritePre * if index(s:blacklisttrail, &ft) < 0 | call StripTrailingWhite() | endif

"    autocmd WinEnter * if index(s:blacklisttrail, &ft) < 0 | setlocal cursorline!  | endif
"    autocmd WinLeave * if index(s:blacklisttrail, &ft) < 0 | setlocal cursorline!  | endif

"    " disable comment continuations,
"    autocmd BufNewFile,BufRead * setlocal formatoptions-=cro
"augroup END

"" function! s:fasd_update() abort
""     " if empty(&buftype) || &filetype ==# 'dirvish'
""     "   call jobstart(['fasd', '-A', expand('%:p')])
""     " endif
""     if expand('%') != '' && &buftype !~ 'nofile'
""         call jobstart(['fasd', '-A', expand('%:p:h')])
""     endif
"" endfunction

"" augroup fasd
""   autocmd!
""   autocmd BufWinEnter * call s:fasd_update()
"" augroup END



" various syntax/highlight tweaks
" let g:loaded_matchparen=1
" let g:parenmatch=1
" let g:ale_enabled=1

"let g:sh_noisk=1  " tinker with iskeyword
""let g:sh_fold_enabled=5
"let g:xml_syntax_folding=1
"let g:markdown_folding = 1

" augroup spgFiletypes
"     autocmd!

"     " Enable omni completion.
"     autocmd FileType dosbatch setlocal commentstring=::\ %s
"     autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"     autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"     autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"     autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
"     autocmd FileType html,eruby,rb,css,js,xml runtime! macros/matchit.vim


"     autocmd FileType xml setlocal foldmethod=syntax foldlevelstart=99
"     autocmd FileType html setlocal foldmethod=syntax foldlevelstart=99

"     autocmd BufNewFile,BufRead *.json set ft=javascript

"     " persist folds
"     " autocmd BufWinLeave *? mkview 1
"     " autocmd BufWinEnter *? silent! loadview 1
" augroup END
" # }}}

" ########### functions ########### {{{



" http://vim.wikia.com/wiki/Increasing_or_decreasing_numbers
function! AddSubtract(char, back)
  let l:pattern = &nrformats =~? 'alpha' ? '[[:alpha:][:digit:]]' : '[[:digit:]]'
  call search(l:pattern, 'cw' . a:back)
  execute 'normal! ' . v:count1 . a:char
  silent! call repeat#set(":\<C-u>call AddSubtract('" .a:char. "', '" .a:back. "')\<CR>")
endfunction

function! SGProfileStart() abort
    profile start $XDG_CACHE_HOME/profile-nvim.log
    profile func *
    profile file *
endfunction

function! SGProfileStop() abort
    profile stop
endfunction

function! StripTrailingWhite()
    let l:winview = winsaveview()
    silent! %s/\s\+$//
    call winrestview(l:winview)
endfunction

" use Ag/Rg for grep if available
if executable('rg')
    set gp=rg\ --vimgrep\ --no-heading gfm=%f:%l:%c:%m,%f:%l%m,%f\ \ %l%m
endif

" http://vim.wikia.com/wiki/Quickly_adding_and_deleting_empty_lines
function! DelEmptyLineBelow()
    if line(".") == line("$")
        return
    end
    let l:line = getline(line(".") + 1)
    if l:line =~ '^\s*$'
        let l:colsave = col(".")
        .+1d
        ''
        call cursor(line("."), l:colsave)
    end
endfunction

function! DelEmptyLineAbove()
    if line(".") == 1
        return
    end
    let l:line = getline(line(".") - 1)
    if l:line =~ '^\s*$'
        let l:colsave = col(".")
        .-1d
        silent normal! <C-y>
        call cursor(line("."), l:colsave)
    end
endfunction

function! s:getchar() abort
    redraw | echo 'Press any key: '
    let l:c = getchar()
    while l:c ==# "\<CursorHold>"
        redraw | echo 'Press any key: '
        let l:c = getchar()
    endwhile
    redraw | echomsg printf('Raw: "%s" | Char: "%s"', l:c, nr2char(l:c))
endfunction

function! s:SGExBuf(cmd)
    redir => message
    silent execute a:cmd
    redir END
    if empty(message)
        echoerr "no output"
    else
        enew
        silent put=message
    endif
endfunction

function! s:SGExGet(...)
    redir @"
    silent execute join(a:000)
    redir END
endfunction

function! s:SGFormatPosh()
    " let l:tmpx = g:cache_dir . g:Fsep . 'vimex.tmp'
    " echo "SPG: " l:tmpx
    " execute "mkexrc" l:tmpx
    !powershell -noprofile -command Edit-DTWBeautifyScript -indenttext '`t' -sourcepath %:p

    e %
    let s:linen = 1
    for s:linetxt in getline(1,'$')
        call setline(s:linen, substitute(s:linetxt, '\t', '    ', 'g'))
        let s:linen = s:linen + 1
    endfor
endfunction

function! s:SGSubWithCount()
    :%s///n
    let okx = confirm('ok?', "&ok\n&no",1)
    if okx == 1
        " :%s///
        exec "normal \<F6>"
    endif
endfunction

function! SGHighlightToHTML(outfile)
    let result = []
    for red in range(0, 255, 16)
        for green in range(0, 255, 16)
            for blue in range(0, 255, 16)
                let kw = printf('%-13s', printf('c_%d_%d_%d', red, green, blue))
                let fg = printf('#%02x%02x%02x', red, green, blue)
                let bg = '#000000'
                let h = printf('hi %s guibg=%s guifg=%s', kw, fg, bg)
                let s = printf('syn keyword %s %s', kw, kw)
                call add(result, printf('%s | %s', h, s))
            endfor
        endfor
    endfor
    call writefile(result, a:outfile)
    execute 'edit '.a:outfile
    source %
    echohl WarningMsg | echo "run :TOhtml" | echohl None
endfunction

" # }}}

" modify selected text using combining diacritics
command! -range -nargs=0 Overline        call s:CombineSelection(<line1>, <line2>, '0305')
command! -range -nargs=0 Underline       call s:CombineSelection(<line1>, <line2>, '0332')
command! -range -nargs=0 DoubleUnderline call s:CombineSelection(<line1>, <line2>, '0333')
command! -range -nargs=0 Strikethrough   call s:CombineSelection(<line1>, <line2>, '0336')

function! s:CombineSelection(line1, line2, cp)
  execute 'let char = "\u'.a:cp.'"'
  execute a:line1.','.a:line2.'s/\%V[^[:cntrl:]]/&'.char.'/ge'
endfunction

function! s:sgtimestamp()
    let @h = systemlist("date +'%F %T'")[0] . ' '
    norm! "hP
endfunction

command! SGTimestamp call s:sgtimestamp()

" ########### commands ########### {{{
command! -complete=dir -nargs=* Ctags :!ctags -R --totals --extra=+q --fields=+iaS --c++-kinds=+p <args>
command! -nargs=+ -complete=command SGExBuf call s:SGExBuf(<q-args>)
command! -nargs=+ -complete=command SGExGet call s:SGExGet(<q-args>)
" command! -nargs=+ -complete=file -bar Rg sil! gr! <args>|cw|redr!|let @/="<args>"|set hls
command! -nargs=1 -complete=command SGSubWithCount call s:SGSubWithCount()
command! SGBufCloseNotMe BufOnly
command! SGFormatPosh call <SID>SGFormatPosh()
command! SGProfileStart call SGProfileStart()
command! SGProfileEnd call SGProfileStop()
command! SGMessagesClear for n in range(200) | echom "" | endfor
command! SGGetChar call s:getchar()
command! SGUndoToggle GundoToggle
command! SGHlExport ExportColors "tmp.tmp"
command! SGHlHTML call SGHighlightToHTML('gvim-color-test.tmp')


" # }}}
