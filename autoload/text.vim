" Text: tools
function! text#append(text) "{{{
    let l:originalline = getline(".")
    if text#line_is_whitespace(getline("."))
        call text#insert_line(a:text)
    else
        call append(line("."),[a:text])
        normal J$
    endif
endfunction

"}}}
function! text#insert_line(text) "{{{
    if text#line_is_whitespace(getline("."))
        call setline(line("."),[a:text])
    else
        call append(line(".") - 1,[a:text])
    end
endfunction

"}}}
function! text#append_line(text, direction) "{{{
    if a:direction == "above"
        let where = 1
    else
        let where = 0
    end
    call append(line(".") - where,[a:text])
endfunction

"}}}
function! text#annotation(label) "{{{
    return printf("[ %s: %s ]", a:label, timestamp#text("short"))
endfunction

"}}}
function! text#insert_annotation(label, line) "{{{
    call append(a:line, text#annotation(a:label))
endfunction

"}}}
function! text#insert_leading_annotation(label) "{{{
    call text#insert_annotation(a:label, "0")
    "call append(1, [""])
endfunction

"}}}
function! text#insert_trailing_annotation(label) "{{{
    call append("$", [""])
    call text#insert_annotation(a:label, "$")
endfunction

"}}}
function! text#line_is_whitespace(line) "{{{
    return a:line =~ '^\s*$'
endfunction

"}}}
function! text#file_to_pasteboard(...) "{{{
    let appendtext = ""
    if len(a:000) > 0
        let appendtext = ":" . a:000[0]
    end
    call setreg('*', expand('%r') . appendtext)
    echo "Pasteboard: \"" . @* . "\""
endfunction

"}}}

" Replace with tlib/autoload/tlib/string.vim Strip and Trim func
function! text#strip(string) "{{{
    return text#strip_front(text#strip_end(a:string))
endfunction

"}}}
function! text#strip_end(string) "{{{
    return substitute(a:string, "[[:space:]]*$", "", "")
endfunction

"}}}
function! text#strip_front(string) "{{{
    return substitute(a:string, "^[[:space:]]*", "", "")
endfunction

"}}}
function! text#divider(string) "{{{
    return repeat(a:string, 80)
endfunction

"}}}
function! text#showmessage(...) "{{{
    if type(a:000[0]) == v:t_list
        let l:payload = a:000[0] + a:000[1:]
    else
        let l:payload = a:000
    endif
    if has('popupwin')
        call popup_notification(l:payload, {"pos": "topright", "col": winwidth(win_getid())})
    else
        echo l:payload->join("\n")
    endif
endfunction

"}}}
