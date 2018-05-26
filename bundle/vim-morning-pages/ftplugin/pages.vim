" Requires text and timestamp plugins
function! IsPagesEntry(name) " {{{
   return a:name =~ '\d\d\d\d-\d\d-\(index\|\d\d\)[[:alpha:]]*.txt'
endfunction

"}}}
augroup MorningPages | au!
   if IsPagesEntry(bufname("%"))
    au BufRead * call WritingMappings()
   end
   au FocusLost * nested call WriteBufferIfWritable()
augroup END

command! Writing :call WritingMappings()
function! WritingMappings() " {{{
    if bufname("%") == TocName()
        set nocursorline nowrap nolist
    else
        set nocursorline wrap nolist spell
        set showbreak=
        set cpo-=n
    end
    map  <buffer> Qq :call PagesToggle()<CR>
    imap <buffer> rq <esc>Qq
    map  <buffer> QQ :call NotesToggle()<CR>
    imap <buffer> QQ <esc>QQ
    map  <buffer> kj :call TocToggle()<CR>
    imap <buffer> kj <esc>kj

    doau CharacterCount BufRead
endfunction

"}}}
function! FinishWriting() " {{{
    call WhitespaceBGone()
    normal G
    call text#insert_trailing_annotation("Finished typing")
    write
endfunction

" }}}
function! StartWriting() " {{{
    call text#insert_leading_annotation("Started typing")
endfunction

" }}}
function! PagesEntry() " {{{
    let l:currentdate = timestamp#text('date')
    let l:entry = g:pages_dir . l:currentdate . ".txt"
    let l:entryexists = filereadable(l:entry)
    exec "lcd " . g:pages_dir
    exec "tabedit " . l:entry
    if l:entryexists
        normal G
        echo "Entry " . l:currentdate . " already exists."
    else
        call PagesHeader()
    endif
    Writing
endfunction

" }}}
function! PagesHeader() " {{{
    call StartWriting()
    call setline(line("$"), ["" ,timestamp#text("journal") . ", CURRENT_LOCATION"])
    normal G$
endfunction

" }}}
function! JournalEntry() " {{{
    let l:currentdate = timestamp#text('date')
    let l:entry = g:pages_dir . l:currentdate . ".txt"
    let l:entryexists = getfsize(expand(l:entry)) > 1
    exec "lcd " . g:pages_dir
    exec "edit " . l:entry
    if l:entryexists
        " Check for "Finished typing" annotation and create newly indexed entry if it exists
        call append("$", ["", timestamp#text('time'), ""])
        normal Go
        startinsert
    else
        call PagesHeader()
    endif
    Writing
endfunction

" }}}
