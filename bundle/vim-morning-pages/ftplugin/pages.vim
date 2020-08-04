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
function! PagesHeader() " {{{
    call StartWriting()
    call setline(line("$"), ["" ,timestamp#text("journal") . ", CURRENT_LOCATION"])
    normal G$
endfunction

" }}}
function! pages#root() " {{{
    return g:pages_dir
endfunction

"}}}
function! pages#tocname() " {{{
    return strftime("%Y-%m-index.txt")
endfunction

"}}}
function! pages#editCurrentIndex() " {{{
    let l:current = g:pages_dir . pages#tocname()
    " Switch to tab if one is opened with this file being edited
    " Otherwise eidt it here
    exec "edit " . l:current
    Writing
endfunction

"}}}
command! -nargs=? Pages :call pages#editPagesEntry(<args>)
if !exists("*pages#editPagesEntry")
    function! pages#editPagesEntry(time = localtime()) " {{{
        let requested = pages#factory().New(a:time)
        let previous = requested.before()
        if previous.exists()
            "echo "edit requested: " . requested.date()
            call requested.editHere()
        else
            "echo "edit previous: " . previous.date()
            call previous.editHere()
        endif
    endfunction
endif

" }}}
" Prototype for Pages Entry " {{{
function! pages#factory()
    let s:obj = {}
    let s:obj["timeField"] = "time unset"
    let s:obj["dateField"] = "date unset"

    let s:oneDay = 24 * 60 * 60
    let s:dateformat = "%Y-%m-%d"
    let s:timeformat = "%H:%M:%S %Z"

    fun! s:obj.setTime(time) dict
        let self["timeField"] = a:time
        let self["dateField"] = strftime(s:dateformat,  a:time)
        return self
    endfun

    fun! s:obj.date() dict
        return self["dateField"]
    endfun

    fun! s:obj.filename() dict
        return self.date() . ".txt"
    endfun

    fun! s:obj.path() dict
        return g:pages_dir . self.filename()
    endfun

    fun! s:obj.exists() dict
        return getfsize(expand(self.path())) > 1
    endfun

    fun! s:obj.isActive() dict
        return expand('%') == self.filename()
    endfun

    fun! s:obj.editHere() dict
        if !self.isActive()
            exec "lcd " . g:pages_dir
            exec "edit " . self.path()
        else
            " TODO: check for alrady existing buffer and swtich to it
        endif
        if self.exists()
            " Check for "Finished typing" annotation and create newly indexed entry if it exists
            call append("$", ["", strftime(s:timeformat), ""])
            normal Go
            startinsert
        else
            call PagesHeader()
            " write
        endif
        Writing
    endfun

    " constructor
    fun! s:obj.New(time = localtime()) dict
        let newobj = copy(self)
        call newobj.setTime(a:time)
        return newobj
    endfun

    func! s:obj.before()
        let l:beforeEntryTime = self["timeField"] - s:oneDay
        return pages#factory().New(l:beforeEntryTime)
    endfunc

    func! s:obj.after()
        let l:afterEntryTime = self["timeField"] + s:oneDay
        return pages#factory().New(l:afterEntryTime)
    endfunc

    fun! s:obj.me() dict
       return self
   endfun

    "return s:obj.New()
    return s:obj.me()
endfunction
" }}}
