" Timestamp Functions
function! timestamp#insert(style) "{{{
    call AppendText(timestamp#text(a:style) . " ")
endfunction

" }}}
function! timestamp#text(style) "{{{
    let l:iswindows = has("win16") || has("win32") || has("win64")
    if l:iswindows
        if a:style == "long"
            let l:dateformat = strftime("%#x %H:%M:%S ")
        elseif a:style == "short"
            let l:dateformat = strftime("%Y-%m-%d %H:%M:%S ") 
        endif
        let l:dateformat .= substitute(strftime("%#z"), '[a-z]\+\($\| \)', '', 'g')
    else
        if a:style == "long"
            let l:dateformat = strftime("%Y %b %d %a %X %Z")
        elseif a:style == "journal"
            let l:dateformat = strftime("%A, %B %d, %Y %H:%M:%S %Z")
        elseif a:style == "short"
            let l:dateformat = strftime("%Y-%m-%d %H:%M:%S %Z")
        elseif a:style == "time"
            let l:dateformat = strftime("%H:%M:%S %Z")
        endif
    endif
    if a:style == "date"
        let l:dateformat = strftime("%Y-%m-%d")
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
        let l:annotation = input("Annotation: ", Strip(l:default_prompt))
        if len(l:annotation) > 0
            call timestamp#addOrUpdate(Strip(l:annotation), "force")
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
            let l:newtimestamp = StripEnd(substitute(CommentStringFull(), "%s", timestamp#text("short") . " " . l:annotation, ""))
            silent! undojoin
            if l:hasbasictimestamp > 0
                call setline(".", substitute(getline("."), timestamp#annotatedPattern(), l:newtimestamp, ""))
            else
                call AppendText(l:newtimestamp)
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
        echo "No autotimestamp: project fold"
        return 0
    elseif match(a:line, FoldMarkerClose()) > 0
        echo "No autotimestamp: line already has close foldmarker."
        return 0
    elseif match(a:line, "^x\\s\\|^o\\s\\|\\sx\\s\\|\\so\\s") > -1
        echo "No autotimestamp: line contains completed marker."
        return 
    elseif len(Strip(CommentStringOpen())) > 0 && match(a:line, "^" . CommentStringOpen()) > -1
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
function! timestamp#autoUpdateBypass() " {{{
    let g:auto_timestamp_bypass = ""
endfunction

" }}}
function! timestamp#autoUpdateEnable() " {{{
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
if has('python')
function s:heredoc()
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
