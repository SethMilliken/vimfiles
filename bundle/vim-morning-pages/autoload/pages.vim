" Requires text and timestamp plugins

command! Writing :call pages#writingMappings()
command! Reading :call pages#readingMappings()
command! UpdateReadingProgress :call pages#updateReadingProgress()
command! -nargs=? Pages :call pages#editPagesEntry(<q-args>)
command! -nargs=? PagesToc :call pages#editToc(<q-args>)

function! pages#isPagesEntry(name) " {{{
   return a:name =~ '\d\d\d\d-\d\d-\(index\|\d\d\)[[:alpha:]]*.txt'
endfunction

"}}}
function! pages#isPagesFile(name = pages#currentFilename()) " {{{
    return match(a:name, timestamp#regex() . '.txt') > -1
endfunction

"}}}
function! pages#rebalance() " {{{
    wincmd =
endfunction

"}}}
function! pages#currentFilename() " {{{
    return fnamemodify(expand("%"), ":p:t")
endfunction

"}}}
function! pages#writingMappings() " {{{
    set nocursorline wrap nolist
    if bufname("%") == pages#tocName()
        map <buffer> NN <Cmd>call pages#nextDate()<CR>
    else
        set spell
        set spelllang=en,mtg
        set showbreak=
        set cpo-=n
    end
    map  <buffer> <silent> ;;         <Cmd>call pages#pagesToggle()<CR>
    imap <buffer> <silent> ;;         <Esc>;;
    map  <buffer> <silent> ;n         <Cmd>call pages#notesToggle()<CR>
    imap <buffer> <silent> ;n         <Esc>;n
    map  <buffer> <silent> ;j         <Cmd>call pages#tocToggle()<CR>
    imap <buffer> <silent> ;j         <Esc>;j
    map  <buffer> <silent> ;h         <Cmd>call pages#topicsToggle()<CR>
    imap <buffer> <silent> ;h         <Esc>;h
    map  <buffer> <silent> ;c         <Cmd>call pages#conversationsToggle()<CR>
    imap <buffer> <silent> ;c         <Esc>;c
    map  <buffer> <silent> ;l         <Cmd>call pages#lastLines()<CR>
    imap <buffer> <silent> ;l         <Esc>;l
    map  <buffer> <silent> ;k         <Cmd>call pages#midlines()<CR>
    imap <buffer> <silent> ;k         <Esc>;k
    map  <buffer> <silent> ;t         <Cmd>call pages#appendTimestamp()<CR>
    imap <buffer> <silent> ;t         <Esc>;t
    nmap <buffer> <silent> <Leader>wb <Cmd>Pages<CR>
    imap <buffer> <silent> <Leader>wb <Esc><Leader>wb
    nmap <buffer> <silent> <Leader>wf <Cmd>call pages#finishWriting()<CR>
    imap <buffer> <silent> <Leader>wf <Esc><Leader>wf
    nmap <buffer> <silent> gt         <Cmd>call pages#openDate()<CR>
    " Available bindings: lh

    doau CharacterCount BufRead
endfunction

"}}}
function! pages#readingMappings() " {{{
    set nocursorline nolist
    if bufname("%") == pages#tocName()
        set nowrap
    else
        set wrap spell
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
    exec 'map! QQ <Cmd>call pages#updateReadingProgress()<CR>'
endfunction

"}}}
function! pages#updateReadingProgress() " {{{
    if exists("g:progress")
        let file_name = pages#currentFilename()
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
    silent! call WhitespaceBGone()
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
    call pages#rebalance()
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
    normal G$
endfunction

"}}}
function! pages#editToc(month) " {{{
    if a:month->matchstr(timestamp#regex()) == -1
        echo "Not a month"
    else
        call pages#bufferToggle(a:month . "-index.txt")
    endif
endfunction

"}}}
function! pages#conversationsToggle() " {{{
    call pages#bufferToggle("conversations.tst")
endfunction

"}}}
function! pages#openDate() " {{{
    " first try to find a date under the cursor
    normal bh
    let l:date = getline(".")->matchstr(timestamp#regex(), getcurpos()[2])
    " otherwise try finding the first date in line
    echo l:date
    if match(l:date, timestamp#regex()) == -1
        let l:date = getline(".")->matchstr(timestamp#regex())
    endif
    if match(l:date, timestamp#regex()) > -1
        let l:requested = pages#factory().New(l:date)
    else
        echo "No date found on line matching: " . timestamp#regex()
        return 0
    endif
    " TODO: implement more sophisticated buffer selection and window
    " navigation for this
    if !pages#isPagesFile()
        " if only one window in tab, split first
        if tabpagewinnr(tabpagenr(), "$") == 1
            wincmd v
        endif
        wincmd w
    endif
    call l:requested.readHere()
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
    call setline(line("$"), ["" , timestamp#text("journal", pages#currentFilename()) . ", CURRENT_LOCATION"])
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
function! pages#appendTimestamp(time = localtime()) " {{{
    call WhitespaceBGone()
    let requested = pages#factory().New(a:time)
    call requested.appendTimestamp()
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
        call WriteBufferIfWritable()
        let requested = pages#factory().New(a:time)
        let l:filenameDate = expand("%:t:r")
        if match(l:filenameDate, timestamp#regex()) > -1
            call requested.setTime(l:filenameDate)
        endif
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

    fun! s:obj.setTime(time = localtime()) dict
        if match(a:time, timestamp#regex()) > -1
            let self["timeField"] = strptime(s:dateformat, a:time)
        else
            let self["timeField"] = a:time
        endif
        let self["dateField"] = strftime(s:dateformat,  self["timeField"])
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

    fun! s:obj.appendTimestamp() dict
        silent! call WhitespaceBGone()
        call append("$", ["", strftime(s:timeformat), ""])
        normal Go
        startinsert
    endfun

    fun! s:obj.readHere() dict
        if !self.isActive()
            exec "lcd " . g:pages_dir
            exec "edit " . self.path()
        else
            " TODO: check for alrady existing buffer and swtich to it
        endif
    endfun

    fun! s:obj.editHere() dict
        call self.readHere()
        if self.exists()
            " TODO: Check for "Finished typing" annotation and create newly indexed entry if it exists
            call self.appendTimestamp()
        else
            call pages#pagesHeader()
            " write
        endif
        Writing
    endfun

    fun! s:obj.before()
        let l:beforeEntryTime = self["timeField"] - s:oneDay
        return s:factory.New(l:beforeEntryTime)
    endfun

    fun! s:obj.after()
        let l:afterEntryTime = self["timeField"] + s:oneDay
        return s:factory.New(l:afterEntryTime)
    endfun


   " Is there any point to a separate dict for the factory itself? Why not
   " just return New()?  This could have additional methods added to it that
   " are only available from the factory instance. Like what, though? How
   " about `New()` itself?  In this case, does it even need to have any of the
   " other methods?  Probably not. So that keeps a nice separation.
   " let s:factory = copy(s:obj)
   let s:factory = {}
    " constructor
    fun! s:factory.New(time) dict
        let newobj = copy(s:obj)
        call newobj.setTime(a:time)
        return newobj
    endfun

   return s:factory
endfunction
" }}}
