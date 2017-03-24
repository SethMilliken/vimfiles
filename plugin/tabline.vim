" Modified from
" https://wiki.ncl.cs.columbia.edu/wiki/index.php/Vim_awesomeness
"
" Why doesn't tabline work like guitablabel?
" Why can't I just specify, e.g. set tabline=%m\ %N\ %t%r and have all my
" non-gui tabs do what my gui tabs do when I specify set guitablabel=%m\ %N\ %t\ %r
"
" TODO: rewrite as OOP

if v:version >= 700
else
    finish
endif

function! MyTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
        let currentTab = i + 1

        " select the highlighting
        if currentTab == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif

        " set the tab page number (for mouse clicks)
        let s .= '%' . (currentTab) . 'T'


        " the label is made by MyTabLabel()
        let s .= ' ' . currentTab . ' %{MyTabLabel(' . (currentTab) . ')}'

        " add trailing character
        let s .= ' |'
    endfor

    " after the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLineFill#%T'

    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
        let s .= '%=%#TabLine#%999X X'
    endif

    " echomsg 's:' . s
    return s
endfunction

function! MyTabLabel(n)
    let activebuffer = GetActiveTabBuffer(a:n)
    let customname = gettabvar(a:n, "tabname")
    if len(customname) > 0
        return DecorateDirtyTabName(customname, activebuffer)
    endif

    let tablabel = activebuffer

    while strlen( tablabel ) < 4
        let tablabel = tablabel . " "
    endwhile
    let tablabel = fnamemodify( tablabel, ':t ' )

    let numtabs = tabpagenr('$')
    " account for space padding between tabs, and the "close" button
    let maxlen = ( &columns - ( numtabs * 2 ) - 4 ) / numtabs
    let tablabel = strpart( tablabel, 0, maxlen )

    return DecorateDirtyTabName(tablabel, activebuffer)
endfunction

function! GetActiveTabBuffer(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    return bufname(buflist[winnr - 1])
endfunction

function! DecorateDirtyTabName(tabname, activebuffer)
    if getbufvar(a:activebuffer, "&modified")
        return a:tabname . ' [+]'
    endif
    return a:tabname
endfunction

command! SolicitTabName call SolicitTabName()

function! SolicitTabName()
    let tabname = input("Tab name: ")
    call SetTabName(tabname)
endfunction

function! SetTabName(name)
    if len(a:name) == 0
        if exists("t:tabname")
            unlet t:tabname
        endif
    else
        let t:tabname = a:name
    endif
    normal gtgT
endfunction

" Used in .gvimrc
function! MyGuiTabLabel()
    return exists("t:tabname") ? "%N %{t:tabname} %m" : "%m\ %N\ %t\ %r"
endfunction

set tabline=%!MyTabLine()

set showtabline=1 " 2=always
autocmd GUIEnter * hi! TabLineFill term=underline cterm=underline gui=underline
autocmd GUIEnter * hi! TabLineSel term=bold,reverse,underline
            \ ctermfg=11 ctermbg=12 guifg=#ffff00 guibg=#0000ff gui=underline
