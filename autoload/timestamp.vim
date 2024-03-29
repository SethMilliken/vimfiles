" Time Constants "{{{
let s:DAY_SECONDS = 24 * 60 * 60
let s:DATE_FORMAT = {}
let s:DATE_FORMAT["short"] = "%Y-%m-%d"
let s:DATE_FORMAT["long_win"] = "%#x %H:%M:%S"
let s:TIME_FORMAT = "%H:%M:%S %Z"
" let s:DATE_FACTORY = timestamp#dateFactory()

"}}}
" Timestamp Functions
function! timestamp#insert(style, time = localtime()) "{{{
    call text#append(timestamp#text(a:style, a:time) . " ")
endfunction

" }}}
function! timestamp#yesterday() "{{{
    return localtime() - s:DAY_SECONDS
endfunction

" }}}
function! timestamp#text(style, time = localtime()) "{{{
    let l:iswindows = has("win16") || has("win32") || has("win64")
    let l:dateformat = ""
    if l:iswindows
        if a:style == "long"
            let l:dateformat = strftime("%#x %H:%M:%S ", a:time)
        elseif a:style == "short"
            let l:dateformat = strftime("%Y-%m-%d %H:%M:%S ", a:time)
        endif
        let l:dateformat .= substitute(strftime("%#z", a:time), '\C[a-z]\+\($\| \)', '', 'g')
    else
        if a:style == "long"
            let l:dateformat = strftime("%Y %b %d %a %X %Z", a:time)
        elseif a:style == "journal"
            let l:dateformat = strftime("%A, %B %d, %Y %H:%M:%S %Z", a:time)
        elseif a:style == "short"
            let l:dateformat = strftime("%Y-%m-%d %H:%M:%S %Z", a:time)
        elseif a:style == "time"
            let l:dateformat = strftime("%H:%M:%S %Z", a:time)
        endif
    endif
    if a:style == "date"
        let l:dateformat = strftime("%Y-%m-%d", a:time)
    endif
    return l:dateformat
endfunction

" }}}
function! timestamp#autoUpdateToggle() "{{{
    if !exists("g:auto_timestamp_bypass")
        call timestamp#autoUpdateBypass()
        echo "Timestamps: auto add/update DISABLED."
    else
        call timestamp#autoUpdateEnable()
        echo "Timestamps: auto add/update ENABLED."
    end
endfunction

"}}}
function! timestamp#addOrUpdateSolicitingAnnotation() "{{{
    if !exists("g:auto_timestamp_bypass")
        let l:default_prompt = g:timestamp_default_annotation
        let l:matchstring = g:timestamp_matchstring . '\zs\ze\s*\({\zs\(\w\+\s*\)*\ze}\)*$'
        let l:originalannotations = matchstr(getline("."), l:matchstring)
        if len(l:originalannotations) > 0
            let l:default_prompt = l:originalannotations
        end
        let l:annotation = input("Annotation: ", text#strip(l:default_prompt))
        if len(l:annotation) > 0
            call timestamp#addOrUpdate(text#strip(l:annotation), "force")
        else
            if len(l:originalannotations) > 0
                silent! call timestamp#remove()
                silent! call timestamp#addOrUpdate("", "force")
                echo "Annotations removed."
            else
                echo "Annotation aborted."
            end
        end
    end
endfunction

"}}}
function! timestamp#addOrUpdate(annotation,...) "{{{
    if exists("a:1") && len(a:1) > 0
        let forceupdate = 1
    else
        let forceupdate = 0
    endif
    if forceupdate || !exists("g:auto_timestamp_bypass")
        if forceupdate || timestamp#isUpdateOkay(getline(".")) > 0
            let l:bufferdirty = &modified
            let l:origpos = getpos(".")
            let l:hasbasictimestamp = match(getline("."), timestamp#pattern())
            let l:annotation = len(a:annotation) > 0 ? '{' . a:annotation . '}' : ""
            let l:newtimestamp = text#strip_end(substitute(CommentStringFull(), "%s", timestamp#text("short") . " " . l:annotation, ""))
            silent! undojoin
            if l:hasbasictimestamp > 0
                call setline(".", substitute(getline("."), timestamp#annotatedPattern(), l:newtimestamp, ""))
            else
                call text#append(l:newtimestamp)
            end
            call setpos('.', l:origpos)
            if !l:bufferdirty | write | end
        end
    end
endfunction

"}}}
function! timestamp#isUpdateOkay(line) "{{{
    let l:characters = 20
    if len(a:line) < l:characters
        echo "No autotimestamp: line shorter than ". l:characters . " characters."
        return 0
    elseif match(a:line, FoldMarkerOpen()) > 0
        echo "No autotimestamp: line already has open foldmarker."
        return 0
    elseif match(a:line, "^@") > -1
        echo "No autotimestamp: category fold"
        return 0
    elseif match(a:line, FoldMarkerClose()) > 0
        echo "No autotimestamp: line already has close foldmarker."
        return 0
    elseif match(a:line, "^\\s\\+") > -1
        echo "No autotimestamp: line begins with whitespace."
        return 0
    elseif match(a:line, "^x\\s\\|^o\\s\\|\\sx\\s\\|\\so\\s") > -1
        echo "No autotimestamp: line contains completed marker."
        return 0
    elseif len(text#strip(CommentStringOpen())) > 0 && match(a:line, "^" . CommentStringOpen()) > -1
        echo "No autotimestamp: commented line"
        return 0
    else
        return 1
    end
endfunction

"}}}
function! timestamp#annotatedPattern() "{{{
    return substitute(CommentStringFull(), "%s", g:timestamp_annotated_matchstring, "") . '\s*$'
endfunction

"}}}
function! timestamp#pattern() "{{{
    return substitute(CommentStringFull(), "%s", escape(g:timestamp_matchstring, '\'), "")
endfunction

"}}}
function! timestamp#autoUpdateBypass() "{{{
    let g:auto_timestamp_bypass = ""
endfunction

" }}}
function! timestamp#autoUpdateEnable() "{{{
    if exists("g:auto_timestamp_bypass")
        unlet g:auto_timestamp_bypass
    end
endfunction

" }}}
function! timestamp#remove() "{{{
    let l:bufferdirty = &modified
    call setline(".", substitute(getline("."), '\s*' . timestamp#annotatedPattern(), "", ""))
    if !l:bufferdirty | write | end
endfunction

"}}}
" Update old timestamp functions "{{{
if has('python')
function s:update_preferences()
python << EOF
"""
%s/ Timestamp(/ timestamp#insert(/g
%s/TimestampText(/timestamp#text(/g
%s/ TimestampAutoUpdateToggle(/ timestamp#autoUpdateToggle(/g
%s/ AutoTimestampBypass(/ timestamp#autoUpdateBypass(/g
%s/ AutoTimestampEnable(/ timestamp#autoUpdateEnable(/g
%s/AddOrUpdateTimestampSolicitingAnnotation(/timestamp#addOrUpdateSolicitingAnnotation(/g
%s/AddOrUpdateTimestamp(/timestamp#addOrUpdate(/g
%s/IsTimestampUpdateOkay(/timestamp#isUpdateOkay(/g
%s/TimestampAnnotatedPattern(/timestamp#annotatedPattern(/g
%s/TimestampPattern(/timestamp#pattern(/g
%s/RemoveTimestamp(/timestamp#remove(/g
END
"""
EOF
endfunction
endif
" }}}
function! timestamp#date(time = localtime()) "{{{
    return timestamp#dateFactory().New(a:time)
endfunction
"}}}
function! timestamp#dateFactory() "{{{
    let s:dateFormat = "%Y-%m-%d"
    let s:dateRegexp = '[1-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'
    let s:daySeconds = 60 * 60 * 24

    let s:obj = {}
    let s:obj["timeField"] = "unset"
    let s:obj["dateField"] = "unset"

    fun! s:obj.date() dict
        return self["dateField"]
    endfun

    fun! s:obj.time() dict
        return self["timeField"]
    endfun

    fun! s:obj.abb() dict
        return strftime("%c", self.time())->strpart(0,3)
    endfun

    fun! s:obj.next(days = 1) dict
        let l:next_date_seconds = self["timeField"] + (s:daySeconds * a:days)
        return s:factory.New(l:next_date_seconds)
    endfun

    fun! s:obj.setTime(time) dict
        let self["timeField"] = a:time
        let self["dateField"] = strftime(s:dateFormat, a:time)
        return self
    endfun

    let s:factory = {}

    func! s:factory.extractFirstDateFromLine() dict
        let l:extdate = self.extractAllDatesFromLine()->get(0)
        return self.fromDateString(l:extdate)
    endfun

    func! s:factory.fromDateString(date) dict
        let l:date_epoch = strptime(s:dateFormat, a:date)
        if (l:date_epoch == 0)
            let l:date_epoch = localtime()
        endif
        return self.New(l:date_epoch)
    endfun

    func! s:factory.extractAllDatesFromLine(text = getline('.'), match_idx = 0) dict
        return matchlist(a:text, s:dateRegexp)
    endfun

    func! s:factory.New(time = localtime()) dict
       let newobj = copy(s:obj)
       call newobj.setTime(a:time)
       return newobj
    endfun

    return s:factory
endfunction

"}}}
