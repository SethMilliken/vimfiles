" Requires text and timestamp plugins

command! Writing :call pages#writingMappings()
command! Reading :call pages#readingMappings()
command! UpdateReadingProgress :call pages#updateReadingProgress()
command! -nargs=? Pages :call pages#editPagesEntry(<args>)

function! pages#isPagesEntry(name) " {{{
   return a:name =~ '\d\d\d\d-\d\d-\(index\|\d\d\)[[:alpha:]]*.txt'
endfunction

"}}}
function! pages#isPagesFile(name) " {{{
    return match(a:name, '[0-9]\{4}-[0-9]\{2}-[0-9]\{2}\.txt') > -1
endfunction

"}}}

function! pages#writingMappings() " {{{
    if bufname("%") == pages#tocName()
        set nocursorline wrap nolist
        map <buffer> NN :call pages#nextDate()<CR>
    else
        set nocursorline wrap nolist spell
        set showbreak=
        set cpo-=n
    end
    map  <buffer> <silent> Qq         :call pages#pagesToggle()<CR>
    imap <buffer> <silent> Qq         <Esc>Qq
    map  <buffer> <silent> QQ         :call pages#notesToggle()<CR>
    imap <buffer> <silent> QQ         <Esc>QQ
    map  <buffer> <silent> ;j         :call pages#tocToggle()<CR>
    imap <buffer> <silent> ;j         <Esc>;j
    map  <buffer> <silent> ;h         :call pages#topicsToggle()<CR>
    imap <buffer> <silent> ;h         <Esc>;h
    map  <buffer> <silent> ;l         :call pages#lastLines()<CR>
    imap <buffer> <silent> ;l         <Esc>;l
    map  <buffer> <silent> ;k         :call pages#midlines()<CR>
    imap <buffer> <silent> ;k         <Esc>;k
    nmap <buffer> <silent> <Leader>wb :Pages<CR>
    imap <buffer> <silent> <Leader>wb <Esc><Leader>wb
    nmap <buffer> <silent> <Leader>wf :call pages#finishWriting()<CR>
    imap <buffer> <silent> <Leader>wf <Esc><Leader>wf
    " Available bindings: ;j ;h ;k lh

    doau CharacterCount BufRead
endfunction

"}}}
function! pages#readingMappings() " {{{
    if bufname("%") == pages#tocName()
        set nocursorline nowrap nolist
    else
        set nocursorline wrap nolist spell
    end
    exe "cd " . pages#root()
    if pages#progressFileExists()
        let lines = readfile(g:progress)
        let current_entry = lines[0]
        if strwidth(current_entry) > 0
            exe "edit " . pages#root() . current_entry
            if exists(":NERDTreeToggle") == 2
                NERDTreeToggle
                call search(current_entry)
            end
        end
    else
        echo "No progress file."
    end
    exec 'map! QQ :call pages#updateReadingProgress()<CR>'
endfunction

"}}}
function! pages#updateReadingProgress() " {{{
    if exists("g:progress")
        let file_name = fnamemodify(expand("%"), ":p:t")
        if strwidth(file_name) > 0 && pages#isPagesFile(file_name)
            let lines = [file_name]
            call writefile(lines, g:progress)
            echo "Updated reading progress to: " . file_name
        end
    end
endfunction

"}}}

function! pages#progressFileExists() " {{{
    return filereadable(g:progress)
endfunction

"}}}
function! pages#bufferToggle(bufname) " {{{
    write
    if buflisted(glob(a:bufname))
        call pages#bufferSwitch(a:bufname)
    else
        exec "tabedit " . a:bufname
    end
endfunction

" }}}
function! pages#bufferSwitch(bufname) " {{{
    let l:origswb = &swb
    set swb=usetab
    let l:curnr = bufnr("%")
    let l:curname = expand("%:t")
    if l:curname == a:bufname
        if exists("g:orgnr") && buflisted(g:orgnr)
            exec "sbuffer " . g:orgnr
        else
            echo "No original buffer."
        end
    else
        let g:orgnr = l:curnr
        exec "sbuffer " . bufnr(a:bufname)
    end
    exec "set swb=" . l:origswb
endfunction

" }}}
function! pages#topicsName() " {{{
    return "topics.tst"
endfunction

"}}}
function! pages#tocName() " {{{
    return strftime("%Y-%m-index.txt")
endfunction

"}}}
function! pages#currentEntryName() " {{{
    return timestamp#text("date") . ".txt"
endfunction

"}}}
function! pages#notesToggle() " {{{
    call pages#bufferToggle("notes.txt")
endfunction

"}}}
function! pages#pagesToggle() " {{{
    call pages#bufferToggle(pages#currentEntryName())
endfunction

"}}}
function! pages#topicsToggle() " {{{
    call pages#bufferToggle(pages#topicsName())
endfunction

"}}}
function! pages#tocToggle() " {{{
    call pages#bufferToggle(pages#tocName())
    silent! call WhitespaceBGone()
    normal G$
endfunction

"}}}
function! pages#finishWriting() " {{{
    call WhitespaceBGone()
    normal G
    call text#insert_trailing_annotation("Finished typing")
    normal zz
    write
endfunction

" }}}
function! pages#startWriting() " {{{
    call text#insert_leading_annotation("Started typing")
endfunction

" }}}
function! pages#pagesHeader() " {{{
    call pages#startWriting()
    call setline(line("$"), ["" , timestamp#text("journal") . ", CURRENT_LOCATION"])
    normal G$
endfunction

" }}}
function! pages#root() " {{{
    return g:pages_dir
endfunction

"}}}
function! pages#nextDate() " {{{
    normal G
    let l:extdate = timestamp#dateFactory().extractFirstDateFromLine()
    call setline(line('$'), [ getline('$'), l:extdate.next().date() . " " ])
    normal G$
    startinsert!
endfunction

"}}}
function! pages#lastLines() " {{{
    " TODO: save and restore cursor position and mode as well
    let orig = winnr()
    windo normal Gzt
    exe orig . 'wincmd w'
endfunction

"}}}
function! pages#midlines() " {{{
    " TODO: save and restore cursor position and mode as well
    let orig = winnr()
    windo normal Gzz
    exe orig . 'wincmd w'
endfunction

"}}}


if !exists("*pages#editCurrentIndex")
    function! pages#editCurrentIndex() " {{{
        let l:current = g:pages_dir . pages#tocName()
        " Switch to tab if one is opened with this file being edited
        " Otherwise eidt it here
        exec "edit " . l:current
        Writing
    endfunction
endif

"}}}
if !exists("*pages#editPagesEntry")
    function! pages#editPagesEntry(time = localtime()) " {{{
        let requested = pages#factory().New(a:time)
        let previous = requested.before()
        if previous.exists()
            call requested.editHere()
        else
            call previous.editHere()
        endif
    endfunction
endif

" }}}

" Prototype for Pages Entry " {{{
function! pages#factory()
    let s:oneDay = 24 * 60 * 60
    let s:dateformat = "%Y-%m-%d"
    let s:timeformat = "%H:%M:%S %Z"

    let s:obj = {}
    let s:obj["timeField"] = "time unset"
    let s:obj["dateField"] = "date unset"

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
            silent! call WhitespaceBGone()
            call append("$", ["", strftime(s:timeformat), ""])
            normal Go
            startinsert
        else
            call pages#pagesHeader()
            " write
        endif
        Writing
    endfun

    func! s:obj.before()
        let l:beforeEntryTime = self["timeField"] - s:oneDay
        return s:factory.New(l:beforeEntryTime)
    endfunc

    func! s:obj.after()
        let l:afterEntryTime = self["timeField"] + s:oneDay
        return s:factory.New(l:afterEntryTime)
    endfunc


   " Is there any point to a separate dict for the factory itself? Why not
   " just return New()?  This could have additional methods added to it that
   " are only available from the factory instance. Like what, though? How
   " about `New()` itself?  In this case, does it even need to have any of the
   " other methods?  Probably not. So that keeps a nice separation.
   " let s:factory = copy(s:obj)
   let s:factory = {}
    " constructor
    fun! s:factory.New(time = localtime()) dict
        let newobj = copy(s:obj)
        call newobj.setTime(a:time)
        return newobj
    endfun

   return s:factory
endfunction
" }}}
