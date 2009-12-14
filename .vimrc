" DEFAULT example .vimrc {{{

" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2002 Sep 19
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
	finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
	set nobackup		" do not keep a backup file, use versions instead
else
	set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
	syntax on
	set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
	" Enable file type detection.
	" Use the default filetype settings, so that mail gets 'tw' set to 72,
	" 'cindent' is on in C files, etc.
	" Also load indent files, to automatically do language-dependent indenting.
	filetype plugin indent on

	" Put these in an autocmd group, so that we can delete them easily.
	augroup vimrcEx
	au!

	" For all text files set 'textwidth' to 78 characters.
	" autocmd FileType text setlocal textwidth=78
	" Ummmmm...no! --Seth

	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	" (happens when dropping a file on gvim).
	autocmd BufReadPost *
	  \ if line("'\"") > 0 && line("'\"") <= line("$") |
	  \   exe "normal g`\"" |
	  \ endif

	augroup END
	set autoindent		" always set autoindenting on
endif " has("autocmd")
"}}}
" Seth Milliken additions
" SETTINGS {{{
set nospell							" spelling off by default
set spellcapcheck=off				" ignore case in spellcheck
set iskeyword+=-					" usually want - to not divide words
set nolist							" don't show invisibles
set listchars=tab:>-,trail:-		" ...but make them look nice when they do show 
set nowritebackup					" allow crontab editing
set noautoindent					" don't like autoindent
set number							" always show line numbers
set nobackup						" don't like ~ files littered about
set autowrite						" auto write changes when switching buffers
" #vim recommends not using real tabs at all. ts=8:sw=4:sts=4
" i disagree. i find real tabs very useful.
set shiftwidth=4					" smaller tab stops
set tabstop=4						" reasonable tab stop width
set softtabstop=0					" use only tabs	
set nohidden						" close buffers when tabs are closed
set directory=$HOME/.vim/swap//		" centralize swap files (with unique names, //)
set lbr								" wrap lines at word breaks 
set cms=							" generally don't want commentstring for folds
set fdm=marker						" make the default foldmethod markers
"set ft=txt							" default format is text
" default ssops: blank,buffers,curdir,folds,help,options,tabpages,winsize
set ssop=folds,help,options,tabpages,winsize
set ssop+=globals,sesdir,resize,winpos,unix
set tags+=$HOME/sandbox/personal/tags " universal tags file
" TODO: annotate this status line description
set statusline=%<\(%n\)\ %m%y%r\ %f\ %=%-14.(%l,%c%V%)\ %P
set laststatus=2					" always show the status line
set splitright						" open new windows vertically
set switchbuf=useopen,usetab,newtab
set history=10000					" keep craploads of command history
set shortmess+=I 					" don't show intro on start
set shortmess+=A 					" don't show message on existing swapfile
set foldlevelstart=0				" don't use a default fold level

"}}}
" MAPPINGS {{{
"" Map C-space for Zaurus ( Ctrl-k Ctrl-space ) in both insert mode and command mode
map <Nul> :
map! <Nul> :

" Wrap current or immediately preceding word in in <em> tag
map! <Leader>_ <Esc>Bi<em><Esc>ea</em>
" Clear last search as well as redraw with ^L
nnoremap	<silent>	<C-L>	:nohls<CR><C-L>
" Get word count of current file
nmap <silent> <Leader>w <Esc>:!wc -w %<CR>
" Copy buffer to clipbard
"" map <something>	<Esc>:%y*<CR>
" Refresh buffer from disk
nmap <silent> <S-k> <Esc>:e<CR><Esc>:$<CR>
" Save session (can we only do this if there are n tabs open?)
map SS <Esc>:w<CR><Esc>:mks! \| call FixSession()<CR><Esc>:echo "Saved fixed session: " . v:this_session<CR>
" Open URIs
map <silent> <Leader>\ :call HandleURI()<CR>
map <silent> <Leader>t :call HandleTS()<CR>
" Misc
nnoremap <silent> <Leader>] :NERDTreeToggle<CR>
" nnoremap <silent> <Leader>[ :TMiniBufExplorer<CR>
" Fold done folds
nnoremap <silent> <Leader>- <Esc>:silent g/^done {{/call FoldUnfolded()<CR><C-l>
nnoremap <silent> <Leader>= <Esc>:silent g/^@[^A-Z]* {{/normal zv<CR><C-l>
" scratch buffer; close with ZZ
nnoremap <silent> <Leader>s <Esc>:tabe<CR><Esc>:setlocal bufhidden=hide<CR><Esc>:setlocal buftype=nofile<CR>

" cmdline-window ftw!
" cmap : <Esc>
" nnoremap :	<Esc>q:i
" help help help
nnoremap <Leader>pp	 	<Esc>:help<CR><Esc>:winc _<CR><Esc>:winc \|<CR><Esc>:help<Space>
nnoremap <Leader>p+ 	<Esc>:tab help<Space>
" Learn your hjkl!
nnoremap <Left> 	<Esc>:echo "You should have typed h instead"<CR>
nnoremap <Right> 	<Esc>:echo "You should have typed l instead"<CR>
nnoremap <Up> 		<Esc>:echo "You should have typed k instead"<CR>
nnoremap <Down> 	<Esc>:echo "You should have typed j instead"<CR>

" Timestamp {{{
nmap <silent> ts <Esc>:call Timestamp("short")<CR>
nmap <silent> tl <Esc>:call Timestamp("long")<CR>
nmap <silent> td <Esc>:call Timestamp("date")<CR>
nnoremap <silent> tf <Esc>:call FoldWrap()<CR>
nnoremap <silent> tt <Esc>:call FoldInsert()<CR>
nmap <silent> tg tstf
nmap <silent> th dstf
nmap <silent> tj tdtf
" }}}
" Cmd-# to switch tabs {{{
imap <silent> <D-1> <Esc>:tabn 1<CR> 
imap <silent> <D-2> <Esc>:tabn 2<CR> 
imap <silent> <D-3> <Esc>:tabn 3<CR>
imap <silent> <D-4> <Esc>:tabn 4<CR>
imap <silent> <D-5> <Esc>:tabn 5<CR>
imap <silent> <D-6> <Esc>:tabn 6<CR>
imap <silent> <D-7> <Esc>:tabn 7<CR>
imap <silent> <D-8> <Esc>:tabn 8<CR>
imap <silent> <D-9> <Esc>:tabn 9<CR>
imap <silent> <D-0> <Esc>:tabn 10<CR>
nmap <silent> <D-1> 1gt
nmap <silent> <D-2> 2gt
nmap <silent> <D-3> 3gt 
nmap <silent> <D-4> 4gt 
nmap <silent> <D-5> 5gt 
nmap <silent> <D-6> 6gt 
nmap <silent> <D-7> 7gt 
nmap <silent> <D-8> 8gt 
nmap <silent> <D-9> 9gt 
nmap <silent> <D-0> 10gt 
" }}}
" Alt-# to switch tabs {{{
imap <silent> <A-1> <Esc>:tabn 1<CR> 
imap <silent> <A-2> <Esc>:tabn 2<CR> 
imap <silent> <A-3> <Esc>:tabn 3<CR>
imap <silent> <A-4> <Esc>:tabn 4<CR>
imap <silent> <A-5> <Esc>:tabn 5<CR>
imap <silent> <A-6> <Esc>:tabn 6<CR>
imap <silent> <A-7> <Esc>:tabn 7<CR>
imap <silent> <A-8> <Esc>:tabn 8<CR>
imap <silent> <A-9> <Esc>:tabn 9<CR>
imap <silent> <A-0> <Esc>:tabn 10<CR>
nmap <silent> <A-1> 1gt
nmap <silent> <A-2> 2gt
nmap <silent> <A-3> 3gt 
nmap <silent> <A-4> 4gt 
nmap <silent> <A-5> 5gt 
nmap <silent> <A-6> 6gt 
nmap <silent> <A-7> 7gt 
nmap <silent> <A-8> 8gt 
nmap <silent> <A-9> 9gt 
nmap <silent> <A-0> 10gt 
" }}}
"}}}

" FUNCTIONS {{{
function! Timestamp(style) "{{{
	let s:originalline = getline(".")
	let s:iswindows = has("win16") || has("win32") || has("win64")
	if s:iswindows
		if a:style == "long"
			let s:dateformat = strftime("%#x %H:%M:%S ")
		elseif a:style == "short"
			let s:dateformat = strftime("%Y-%m-%d %H:%M:%S ") 
		endif
		let s:dateformat .= substitute(strftime("%#z"), '[a-z]\+\($\| \)', '', 'g')
	else
		if a:style == "long"
			let s:dateformat = strftime("%Y %b %d %a %X %Z")
			" let s:dateformat = strftime("%A, %B %d, %Y %H:%M:%S %Z")
		elseif a:style == "short"
			let s:dateformat = strftime("%Y-%m-%d %H:%M:%S %Z")
		endif
	endif
	if a:style == "date"
		let s:dateformat = strftime("%Y-%m-%d")
	endif
	let s:dateformat .= " "
	call append(line("."),[s:dateformat])
	if substitute(s:originalline, "\\s", "", "g") == ""
		normal J$
	else
		normal j$
	endif
endfunction
"}}}
function! FoldInsert() "{{{
	" try to include the fold comment if necessary, too. (cms)
	" spliting markers here to prevent false markers
	call append(line("."),[" {{" . "{", "", "", "}}" . "}"])
	normal j0
	startinsert
endfunction
"}}}
function! FoldWrap() "{{{
	call append(line(".")," {{" . "{}" . "}}")
	exe "normal Jf}i\<CR>\<CR>\<Esc>k"
	startinsert
endfunction
"}}}
function! FoldUnfolded() " {{{
	if foldclosed(".") < 0 " not already closed
		normal zc
	endif
endfunction
" }}}
function! HandleTS() " {{{
  let s:ticket = matchstr(getline("."), 'TS#[0-9]\+')
  let s:number = matchstr(s:ticket, '[0-9]\+')
  if s:ticket != ""
    let s:tsuri = 'https://trackstudio.nimblefish.com/task/' . s:number . '?thisframe=true'
	exec "silent !start rundll32.exe url.dll,FileProtocolHandler " . s:tsuri
    echo "Opened Ticket: " . s:number
  else
	  echo "No TS ticket found in line."
  endif
endfunction
" }}}
function! HandleURI() " {{{
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;]*')
  if s:uri != ""
	  if has("win32")
		  exec "silent !start rundll32.exe url.dll,FileProtocolHandler " . s:uri
	  else
		  exec "silent !open \"" . s:uri . "\""
	  endif
	  echo "Opened URI: " . s:uri
  else
	  echo "No URI found in line."
  endif
endfunction
" }}}
function! FixSession() " {{{
  silent exe "split " . v:this_session
  silent exe "%s/^edit /buffer /g"
  silent exe "w"
  silent exe "close"
endfunction
" }}}
"}}}
" SYNTAX "{{{
augroup java
	au BufReadPre * setlocal foldmethod=syntax
	au BufReadPre * setlocal foldlevelstart=-1
augroup END
au BufNewFile,BufRead  svn-commit.* setf svn	" handle svn commits
augroup none
	au BufReadPre * setlocal filetype=txt
augroup END

"}}}
" PLUGINS {{{
" snipMate
let g:snips_author = 'Seth Milliken'
map <silent> <Leader>s <Esc>:call ResetSnippets() \| call GetSnippets(g:snippets_dir, &ft)<CR><Esc>:echo "Snippets for format \"" . &ft . "\" updated."<CR>
" vimwiki
map <silent> <Leader>w2 <Esc>:w<CR>:VimwikiAll2HTML<CR><Esc>:echo "Saved wiki to HTML."<CR>
let g:vimwiki_hl_headers = 1 " hilight header colors
let g:vimwiki_hl_cb_checked = 1 " hilight todo item colors
let g:vimwiki_list_ignore_newline = 0 " convert newlines to <br /> in list
let g:vimwiki_list = [{'path': '~/sandbox/personal/vimwiki/', 'index': 'PersonalWiki'}, {'path': '~/sandbox/public/wiki', 'index': 'SethMilliken'}]
" }}}
" TESTING {{{
" set ff=unix
" let string="!echo 'bar' | ls"
" let mapleader=","
" }}}
" vim:fdm=marker:nospell:cms=\"%s:ft=vim
