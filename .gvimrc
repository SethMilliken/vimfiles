" GUI Setup "{{{
if version >= 700
	if has("gui_running")
		set t_Co=256
		set t_AB=[48;5;%dm
		set t_AF=[38;5;%dm 
		set cursorline					" highlight current line
		color kellys
		"" No toolbar, please.
		set guioptions-=T
		"" Simple, informative gui tabs (dirty, number, name without path)
		set guitablabel=%m\ %N\ %t\ %r
		set tabpagemax=100
	else
		if (&t_Co > 8)
			color desert256
		else
			color elflord
		end
	end
	if has("gui_macvim")
		color kellys
		" max vertical and horizontal columns on resize to full screen
		set fuopt=maxhorz,maxvert
		set transparency=5
		set antialias
		set gfn=Inconsolata:h15
		" set a reasonable window size
		winsize 345 500
	else
		" set a reasonable window size
		winsize 150 200
		set gfn=Terminal:h6
		" Presentation mode
		"set gfn=Bitstream_Vera_Sans_Mono:h11
	end
	" yank to system clipboard
    set clipboard=unnamed
end
" }}}
" MAPPINGS "{{{
" Mac vs Windows mappings?
"" Map Cmd-t to new tab
nmap <silent> <D-t>	<Esc>:101tabnew<CR>
"" Map Cmd-w to close buffer
nmap <silent> <D-w>	<Esc>:bd<CR>

""" Figure out correct map directive to prevent commands from having other side effects (like moving the cursor).

" Ctrl-Left to previous tab
nnoremap <silent> <C-Left>	<Esc>gT<CR>
" Ctrl-Right to next tab
nnoremap <silent> <C-Right>	<Esc>gt<CR>

" Ctrl-Up Increase font size
nnoremap <C-Up> :silent! :call AdjustFont(1)<CR>
" Ctrl-Down Decrease font size
nnoremap <C-Down> :silent! :call AdjustFont(-1)<CR>

function! AdjustFont(increment) "{{{
	let replacement = 'submatch(0) + ' . a:increment
	let &guifont = substitute( &guifont, ':h\zs\d\+', '\=eval(' .  replacement . ')', '')
	set columns=999
	set lines=999
endfunction

"}}}

"}}}
" vim:ft=vim:fdm=marker:nospell:cms=\ \"%s
