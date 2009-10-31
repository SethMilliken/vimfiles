" so ${HOME}/.vimrc
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
		set fuopt=maxhorz,maxvert		" max vertical and horizontal columns on resize to full screen
		set transparency=5
		set antialias
		set gfn=Inconsolata:h15
		winsize 345 500 " set a reasonable window size
	else
		winsize 150 200					" set a reasonable window size
		set gfn=Terminal:h6
		" Presentation mode
		"set gfn=Bitstream_Vera_Sans_Mono:h11
	end
end
" MAPPINGS "{{{
" Mac vs Windows mappings?
"" Map Cmd-t to new tab
nmap <silent> <D-t>	<Esc>:101tabnew<CR>
"" Map Cmd-w to close buffer
nmap <silent> <D-w>	<Esc>:bd<CR>
"" Stop F1 from invoking Help
map <F1> <Esc>
imap <F1> <Esc>

""" Figure out correct map directive to prevent commands from having other side effects (like moving the cursor).
" Ctrl-Left to previous tab
nnoremap <silent> <C-Left>	<Esc>gT<CR>
" Ctrl-Right to next tab
nnoremap <silent> <C-Right>	<Esc>gt<CR>
" Ctrl-Up Increase font size
nnoremap <C-Up> :silent! let &guifont = substitute( &guifont, ':h\zs\d\+', '\=eval(submatch(0)+1)', '')<CR>
" Ctrl-Down Decrease font size
nnoremap <C-Down> :silent! let &guifont = substitute( &guifont, ':h\zs\d\+', '\=eval(submatch(0)-1)', '')<CR>
"}}}

"}}}
"vim:fdm=marker:nospell:cms=\"%s
