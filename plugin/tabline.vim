" Modified from
" https://wiki.ncl.cs.columbia.edu/wiki/index.php/Vim_awesomeness
"
" Why doesn't tabline work like guitablabel?
" Why can't I just specify, e.g. set tabline=%m\ %N\ %t%r and have all my
" non-gui tabs do what my gui tabs do when I specify set guitablabel=%m\ %N\ %t\ %r
"
" in any case, this still doesn't quite work right. shows the modified flag
" next to the wrong tabs
if v:version >= 700
else
	finish
endif


function! MyTabLine()
	let s = ''
	for i in range(tabpagenr('$'))
		let currentTab = i +  1
		" select the highlighting
		" i've reversed the settings cause i prefer the selected tag to be underlined
		if currentTab == tabpagenr()
			let s .= '%#TabLine#'
		else
			let s .= '%#TabLineSel#'
		endif

		" set the tab page number (for mouse clicks)
		let s .= '%' . (currentTab) . 'T'


		" the label is made by MyTabLabel()
		let s .= ' ' . currentTab . ' %{MyTabLabel(' . (currentTab) . ')}'

		" set the modified flag
	    if getbufvar(currentTab, "&modified")
	      let s .= ' [+]'
	    endif

		" add trailing character
		let s .= ' |'
	endfor

	" after the last tab fill with TabLineFill and reset tab page nr
	let s .= '%#TabLineFill#%T'

	" right-align the label to close the current tab page
	if tabpagenr('$') > 1
		let s .= '%=%#TabLine#%999X X'
	endif

	"echomsg 's:' . s
	return s
endfunction

function! MyTabLabel(n)
        if exists("t:tabname")
            return t:tabname
        endif
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let numtabs = tabpagenr('$')
	" account for space padding between tabs, and the "close" button
	let maxlen = ( &columns - ( numtabs * 2 ) - 4 ) / numtabs
	let tablabel = bufname(buflist[winnr - 1])
	while strlen( tablabel ) < 4
		let tablabel = tablabel . " "
	endwhile
	let tablabel = fnamemodify( tablabel, ':t ' )
	let tablabel = strpart( tablabel, 0, maxlen )
	return tablabel
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

function! MyGuiTabLabel()
	return exists("t:tabname") ? "%N %{t:tabname} %m" : "%m %N %t %r"
endfunction

set tabline=%!MyTabLine()
set guitablabel=%!MyGuiTabLabel()

set showtabline=1 " 2=always
autocmd GUIEnter * hi! TabLineFill term=underline cterm=underline gui=underline
autocmd GUIEnter * hi! TabLineSel term=bold,reverse,underline
			\ ctermfg=11 ctermbg=12 guifg=#ffff00 guibg=#0000ff gui=underline
