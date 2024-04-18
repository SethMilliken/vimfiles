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
    if pages#isToc()
        map <buffer> NN <Cmd>call pages#nextDate()<CR>
    else
        set spell
        set spelllang=en,mtg
        set showbreak=
        set cpo-=n
    end
    map  <buffer> <silent> QQ         <Cmd>call pages#tocAppend()<CR>
    imap <buffer> <silent> QQ         <Esc>QQ
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
    map  <buffer> <silent> ;f         <Cmd>call pages#Entry().today().appendTimestamp()<CR>
    imap <buffer> <silent> ;f         <Esc>;f
    nmap <buffer> <silent> <Leader>wb <Cmd>Pages<CR>
    imap <buffer> <silent> <Leader>wb <Esc><Leader>wb
    nmap <buffer> <silent> <Leader>wf <Cmd>call pages#Entry().FinishWriting()<CR>
    imap <buffer> <silent> <Leader>wf <Esc><Leader>wf
    nmap <buffer> <silent> gy         <Cmd>call pages#openDate(v:true)<CR>
    nmap <buffer> <silent> gY         <Cmd>call pages#openDate()<CR>
    " Available bindings: lh

    doau CharacterCount BufRead
endfunction

"}}}
function! pages#readingMappings() " {{{
    set nocursorline nolist
    if pages#isToc()
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
function! pages#bufferToggle(bufname, toggle = v:true) " {{{
  let l:curnr = bufnr("%")
  let l:curname = expand("%:t")
  silent! call WhitespaceBGone()
  if l:curname == a:bufname
    if a:toggle == v:true
      let l:open_win = exists("g:orgnr") ? win_findbuf(bufnr(g:orgnr)) : []
      if !empty(l:open_win)
        call win_gotoid(l:open_win[0])
      else
        echo "No original buffer."
      endif
    endif
  else
    let g:orgnr = l:curnr
    let l:open_win = win_findbuf(bufnr(a:bufname))
    if !empty(l:open_win)
      call win_gotoid(l:open_win[0])
    else
      exec "tabedit " . a:bufname
      tabm -1
    endif
  endif
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
function! pages#tocRegex() " {{{
    return '[0-9]\{4}-[0-9]\{2}-index.txt'
endfunction

"}}}
function! pages#isToc() " {{{
    return bufname("%")->match(pages#tocRegex()) > -1
endfunction

"}}}
function! pages#currentEntryName() " {{{
    return timestamp#text("date") . ".txt"
endfunction

"}}}
function! pages#currentEntryDate() " {{{
    return expand("%:t:r")
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
function! pages#tocAppend() " {{{
    call pages#bufferToggle(pages#tocName(), v:false)
    normal G$
    let l:last = getline("$")
    let l:sep =  (getline(".") =~ "[0-9; ]\s*$") ? "" : ";"
    call setline(line("$"), trim(l:last) .  l:sep . " ")
    startinsert!
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
function! pages#openDate(isAutoHeader = v:false) " {{{
    " first try to find a date under the cursor
    normal wb
    let l:date = getline(".")->matchstr(timestamp#regex(), getcurpos()[2])
    " otherwise try finding the first date in line
    if l:date->match(timestamp#regex()) == -1
        let l:date = getline(".")->matchstr(timestamp#regex())
    endif
    if l:date->match(timestamp#regex()) > -1
        let l:requested = pages#Entry().New(l:date)
    else
        echo "No date found on line matching: " . timestamp#regex()
        return 0
    endif
    " TODO: implement more sophisticated buffer selection and window
    " navigation for this
    " Set jump so that we can come back here
    normal m'
    if !pages#isPagesFile()
        " if only one window in tab, split first
        if tabpagewinnr(tabpagenr(), "$") == 1
            wincmd v
        endif
        wincmd w
    endif
    call l:requested.readHere()
    if a:isAutoHeader
        call l:requested.insertHeader()
    endif
endfunction

"}}}
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
        call pages#nextDate()
    endfunction
endif

"}}}
if !exists("*pages#editPagesEntry")
    function! pages#editPagesEntry(time = localtime()) " {{{
        " handle empty q-args from a command invocation
        let l:time = empty(a:time) ? localtime() : a:time
        call WriteBufferIfWritable()
        let l:requested = pages#Entry().New(l:time)
        let l:filenameDate = pages#Entry().fromFilename()
        if l:filenameDate.isRecent()
            " Handle new entry created after date change
            let l:previous = l:requested.before()
            if !(l:previous.exists())
                let l:requested = l:previous
            endif
        else
            let l:requested = l:filenameDate
        endif
        call l:requested.editHere()
    endfunction
endif

" }}}

" Prototype for Pages Entry " {{{
function! pages#Entry()
    " Define Constants " {{{
    let s:oneDay = 24 * 60 * 60
    let s:dateformat = "%Y-%m-%d"
    let s:timeformat = "%H:%M:%S %Z"
    " }}}
    " Define Entry Prototype " {{{
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

    fun! s:obj.time() dict
        return self["timeField"]
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
        call self.closeUndoBlock()
        silent! call WhitespaceBGone(v:true)
        call append("$", ["", strftime(s:timeformat), ""])
        normal Go
        startinsert
    endfun

    fun! s:obj.closeUndoBlock() dict
        let &g:undolevels = &g:undolevels
    endfun

    fun! s:obj.readHere() dict
        if !self.isActive()
            exec "lcd " . g:pages_dir
            exec "edit " . self.path()
        else
            " TODO: check for alrady existing buffer and switch to it
        endif
    endfun

    fun! s:obj.editHere() dict
        call self.readHere()
        if self.exists()
            " TODO: Check for "Finished typing" annotation and create newly indexed entry if it exists
            call self.appendTimestamp()
        else
            call self.insertHeader()
        endif
        Writing
    endfun

    fun! s:obj.insertHeader() dict
        if getline("1")->match("Started typing") == -1
            call setline(1, [ getline("1") ]->filter('!empty(v:val)') + [ text#annotation("Started typing"), "" , timestamp#text("journal", localtime()) . ", CURRENT_LOCATION"])
            normal G$
        endif
    endfun

    fun! s:obj.before()
        let l:beforeEntryTime = self["timeField"] - s:oneDay
        return s:factory.New(l:beforeEntryTime)
    endfun

    fun! s:obj.after()
        let l:afterEntryTime = self["timeField"] + s:oneDay
        return s:factory.New(l:afterEntryTime)
    endfun

    fun! s:obj.equals(other)
        return self.time() == a:other.time()
    endfun

    fun! s:obj.equalsDate(other)
        return self.date() == a:other.date()
    endfun

    fun! s:obj.isRecent()
        return self.equalsDate(s:factory.today()) || self.equalsDate(s:factory.yesterday())
    endfun
    " }}}
    " Define Prototype Factory " {{{
    let s:factory = {}

    " static functions
    func! s:factory.dateFromCurrentFilename() dict
        return expand("%:t:r")
    endfunc

    func! s:factory.FinishWriting() dict
      call WhitespaceBGone()
      normal G
      call text#insert_trailing_annotation("Finished typing")
      normal zz
      write
    endfunc

    " instance constructors
    func! s:factory.New(time) dict
        let newobj = copy(s:obj)
        call newobj.setTime(a:time)
        return newobj
    endfunc

    func! s:factory.fromFilename() dict
        let l:date = self.dateFromCurrentFilename()
        " if filename is not actually a date, use now
        if match(l:date, timestamp#regex()) == -1
            let l:date = localtime()
        endif
        return self.New(l:date)
    endfunc

    func! s:factory.today() dict
        return self.New(localtime())
    endfunc

    func! s:factory.yesterday() dict
        return self.today().before()
    endfunc
    " }}}
   return s:factory
endfunction
" }}}
