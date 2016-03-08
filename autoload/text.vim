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
function! text#insert_annotation(label, line) "{{{
    let result = printf("[ %s: %s ]", a:label, timestamp#text("short"))
    call append(a:line, result)
endfunction

"}}}
function! text#insert_leading_annotation(label) "{{{
    call text#insert_annotation(a:label, "0")
    call append(1, [""])
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
