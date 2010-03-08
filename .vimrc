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
set directory=$HOME/.vim/swap//,~/vimfiles/swap//
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
set diffopt+=vertical
set splitright						" open vertical splits to the right
set splitbelow						" open horizonal splits below
set winminheight=0 					" minimized horizontal splits show only statusline
set switchbuf=useopen,usetab 		" when switching to a buffer, go to where it's already open
set history=10000					" keep craploads of command history
set undolevels=100					" keep lots of undo history
set foldlevelstart=0				" don't use a default fold level
" TODO: only set if missing
" set cms=\ %s						" generally don't want commentstring for folds
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
nmap <Space> <C-f>
nmap <S-Space> <C-b>

" Reset: restore some default settings and redraw
nnoremap <silent> <C-L> :call Reset() \| nohls<CR>
imap <silent> <C-L> <Esc>:call Reset() \| nohls<CR>a

" Get word count of current file
nnoremap <silent> <Leader>w <Esc>:!wc -w %<CR>

" Copy buffer to clipbard
"" map <something>	<Esc>:%y*<CR>

" Tail: reload buffer from disk and go to end
" FIXME: find a non-conflicting binding
nnoremap <silent> <S-k> <Esc>:e<CR><Esc>:$<CR>

" Save Session: (verify cwd to not stomp on existing sessions)
nnoremap SS <Esc>:w<CR><Esc>:SessionSave<CR><Esc>:call FixSession()<CR><Esc>:SessionOpenLast<CR><Esc>:echo "Saved fixed session: " . v:this_session<CR>

" Misc:
nnoremap <silent> <Leader>] :NERDTreeToggle<CR>
" nnoremap <silent> <Leader>[ :TMiniBufExplorer<CR>

" Folds:
nmap <silent> <Leader>= <Esc>:call FoldDefaultNodes()<CR>:normal zvzkzjzt<CR><C-l>
nmap <silent> <Leader>0 <Esc>:silent normal zvzt<CR><C-l>

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
	au! CmdwinEnter *
	au CmdwinEnter * map <buffer> <C-y> <C-c><CR>q:
	au CmdwinEnter * map <buffer> ZZ <C-c><C-c>
augroup END

" Learn your hjkl!
nnoremap <Left> 	<Esc>:echo "You should have typed h instead"<CR>
nnoremap <Right> 	<Esc>:echo "You should have typed l instead"<CR>
nnoremap <Up> 		<Esc>:echo "You should have typed k instead"<CR>
nnoremap <Down> 	<Esc>:echo "You should have typed j instead"<CR>

" Accordion Mode: accordion style horizontal split navigation mode
nmap <silent> <C-j> <C-w>j:call AccordionMode()<CR><C-l>
nmap <silent> <C-k> <C-w>k:call AccordionMode()<CR><C-l>
nmap <silent> <C-y> <C-w>h:call AccordionMode()<CR><C-l>
nmap <silent> <C-h> <C-w>l:call AccordionMode()<CR><C-l>
nmap <silent> <C--> :call AccordionMode()<CR><C-l>
function! AccordionMode()
	set winminheight=0 winheight=9999
	set winheight=10 winminheight=10
endfunction

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


function! FindNode(label) "{{{
	let s:openmarker = FoldOpenMarker()
	let s:expression = a:label . "\\s*" . s:openmarker
	let s:matchline = search(s:expression, 'csw')	
    echo printf("line: %2s had expression: %s", s:matchline, s:expression)
	return s:matchline
endfunction

" }}}
function! OpenNode(label) "{{{
	let s:nodefound = FindNode(a:label)
	if s:nodefound
		normal zv
		return 1
	endif
	return 0
endfunction

"}}}
function! CloseNode(label) "{{{
	let s:nodefound = FindNode(a:label)
	if s:nodefound
		normal zc
		return 1
	endif
	return 0
endfunction

"}}}
function! InsertNode(label) "{{{
	let s:origpos = getpos(".")
	call append(line(".") - 1, [""])
	normal k
	call AppendText(a:label)
	call FoldWrap()
	call OpenNode(a:label)
	call setpos('.', s:origpos)
endfunction

"}}}
function! DateNode() "{{{
	let s:currentdate = TimestampText('date')
	if FindNode(s:currentdate) == 0
		normal gg
        let s:openmarker = FoldOpenMarker()
		call FindNode('[0-9]\{,4}-[0-9]\{,2}-[0-9]\{,2}')
		call append(line(".") - 1, [""])
		normal k
		call AppendText(s:currentdate)
		call FoldWrap()
        normal zM
	endif
	call OpenNode(s:currentdate)
endfunction

"}}}
function! Timestamp(style) "{{{
	call AppendText(TimestampText(a:style) . " ")
endfunction

" }}}
function! TimestampText(style) "{{{
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
	return s:dateformat
endfunction

" }}}
function! AppendText(text) "{{{
	let s:originalline = getline(".")
	call append(line("."),[a:text])
	if substitute(s:originalline, "\\s", "", "g") == ""
		 normal J$
	else
		 normal J$
	endif
endfunction

"}}}
function! InsertItem(text, status) "{{{
	let s:origpos = getpos(".")
	call DateNode()
	normal ]zk
	let s:itemnostatus = substitute(a:text, '^\s*. ', '', 'g')
	let s:result = printf("%s [%s] %s", a:status, TimestampText('short'), s:itemnostatus)
	let s:toappend = [s:result]
	if LineIsWhiteSpace(getline("."))
		call append(line(".") - 1, s:toappend)
	else
		call insert(s:toappend, "", len(s:toappend))
		call append(line("."), s:toappend)
	endif
	call setpos('.', s:origpos)
    normal zodd
endfunction

"}}}
function! LineIsWhiteSpace(line) "{{{
	return a:line =~ '^\s*$'
endfunction

"}}}
function! FoldWrap() "{{{
	" spliting markers here to prevent false markers
	let s:openmarker = FoldOpenMarker()
	let s:closemarker = FoldCloseMarker()
	call append(line("."), [s:openmarker, "", s:closemarker])
	normal Jj
	" startinsert
endfunction

"}}}
function! FoldCommentString() "{{{
	return len(&commentstring) > 0 ? &commentstring : " %s"
endfunction

"}}}
function! FoldOpenMarker() "{{{
	let fcms = FoldCommentString()
	return substitute(fcms, '%s', "{{" ."{", 'g')
endfunction

"}}}
function! FoldCloseMarker() "{{{
	let fcms = FoldCommentString()
	let rawclosemarker = substitute(fcms, '%s', "}}" ."}", 'g')
	return substitute(rawclosemarker, '^\s', '', '') " strip pre-space
endfunction

"}}}
function! FoldInsert() "{{{
	normal O
	call FoldWrap()
endfunction

"}}}
function! FoldUnfolded() " {{{
		silent! normal zc
endfunction

" }}}
function! FoldDefaultNodes() "{{{
	" Save positions
	let s:origpos = getpos(".")
	normal H
	let s:origscroll = getpos(".")
	" Do work
	normal gg
	normal zR
	let s:hasnext = 1
	while (s:hasnext)
		let s:currentline = line(".")
		call FoldNodeIfDefault()
		silent! normal zj
		let s:hasnext = s:currentline != line(".")
	endwhile
	" Restore positions
	call setpos('.', s:origscroll)
	normal zt
	call setpos('.', s:origpos)
endfunction
"}}}
function! FoldNodeIfDefault() "{{{
	let s:isdone = match(getline("."), '^done.* {{') > -1
	let s:hasat = match(getline("."), '^@.* {{') > -1
	let s:allcaps = match(getline("."), '^[A-Z]* {{') > -1
	let s:isrecurring = match(getline("."), '^(.).* {{') > -1
	" echo printf("isdone: %s, hasat: %s, allcap: %s", s:isdone, s:hasat, s:allcaps)
	if (s:hasat)
		return	
	endif
	if (s:isrecurring)
		return
	endif
	if (s:allcaps)
		return
	endif
	if (s:isdone)
	endif
	normal zc
endfunction

"}}}
function! HandleTS() " {{{
  let s:ticket = matchstr(getline("."), 'TS#[0-9]\+')
  let s:number = matchstr(s:ticket, '[0-9]\+')
  if s:ticket != "<Esc>:"
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
  let s:uri = matchstr(getline("."), '\cselect .*')
  if s:uri != ""
	  let @a = s:uri
	  call ScratchBuffer("sql statement")
	  setlocal bufhidden=delete
	  normal "ap
	  set ft=sql
	  for keyword in ["select", "from", "and", "inner", "where", "left", "right", "union", "group by", "order by"]
		  exec "silent! %s/" . keyword . "/\r&/gi"
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
function! AutoTagComplete() " {{{
	normal aa
	normal! r>
	let l:save_position = getpos(".")
	exe "normal i\<C-g>u"
	let [l:ignore, l:close_tag_pos] = searchpos("</\\zs\\S\\+", "bnW", line(".")) 
	let [l:ignore, l:open_tag_pos] = searchpos("<[^/]\\zs[^[:space:]>]\\+", "bcW", line(".")) 
	if l:open_tag_pos == 0 || l:open_tag_pos < l:close_tag_pos
		call setpos('.', l:save_position)
	else
		normal yiw
		call setpos('.', l:save_position)
		normal a</
		normal p
		normal aa
		normal! r>
		call search("<", "bW", line(".")) 
	endif
	if l:save_position[2] == len(getline("."))
		startinsert!
	else
		startinsert
	endif
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

" Taskstack:
augroup TaskStack
	au! BufRead *.tst.* set indentkeys-=o indentkeys-=0 showbreak=\ \  filetype=_.tst.txt
	au BufRead *.tst.* nnoremap <buffer> XX :silent! call InsertItem(getline("."), "x")<CR>
	au BufRead *.tst.* imap <buffer> XX <Esc>XX
	au BufRead *.tst.* nnoremap <buffer> QQ :silent! call InsertItem(getline("."), "o")<CR>
	au BufRead *.tst.* imap <buffer> QQ <Esc>QQ
	au BufRead *.tst.* nnoremap <buffer> NN ggzoo-<Esc>a 
	au BufRead *.tst.* imap <buffer> NN <Esc>NN
	au BufRead *.tst.* nnoremap <buffer> ZZ :maca hide:<CR>
	au BufRead *.tst.* imap <buffer> ZZ <Esc>ZZ
	au BufRead *.tst.* nnoremap <buffer> LL :silent! call FindNode("SCRATCH")<CR>zo]zO
	au BufRead *.tst.* nmap <buffer> <C-j> ddp
	au BufRead *.tst.* nmap <buffer> <C-k> ddkP
	au! FocusLost *.tst.* write
augroup END

" autocomplete tags in html
au! FileType xhtml imap <buffer> > <Esc>:call AutoTagComplete()<CR>

" python syntax
let python_highlight_all = 1

" minbufexplorer
let g:miniBufExplVSplit=30
let g:miniBufExplMaxSize = 50
let g:miniBufExplMapCTabSwitchBufs = 1

" sessionmanager:
"
" BufExplorer:
map <silent> <C-Tab> :BufExplorer<CR>j
map <silent> <C-S-Tab> :BufExplorer<CR>k
au! BufWinEnter \[BufExplorer\] map <buffer> <Tab> <CR>
au BufWinEnter \[BufExplorer\] set updatetime=500
au! CursorHold \[BufExplorer\] normal y
" au BufWinEnter \[BufExplorer\]

" Pydiction:
let g:pydiction_location = '~/.vim/complete-dict'

" Paster:
let g:PASTER_BROWSER_COMMAND = 'open'

" Rope:
" let $PYTHONPATH .= ":/Library/Python/2.5/site-packages/ropemode:/Library/Python/2.5/site-packages:/Users/seth/sandbox/code/python/"
" source ~/sandbox/code/python/ropevim/ropevim.vim
let $PATH .= ';C:\Python24\'
let $PYTHONPATH = 'C:\Python24\'

" SnipMate:
let g:snips_author = 'Seth Milliken'
map <silent> <Leader>snip <Esc>:call ResetSnippets() \| call GetSnippets(g:snippets_dir, &ft)<CR><Esc>:echo "Snippets for format \"" . &ft . "\" updated."<CR>

" Vimwiki:
map <silent> <Leader>w2 <Esc>:w<CR>:VimwikiAll2HTML<CR><Esc>:echo "Saved wiki to HTML."<CR>
let g:vimwiki_hl_headers = 1 				" hilight header colors
let g:vimwiki_hl_cb_checked = 1 			" hilight todo item colors
let g:vimwiki_list_ignore_newline = 0 		" convert newlines to <br /> in list
let g:vimwiki_list = [{'path': '~/sandbox/personal/vimwiki/', 'index': 'PersonalWiki'}, {'path': '~/sandbox/public/wiki', 'index': 'SethMilliken'}, {'path': '~/sandbox/work/wiki/', 'index': 'SethMilliken', 'html_header': '~/sandbox/work/wiki/header.tpl'}]

" 2html.vim
let html_dynamic_folds = 1
let html_use_css = 1
let html_number_lines = 1
let use_xhtml = 1

" }}}
" TESTING: {{{

" set ff=unix
" let string="!echo 'bar' | ls"
" let mapleader=","

" }}}
" vim: set ft=vim fdm=marker tw=80 cms=\ \"\ %s  :
