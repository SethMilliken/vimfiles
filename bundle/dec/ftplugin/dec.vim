" INFO: " {{{

" Maintainer:
"   Seth Milliken <seth_vim@araxia.net>
"   Araxia on #vim irc.freenode.net

" Version:
" 0.1 " 2018-05-09 16:24:08 PDT

" Notes:

" Todo:

"}}}
" VARIABLES: " {{{


let s:draftlog_sentinel = "Event #: "
let s:maindeck_annotation  = "// Maindeck"
let s:sideboard_annotation = "// Sideboard"


" }}}
" AUGROUP: " {{{
augroup DecList | au!
    au FileType *dec* map <buffer> QQ <Plug>MoveToMainTop
    au FileType *dec* map <buffer> Qq <Plug>MoveToSideboard
    au FileType *dec* map <buffer> Qx <Plug>MoveToSideboard
    au FileType *dec* map <buffer> <C-y>t <Plug>TransformDraftLogToPool
    au FileType *dec* map <buffer> <C-j> <SID>MoveItemDown
    au FileType *dec* map <buffer> <C-k> <SID>MoveItemUp
augroup END

" }}}
" FUNCTIONS: " {{{
if !exists("*s:TransformDraftLogToPool")
    function! s:TransformDraftLogToPool() "{{{
        let l:is_draftlog = search(s:draftlog_sentinel, 'wcn')
        if l:is_draftlog
            silent! set readonly
            silent! normal ggVGygg
            silent! vnew
            silent! normal p
            silent! g/Time: /normal "aY
            silent! 1,/----/d
            silent! v/--> /d
            silent! % s/--> //
            silent! % !sort
            " silent! normal gg"aP
            silent! g/^\(Island\|Plains\|Forest\|Swamp\|Mountain\)$/d
            let timestamp = substitute(getreg("a"), "Time:    ", "", "")
            let timestamp = substitute(timestamp, "[ :]", "-", "g")
            call append(line("0"), "// Maindeck " . timestamp)
            call append(line("$"), ["", "// Sideboard"])
            exec "saveas " . tempname() . "_" . timestamp . ".dec"
            set nornu nonu
        else
            echo "This does not look like a draft log."
        end
    endfunction
endif
command! TransformDraftLogToPool :call TransformDraftLogToPool()
noremap <SID>TransformDraftLogToPool :call <SID>TransformDraftLogToPool()<CR>
noremap <script> <Plug>TransformDraftLogToPool <SID>TransformDraftLogToPool

" }}}

" }}}
" Movement: {{{
function! s:MoveToSideboard(line) " {{{
    call s:MoveBelowText(s:sideboard_annotation)
endfunction
noremap <script> <Plug>MoveToSideboard <SID>MoveToSideboard
noremap <silent> <SID>MoveToSideboard :call <SID>MoveToSideboard(line("."))<CR>

" }}}
function! s:MoveToMainTop(line) " {{{
    call s:MoveBelowText(s:maindeck_annotation)
endfunction
noremap <script> <Plug>MoveToMainTop <SID>MoveToMainTop
noremap <SID>MoveToMainTop :call <SID>MoveToMainTop(line("."))<CR>

" }}}

function! s:MoveBelowText(text) " {{{
    let target = search(a:text, 'wcn')
    if target > 0
        call <SID>MoveToLine(target)
    endif
endfunction

" }}}
function! s:MoveToLine(line) " {{{
    let l:dest = a:line
    let l:save_position = getpos(".")
    if a:line > line("$")
        let l:dest = line("$")
    endif
    if line(".") < l:dest
        let l:dest -= 1
    endif
    let l:contents = getline(line("."))
    normal 1d_
    call append(l:dest, l:contents)
    call setpos('.', l:save_position)
endfunction

" }}}


function! s:MoveItemDown() range " {{{
    let l:motion = a:lastline - a:firstline
    if line(".") < line("$")
        let l:contents = getline(line("."))
        normal d_
        call append(line("."), l:contents)
        normal j
    end
endfunction
noremap <silent> <SID>MoveItemDown :call <SID>MoveItemDown()<CR>
noremap <script> <Plug>MoveItemDown <SID>MoveItemDown

"
" }}}
function! s:MoveItemUp() range " {{{
    let l:motion = a:lastline - a:firstline
    if line(".") > 1
        let l:is_last_line = line(".") == line("$")
        let l:contents = getline(line("."))
        normal d_
        if (l:motion > 0)
            exe "normal " . l:motion . "k"
        elseif !(l:is_last_line)
            normal k
        end
        call append(line(".") - 1, l:contents)
        normal k
    end
endfunction
noremap <silent> <SID>MoveItemUp :call <SID>MoveItemUp()<CR>
noremap <script> <Plug>MoveItemUp <SID>MoveItemUp

"
" }}}

" }}}
" vim: set sw=4 ft=vim fdm=marker cms=\ \"\ %s  :
