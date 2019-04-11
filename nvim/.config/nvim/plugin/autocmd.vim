augroup spgwtf

    autocmd!

    autocmd DirChanged,VimEnter * let &titlestring = pathshorten(substitute(getcwd(), $HOME, '~', ''))

    autocmd BufReadPost *? call Jumplast()


    autocmd BufWritePre * call SGMkdirP()

    autocmd BufEnter * :syntax sync fromstart

    autocmd ColorScheme * hi! Normal guibg=NONE ctermbg=NONE

    " auto detect filechanges
    autocmd FileChangedShell * echohl WarningMsg | echo "file changed outside vim!" | echohl None


    autocmd InsertLeave,TextChanged * nested call s:save_buffer()
    autocmd WinEnter,FocusGained,BufEnter,CursorHold * silent! checktime


    " Update filetype.
    autocmd MyAutoCmd BufWritePost * nested
                \ if &l:filetype ==# '' || exists('b:ftdetect')
                \ |   unlet! b:ftdetect
                \ |   filetype detect
                \ | endif



    " Disable paste.
    autocmd InsertLeave * if &paste | setlocal nopaste | echo 'nopaste' | endif |
                \ if &l:diff | diffupdate | endif

    " restores the cursor to make xterm et al happy
    " autocmd VimLeave * set guicursor=a:hor50
    " autocmd VimLeave * hi Cursor guifg=#eeeeee guibg=#979AD4
    "
    " autocmd VimEnter * call dein#call_hook('post_source')
    autocmd User CocQuickfixChange :CocList --normal quickfix
    autocmd CursorHold * silent! call CocActionAsync('highlight')
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

    autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif

augroup END

" helper funcions {{{
function! s:save_buffer() abort
    if empty(&buftype) && !empty(bufname(''))
        let l:savemarks = {
                    \ "'[": getpos("'["),
                    \ "']": getpos("']")
                    \ }

        silent! update

        for [l:key, l:value] in items(l:savemarks)
            call setpos(l:key, l:value)
        endfor
    endif
endfunction

function! SGMkdirP()
    let dir = expand('%:p:h')

    if dir =~ '://'
        return
    endif

    if !isdirectory(dir)
        call mkdir(dir, 'p')
        echo 'Created non-existing directory: '.dir
    endif
endfunction

function! Jumplast() abort
    if empty(&buftype) && index(['diff', 'gitcommit'], &filetype, 0, v:true) == -1
        if line("'\"") >= 1 && line("'\"") <= line('$')
            execute 'normal! g`"zz'
        endif
    endif
endfunction
"}}}

