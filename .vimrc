" INFO: {{{

" Maintainer:
" 	Seth Milliken <seth_vim@araxia.net>
" 	Araxia on #vim irc.freenode.net

" Version:
" 	1.0 2010-01-16 22:49:45 PST 

" Tabs: #vim conventional wisdom recommends not using real tabs at all, ever
" 		ts=8:sw=4:sts=4
" 	I disagree and find consistent use of real tabs very useful.


"}}}
" DEFAULT example .vimrc {{{
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
set shortmess+=I 					" don't show intro on start
set shortmess+=A 					" don't show message on existing swapfile
set nospell							" spelling off by default
set spellcapcheck=off				" ignore case in spellcheck
set encoding=UTF-8 					" use UTF-8 encoding
set nolist							" don't show invisibles
set listchars=tab:>-,trail:-		" ...but make them look nice when they do show 
set iskeyword+=-					" usually want - to not divide words
set lbr								" wrap lines at word breaks 
set noautoindent					" don't like autoindent
set number							" always show line numbers
set autowrite						" auto write changes when switching buffers
set shiftwidth=4					" smaller tab stops
set tabstop=4						" reasonable tab stop width
set softtabstop=0					" use only tabs	
set autoindent 						" keep indent at same level
set hlsearch 						" highlight searches
set tags+=$HOME/sandbox/personal/tags
									" universal tags file
set directory=$HOME/.vim/swap//,~/vimfiles/swap
									" centralize swap files (with unique names, //)
set nowritebackup					" allow crontab editing.
									" TODO: should this be in an au?
set nobackup						" don't like ~ files littered about
									" TODO: can these be stored centrally a la swap?
" Sessionopts: defaults are blank,buffers,curdir,folds,help,options,tabpages,winsize
set ssop=folds,help,options,tabpages,winsize
set ssop+=globals,sesdir,resize,winpos,unix
" TODO: annotate this status line description
set statusline=%<\(%n\)\ %m%y%r\ %f\ %=%-14.(%l,%c%V%)\ %P
set laststatus=2					" always show the status line
set splitright						" open vertical splits to the right
set splitbelow						" open horizonal splits below
set winminheight=0 					" minimized horizontal splits show only statusline
set switchbuf=useopen,usetab 		" when switching to a buffer, go to where it's already open
set history=10000					" keep craploads of command history
set foldlevelstart=0				" don't use a default fold level
set cms=\ %s						" generally don't want commentstring for folds
set fdm=marker						" make the default foldmethod markers
set foldcolumn=4					" trying out fold indicator column

"}}}
" MAPPINGS {{{
" Zaurus: <C-Space> (<C-k><C-Space>) to invoke command mode in both insert and normal mode
imap <Nul> <Esc>:
nnoremap <Nul> :

"Annoyances: Stop F1 from invoking Help
map <F1> <Esc>
imap <F1> <Esc>

" Reset: restore some default settings and redraw
nnoremap <silent> <C-L> :call Reset() \| nohls<CR>
imap <silent> <C-L> <Esc>:call Reset() \| nohls<CR>a

" Get word count of current file
nnoremap <silent> <Leader>w <Esc>:!wc -w %<CR>

" Copy buffer to clipbard
"" map <something>	<Esc>:%y*<CR>

" Refresh buffer from disk FIXME: find a non-conflicting binding
nnoremap <silent> <S-k> <Esc>:e<CR><Esc>:$<CR>

" Save Session: (verify cwd to not stomp on existing sessions)
nnoremap SS <Esc>:w<CR><Esc>:mks! \| call FixSession()<CR><Esc>:echo "Saved fixed session: " . v:this_session<CR>

" Misc:
nnoremap <silent> <Leader>] :NERDTreeToggle<CR>
" nnoremap <silent> <Leader>[ :TMiniBufExplorer<CR>

" Folds:
nnoremap <silent> <Leader>- <Esc>:silent g/^done {{/call FoldUnfolded()<CR><C-l>
nnoremap <silent> <Leader>= <Esc>:silent g/^@[^A-Z]* {{/normal zv<CR><C-l>

" Scratch Buffer: close with ZZ
nnoremap <silent> <Leader>c <Esc>:call ScratchBuffer("scratch")<CR>

" Open URIs:
nnoremap <silent> <Leader>\ :call HandleURI()<CR>
nnoremap <silent> <Leader>t :call HandleTS()<CR>

" SQL: grab and format sql statement from current line
nnoremap <silent> <Leader>q <Esc>:call FormatSqlStatement()<CR>

" Formatting: Wrap current or immediately preceding word in in <em> tag
nnoremap <Leader>_ <Esc>Bi<em><Esc>ea</em>

" Completion: show completion preview, without actually completing
inoremap <C-p> <Esc>:set completeopt+=menuone<CR>a<C-n><C-p>

" help help help
nnoremap <Leader>pp	 	<Esc>:help<CR><Esc>:winc _<CR><Esc>:winc \|<CR><Esc>:help<Space>
nnoremap <Leader>p+ 	<Esc>:tab help<Space>

" Cmdline Window: shortcut 
nnoremap :: q:

" Cmdline Window:
augroup cmdline-window
	au CmdwinEnter * map <buffer> <C-y> <C-c><CR>q:
	au CmdwinEnter * map <buffer> ZZ <C-c><C-c>
	au CmdwinEnter * set winheight=1
augroup END

" Learn your hjkl!
nnoremap <Left> 	<Esc>:echo "You should have typed h instead"<CR>
nnoremap <Right> 	<Esc>:echo "You should have typed l instead"<CR>
nnoremap <Up> 		<Esc>:echo "You should have typed k instead"<CR>
nnoremap <Down> 	<Esc>:echo "You should have typed j instead"<CR>

" Accordion Mode: accordion style horizontal split navigation mode
nnoremap <silent> <C-j> <C-w>j:call AccordionMode()<CR><C-l>
nnoremap <silent> <C-k> <C-w>k:call AccordionMode()<CR><C-l>
nnoremap <silent> <C-y> <C-w>h:call AccordionMode()<CR><C-l>
nnoremap <silent> <C-h> <C-w>l:call AccordionMode()<CR><C-l>
function! AccordionMode()
	set winheight=9999 winminheight=0
endfunction
" exit accordion mode
nnoremap <C-w>= :set winheight=10 winminheight=10 \| wincmd =<CR>

" Timestamp: {{{
nnoremap <silent> <Leader>sd <Esc>:call Timestamp("date")<CR>
nnoremap <silent> <Leader>st <Esc>:call Timestamp("short")<CR>
nnoremap <silent> <Leader>sl <Esc>:call Timestamp("long")<CR>
nnoremap <silent> <Leader>fw <Esc>:call FoldWrap()<CR>
nnoremap <silent> <Leader>fi <Esc>:call FoldInsert()<CR>
nnoremap <silent> <Leader>ll o<Esc>:call Timestamp("short") \| call FoldWrap()<CR>
" }}}
" Cmd-# and Alt-# to switch tabs {{{
for n in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
	let k = n == "0" ? "10" : n
	for m in ["A", "D"]
		exec printf("imap <buffer> <silent> <%s-%s> <Esc>:tabn %s<CR>", m, n, k)
		exec printf("nmap <buffer> <silent> <%s-%s> %sgt<CR>", m, n, k)
	endfor
endfor
" }}}
"}}}
" FUNCTIONS: {{{
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
		 normal J$x
	endif
endfunction

"}}}
function! FoldWrap() "{{{
	" spliting markers here to prevent false markers
	let s:exp = len(&commentstring) > 0 ? &commentstring : " %s"
	let s:openmarker = substitute(s:exp, '%s', "{{" ."{", 'g')
	let s:rawclosemarker = substitute(s:exp, '%s', "}}" ."}", 'g')
	let s:closemarker = substitute(s:rawclosemarker, '^\s', '', '') " strip pre-space
	call append(line("."), [s:openmarker, "", s:closemarker])
	exe "normal Jj"
	startinsert
endfunction
"}}}
function! FoldInsert() "{{{
	normal O
	call FoldWrap()
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
function! ScratchBuffer(title) " {{{
	  exec "tabe " . a:title . " | setlocal buftype=nofile | setlocal bufhidden=hide | setlocal noswapfile"
endfunction
" }}}
function! FormatSqlStatement() " {{{
  3match Todo /select .*/
  let s:uri = matchstr(getline("."), 'select .*')
  if s:uri != ""
	  let @a = s:uri
	  call ScratchBuffer("sql statement")
	  setlocal bufhidden=delete
	  normal "ap
	  set ft=sql
	  for keyword in ["from", "and", "inner", "where", "left", "right"]
		  exec "silent! s/" . keyword . "/\r&/g"
	  endfor
  else
	  echo "No SQL statement found."
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
function! Reset() " {{{
	silent pclose
	set completeopt-=menuone
	set nolist
	redraw
	echo "Reset"
endfunction
" }}}

"}}}
" SYNTAX: {{{
" Java:
augroup java
	au BufReadPre * setlocal foldmethod=syntax
	au BufReadPre * setlocal foldlevelstart=-1
augroup END

" SVN:
au BufNewFile,BufRead  svn-commit.* setf svn	" handle svn commits

" Text:
au BufNewFile *.txt set fdm=marker

"}}}
" PLUGINS: {{{

" python syntax
let python_highlight_all = 1

" minbufexplorer
let g:miniBufExplVSplit=30
" let g:miniBufExplMaxSize = <max width: default 0> 
let g:miniBufExplMapCTabSwitchBufs = 1

" BufExplorer:
map <silent> <C-Tab> :BufExplorer<CR>j
map <silent> <C-S-Tab> :BufExplorer<CR>k
au! BufWinEnter \[BufExplorer\] map <buffer> <Tab> <CR>

" Pydiction:
let g:pydiction_location = '~/.vim/complete-dict'

" Rope:
" let $PYTHONPATH .= ":/Library/Python/2.5/site-packages/ropemode:/Library/Python/2.5/site-packages:/Users/seth/sandbox/code/python/"
" source ~/sandbox/code/python/ropevim/ropevim.vim

" SnipMate:
let g:snips_author = 'Seth Milliken'
map <silent> <Leader>snip <Esc>:call ResetSnippets() \| call GetSnippets(g:snippets_dir, &ft)<CR><Esc>:echo "Snippets for format \"" . &ft . "\" updated."<CR>

" Vimwiki:
map <silent> <Leader>w2 <Esc>:w<CR>:VimwikiAll2HTML<CR><Esc>:echo "Saved wiki to HTML."<CR>
let g:vimwiki_hl_headers = 1 				" hilight header colors
let g:vimwiki_hl_cb_checked = 1 			" hilight todo item colors
let g:vimwiki_list_ignore_newline = 0 		" convert newlines to <br /> in list
let g:vimwiki_list = [{'path': '~/sandbox/personal/vimwiki/', 'index': 'PersonalWiki'}, {'path': '~/sandbox/public/wiki', 'index': 'SethMilliken'}, {'path': '~/sandbox/work/wiki/', 'index': 'SethMilliken', 'html_header': '~/sandbox/work/wiki/header.tpl'}]

" }}}
" TESTING: {{{

" set ff=unix
" let string="!echo 'bar' | ls"
" let mapleader=","

" }}}
" vim: set ft=vim fdm=marker tw=80 cms=\ \"\ %s  :
