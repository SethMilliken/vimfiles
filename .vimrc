" INFO: {{{

" Maintainer:
" 	Seth Milliken <seth_vim@araxia.net>
" 	Araxia on #vim irc.freenode.net

" Version:
" 	1.0 " 2010-09-04 08:08:27 EDT

" Notes:
" 	- I'm deliberately overloading <C-e> and <C-y> for more useful purposes.
" 	- I try to group distinct features in such a way that I can easily use a simple text-object operation on them (vap, yap, etc.).
" 	- Folds can be quickly selected simply by closing the fold (za) and yanking
" 	the folded line (yy).
"   - #vim conventional wisdom recommends not using real tabs at all, ever (ts=8:sw=4:sts=4). I disagree and find consistent use of real tabs can be very useful.
"   - /^""/ indicate intentionally disabled options

" Todo:
"	- clean up SETTINGS; provide better descriptions 
"	- for clarity, replace abbreviated forms of options in all settings
"	- annotate all line noise, especially statusline
"	- make .vimrc re-source-able without sideeffects (guards around au, maps, etc.)
"	- create keybindings for new location list fold header navigation mechanism
"	- consider: is keeping example .vimrc useful
"	- consider: add tw setting to .vimrc modeline
"	- consider: move ft-specific settings to individual files
"	- consider: :: shortcut worth the : pause? (remember that the pause is essentially only percieved; immediately continuing to type the : command works fine)

"}}}
" DEFAULTS: from example .vimrc {{{
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
" SETTINGS: {{{
set winfixheight
set shortmess+=I 					" don't show intro on start
set shortmess+=A 					" don't show message on existing swapfile
set nospell							" spelling off by default
set spellcapcheck=off				" ignore case in spellcheck
set encoding=UTF-8 					" use UTF-8 encoding
set fileencoding=UTF-8 				" use UTF-8 encoding as default
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
set hlsearch 						" highlight searches
									" set noaw
set nobackup						" don't like ~ files littered about
									" TODO: can these be stored centrally a la swap?
set laststatus=2					" always show the status line
set diffopt+=vertical				" use vertical splits for diff
set splitright						" open vertical splits to the right
set splitbelow						" open horizonal splits below
set winminheight=0 					" minimized horizontal splits show only statusline
set switchbuf=useopen,usetab 		" when switching to a buffer, go to where it's already open
set history=10000					" keep craploads of command history
set undolevels=100					" keep lots of undo history
set foldlevelstart=999   			" don't use a default fold level; all folds open by default
set fdm=marker						" make the default foldmethod markers
set foldcolumn=4					" trying out fold indicator column

" Tags: universal location
set tags+=$HOME/sandbox/personal/tags

" Swap: centralized with unique names via //
set directory=$HOME/.vim/swap//,~/vimfiles/swap//

" Sessionopts: defaults are blank,buffers,curdir,folds,help,options,tabpages,winsize
set ssop=folds,help,options,tabpages,winsize
set ssop+=globals,sesdir,resize,winpos,unix

" Statusline: TODO: annotate this status line
set statusline=%<\(%n\)\ %m%y%r\ %f\ %=%-14.(%l,%c%V%)\ %P

"}}}
" MAPPINGS: {{{
" Zaurus: <C-Space> (<C-k><C-Space>) to invoke command mode in both insert and normal mode
imap <Nul> <Esc>:
nnoremap <Nul> :

"Annoyances: Use my own help function for F1
map <F1> :Help<CR>
imap <F1> <Esc><F1>

nmap <S-Space> <C-f>
nmap :W :w

" Reset: restore some default settings and redraw
nnoremap <silent> <C-L> :call Reset() \| nohls<CR>
imap <silent> <C-L> <Esc>:call Reset() \| nohls<CR>a

" Utility: word count of current file
nmap <silent> <Leader>w <Esc>:!wc -w %<CR>

" Clipboard: Copy buffer to clipboard
" trying 'set clipboard=unnamed' instead; see .gvimrc
"" map <something>	<Esc>:%y*<CR>

" Tail: reload buffer from disk and go to end
" - FIXME: find a non-conflicting binding
" - TODO: restrict to certain filetypes, e.g. only .log?
nmap <silent> <S-k> <Esc>:e<CR><Esc>:$<CR>

" Save Session:
nmap <Leader>\ <Esc>:call CommitSession()<CR>

" Journal:
nmap \j <Esc>:call JournalEntry()<CR>
command! Journal :call JournalEntry()

" Misc:
nmap <silent> <Leader>] :NERDTreeToggle<CR>
" nmap <silent> <Leader>[ :TMiniBufExplorer<CR>

" Folds:
nmap <silent> <Leader>= <Esc>:call FoldDefaultNodes()<CR>:normal zvzkzjzt<CR><C-l>
nmap <silent> <Leader>0 <Esc>:silent normal zvzt<CR><C-l>

" Scratch Buffer: close with ZZ
nmap <silent> <Leader>c <Esc>:call ScratchBuffer("scratch")<CR>

" Open URIs:
nmap <silent> <Leader>/ :call HandleURI()<CR>
nmap <silent> <Leader>t :call HandleTS()<CR>

" SQL: grab and format sql statement from current line
nmap <silent> <Leader>q <Esc>:call FormatSqlStatement()<CR>

" Formatting: Wrap current or immediately preceding word in in <em> tag
nmap <Leader>_ <Esc>Bi<em><Esc>ea</em>

" Completion: show completion preview, without actually completing
imap <C-p> <Esc>:set completeopt+=menuone<CR>a<C-n><C-p>

" Help: help help help
nmap <Leader>hw	 	<Esc>:help<CR>:silent call AdjustFont(-4)<CR>:set columns=115 lines=999<CR>:winc _<CR>:winc \|<CR>:help<Space>
nmap <Leader>pp	 	<Esc>:help<CR><Esc>:winc _<CR><Esc>:winc \|<CR><Esc>:help<Space>
nmap <Leader>po 	<Esc>:Help<CR>
command! Help :call HelpSmart()
function! HelpSmart() " {{{
  let a:additional = ""
  let a:setup = ""
  if expand("%") == ""
      let a:additional = " | only | normal zt"
  elseif &buftype != "help"
      let a:setup = "0tab"
  endif
  let a:command = input("Help topic: ", "", "help")
  exec ":" . a:setup . " help " . a:command . a:additional
endfunction

" }}}

" Navigation: shortcuts
nmap <C-e>n :call SectionHeadNav(1, 0)<CR>
nmap <C-e>N :call SectionHeadNav(1, 1)<CR>
nmap <C-e>p :call SectionHeadNav(-1, 0)<CR>
nmap <C-e>P :call SectionHeadNav(-1, 1)<CR>
function! SectionHeadNav(count, mode) " {{{
	" TODO: mb preserve hls value and restore it?
	if a:count > 0
		let a:searchdirection = "/"
	else
		let a:searchdirection = "?"
	end
	if a:mode > 0
		" Matches ^MAJORHEADER:
		let a:modematch = "[[:upper:][:space:]]\\{1,}:*.*" . FoldMarkerOpen()
	else
		" Matches ^Minorheader:
		let a:modematch = "[[:upper:]]\\{1,}[^:]*:*"
	end
	set nohls
    exec a:searchdirection . "^" .  ExpandedCommentString() . a:modematch
    normal zz
    set hls
endfunction

" }}}

" Cmdline Window: shortcuts
nnoremap :: q:
nnoremap // q/
nnoremap ?? q?

" Cmdline Window:
augroup cmdline-window
	au! CmdwinEnter *
	" Execute the current line in cmndline-window and then reopen it.
	" n.b. Deliberately overloading <C-y> here.
	au CmdwinEnter * map <buffer> <C-y> <C-c><CR>q:
	au CmdwinEnter * inoremap <buffer> <C-y> <Esc><C-y>
	" Quickly close cmdline-window
	au CmdwinEnter * map <buffer> ZZ <C-c><C-c>
	au CmdwinEnter * inoremap <buffer> ZZ <Esc>ZZ
augroup END

" Learn: hjkl
nmap <Left> 	<Esc>:echo "You should have typed h instead."<CR>
nmap <Right> 	<Esc>:echo "You should have typed l instead."<CR>
nmap <Up> 		<Esc>:echo "You should have typed k instead."<CR>
nmap <Down> 	<Esc>:echo "You should have typed j instead."<CR>

" Accordion Mode: accordion style horizontal split navigation mode
" yes, kids, I know WTF I'm doing WRT <C-e>
nmap <silent> <C-e>j <C-w>j:call AccordionMode()<CR><C-l>
nmap <silent> <C-e>k <C-w>k:call AccordionMode()<CR><C-l>
nmap <silent> <C-e>h <C-w>h:call AccordionMode()<CR><C-l>
nmap <silent> <C-e>l <C-w>l:call AccordionMode()<CR><C-l>
nmap <silent> <C-e>- :call AccordionMode()<CR><C-l>
nnoremap <silent> <C-e><C-e> <C-e>
function! AccordionMode()
	set winminheight=0 winheight=9999
	set winheight=10 winminheight=10
endfunction

" Timestamps: {{{
let g:timestamp_matchstring = '[0-9]\\{4}-[0-9]\\{2}-[0-9]\\{2} [0-9:]\\{8} [A-Z]\\{3}'
let g:timestamp_annotation = ' MARK'
" yes, kids, I know WTF I'm doing WRT <C-y>
nmap <silent> <C-y><C-y> :call AddOrUpdateTimestamp("")<CR>
imap <silent> <C-y><C-y> <Esc>:call AddOrUpdateTimestamp("")<CR>a
nmap <silent> <C-y><C-x> :call RemoveTimestamp("")<CR>
imap <silent> <C-y><C-x> <Esc>:call RemoveTimestamp("")<CR>a
nmap <silent> <C-y><C-h> :call AddOrUpdateTimestamp(g:timestamp_annotation)<CR>
nmap <silent> <C-y><C-n> :call RemoveTimestamp(g:timestamp_annotation)<CR>
nmap <silent> <Leader>sd :call Timestamp("date")<CR>
nmap <silent> <Leader>sl :call Timestamp("long")<CR>
nmap <silent> <Leader>fw :call FoldWrap()<CR>
nmap <silent> <Leader>fi :call FoldInsert()<CR>
nmap <silent> <Leader>ll o<Esc>:call Timestamp("short") \| call FoldWrap()<CR>
" }}}

" Tabs: switching
" set Cmd-# and Alt-# to switch tabs {{{
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

" Navigation:
function! EscapeShiftUp(incoming) " {{{
	return substitute(a:incoming, "\\", "\\\\\\\\", "g")
endfunction
" }}}
function! HeaderLocationIndex() "{{{
	let l:incoming = input("Go To Header: ")
	lgetexpr "" " Clear the location list
	exe "set errorformat=%l:%f:%m"
	let l:rawcommentstring = '\" '
	exe "let l:commentstring = " .  EscapeShiftUp("l:rawcommentstring")
	let l:rawexpression = '\\(.*' . l:incoming . '\\c.*\\) ' . FoldMarkerOpen()
	" let l:rawexpression = '\\([ [:upper:]]*\\) ' . FoldMarkerOpen() " MAJOR header
	" let l:rawexpression = '\\([ [:alpha:]]*\\) ' . FoldMarkerOpen() " Minor header
	let l:expression = l:commentstring . l:rawexpression
	let l:searchexpression = substitute(l:expression, "\\\\\\{1,}", "\\", "g")
	let l:matchstring = "substitute(getline(\".\")" . ", \"" . l:expression . "\", \"\\\\1\"" . ", \"\")"
	let l:line = "line(\".\")"
	let l:filename = "expand(\"%:f\")"
	let l:commandword = "laddexpr"
	" let l:commandword = "echo"
	let l:gmatch = "g/^" . l:searchexpression . "/" . l:commandword . " " . l:line . " . \":\" . " .  l:filename . " . \":\" ." . l:matchstring
	" echo "Match string: " . l:gmatch
	exec l:gmatch
	nohls
	let l:locresults = getloclist("0")
	if len(l:locresults) > 1
		vert lop | wincmd =
	end
endfunction

"}}}

" Text: tools
function! AppendText(text) "{{{
	let l:originalline = getline(".")
	call append(line("."),[a:text])
	if substitute(l:originalline, "\\s", "", "g") == ""
		 normal J$
	else
		 normal J$
	endif
endfunction

"}}}
function! LineIsWhiteSpace(line) "{{{
	return a:line =~ '^\s*$'
endfunction

"}}}
function! Strip(string) "{{{
	return StripFront(StripEnd(a:string))
endfunction

"}}}
function! StripEnd(string) "{{{
	return substitute(a:string, "[[:space:]]*$", "", "")
endfunction

"}}}
function! StripFront(string) "{{{
	return substitute(a:string, "^[[:space:]]*", "", "")
endfunction

"}}}

" Folds: manipulation
function! FindNode(label) "{{{
	let l:openmarker = CommentedFoldMarkerOpen()
	let l:expression = a:label . "\\s*" . l:openmarker
	let l:matchline = search(l:expression, 'csw')	
    "echo printf("line: %2s had expression: %s", l:matchline, l:expression)
	return l:matchline
endfunction

" }}}
function! OpenNode(label) "{{{
	let l:nodefound = FindNode(a:label)
	if l:nodefound
		normal zv
		return 1
	endif
	return 0
endfunction

"}}}
function! CloseNode(label) "{{{
	let l:nodefound = FindNode(a:label)
	if l:nodefound
		normal zc
		return 1
	endif
	return 0
endfunction

"}}}
function! InsertNode(label) "{{{
	let l:origpos = getpos(".")
	call append(line(".") - 1, [""])
	normal k
	call AppendText(a:label)
	call FoldWrap()
	call OpenNode(a:label)
	call setpos('.', l:origpos)
endfunction

"}}}
function! DateNode() "{{{
	let l:currentdate = TimestampText('date')
	if FindNode(l:currentdate) == 0
		silent! call TaskstackScratch()
		silent! call TaskstackMain()
		normal zj
		call append(line(".")- 1, [""])
		normal k
		call AppendText(l:currentdate)
		call FoldWrap()
		normal zMzo
		silent! call TaskstackMain()
	endif
	call OpenNode(l:currentdate)
endfunction

"}}}
function! InsertItem(text, status) "{{{
	let l:origpos = getpos(".")
	call DateNode()
	normal ]zk
	let l:itemnostatus = substitute(a:text, '^\s*. ', '', 'g')
	let l:result = printf("%s [%s] %s", a:status, TimestampText('short'), l:itemnostatus)
	let l:toappend = [l:result]
	if LineIsWhiteSpace(getline("."))
		call append(line(".") - 1, l:toappend)
	else
		call insert(l:toappend, "", len(l:toappend))
		call append(line("."), l:toappend)
	endif
	call setpos('.', l:origpos)
    normal zodd
endfunction

"}}}
function! FoldWrap() "{{{
	" appending closemarker first to prevent ruining current folds
	call append(line("."), CommentedFoldMarkerClose())
	call append(line("."), [CommentedFoldMarkerOpen(), ""])
	normal Jj
endfunction

"}}}
function! FoldMarkerOpen() "{{{
	return substitute(&foldmarker, ",.*", "", "")
endfunction

"}}}
function! FoldMarkerClose() "{{{
	return substitute(&foldmarker, ".*,", "", "")
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
	let l:origpos = getpos(".")
	normal H
	let l:origscroll = getpos(".")
	" Do work
	normal gg
	normal zR
	let l:hasnext = 1
	while (l:hasnext)
		let l:currentline = line(".")
		call FoldNodeIfDefault()
		silent! normal zj
		let l:hasnext = l:currentline != line(".")
	endwhile
	" Restore positions
	call setpos('.', l:origscroll)
	normal zt
	call setpos('.', l:origpos)
endfunction
"}}}
function! FoldNodeIfDefault() "{{{
	let l:isdone = match(getline("."), '^done.* {{') > -1
	let l:hasat = match(getline("."), '^@.* {{') > -1
	let l:allcaps = match(getline("."), '^[A-Z]* {{') > -1
	let l:isrecurring = match(getline("."), '^(.).* {{') > -1
	" echo printf("isdone: %s, hasat: %s, allcap: %s", l:isdone, l:hasat, l:allcaps)
	if (l:hasat)
		return	
	endif
	if (l:isrecurring)
		return
	endif
	if (l:allcaps)
		return
	endif
	if (l:isdone)
	endif
	normal zc
endfunction

"}}}
function! CommentedFoldMarkerOpen() "{{{
	let fcms = CommentStringFull()
	return substitute(fcms, '%s', FoldMarkerOpen(), 'g')
endfunction

"}}}
function! CommentedFoldMarkerClose() "{{{
	let fcms = CommentStringFull()
	let rawclosemarker = substitute(fcms, '%s', FoldMarkerClose(), 'g')
	return StripFront(rawclosemarker)
endfunction

"}}}

" Commentmarkers:
function! CommentStringOpen() "{{{
	return substitute(CommentStringFull(), "%s.*", "", "")
endfunction

"}}}
function! CommentStringClose() "{{{
	return substitute(CommentStringFull(), ".*%s", "", "")
endfunction

"}}}
function! ExpandedCommentString() "{{{
	return StripFront(substitute(CommentStringFull(), "%s", "", ""))
endfunction

"}}}
function! CommentStringFull() "{{{
	return len(&commentstring) > 0 ? &commentstring : " %s"
endfunction

"}}}

" Timestamps:
function! Timestamp(style) "{{{
	call AppendText(TimestampText(a:style) . " ")
endfunction

" }}}
function! TimestampText(style) "{{{
	let l:iswindows = has("win16") || has("win32") || has("win64")
	if l:iswindows
		if a:style == "long"
			let l:dateformat = strftime("%#x %H:%M:%S ")
		elseif a:style == "short"
			let l:dateformat = strftime("%Y-%m-%d %H:%M:%S ") 
		endif
		let l:dateformat .= substitute(strftime("%#z"), '[a-z]\+\($\| \)', '', 'g')
	else
		if a:style == "long"
			let l:dateformat = strftime("%Y %b %d %a %X %Z")
		elseif a:style == "journal"
			let l:dateformat = strftime("%A, %B %d, %Y %H:%M:%S %Z")
		elseif a:style == "short"
			let l:dateformat = strftime("%Y-%m-%d %H:%M:%S %Z")
		elseif a:style == "time"
			let l:dateformat = strftime("%H:%M:%S %Z")
		endif
	endif
	if a:style == "date"
		let l:dateformat = strftime("%Y-%m-%d")
	endif
	return l:dateformat
endfunction

" }}}
function! AddOrUpdateTimestamp(annotation) "{{{
	if !exists("g:auto_timestamp_bypass")
		let l:origpos = getpos(".")
		let l:timestampmatch = TimestampTag(a:annotation)
		let l:hastimestamp = match(getline("."), l:timestampmatch)
		let l:newtimestamp = substitute(CommentStringFull(), "%s", TimestampText("short") . a:annotation, "")
		silent! undojoin
		if l:hastimestamp < 0
			call AppendText(l:newtimestamp)
		else
			call setline(".", substitute(getline("."), l:timestampmatch, l:newtimestamp, ""))
		end
		if len(a:annotation) > 1
			write
		end
		call setpos('.', l:origpos)
	end
endfunction

"}}}
function! TimestampTag(annotation) "{{{
	return substitute(CommentStringFull(), "%s", g:timestamp_matchstring . a:annotation, "")
endfunction

"}}}
function! AutoTimestampBypass() " {{{
	let g:auto_timestamp_bypass = ""
endfunction

" }}}
function! AutoTimestampEnable() " {{{
	if exists("g:auto_timestamp_bypass")
		unlet g:auto_timestamp_bypass
	end
endfunction

" }}}
function! RemoveTimestamp(annotation) "{{{
	let l:timestampmatch = substitute(CommentStringFull(), "%s", g:timestamp_matchstring . a:annotation, "")
	call setline(".", substitute(getline("."), l:timestampmatch, "", ""))
endfunction

"}}}

" Sessions:
function! FixSession() " {{{
  exe "vsplit " . v:this_session
  exe "%s/^edit /buffer /ge"
  write
  close
endfunction

" }}}
function! CommitSession() " {{{
	try
		silent write
		if exists('g:LAST_SESSION')
			silent SessionSave
			silent call FixSession()
			redraw
			echo "Saved repaired session: " . v:this_session
		else
			echo "No active session."
		end
	catch
		redraw
		echo "Error committing session: " . v:this_session
	endtry
endfunction

" }}}

" Specialized:
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
function! JournalEntry() " {{{
	let l:journaldir = $HOME . "/sandbox/personal/zaurus/zlog/"
	let l:currentdate = TimestampText('date')
	let l:entry = l:journaldir . l:currentdate . ".txt"
	let l:entryexists = filereadable(l:entry)
	exec "edit " . l:entry
	exec "lcd " . l:journaldir
	if l:entryexists
		normal Go
		normal o
		exec "call setline(\".\", \"" . TimestampText('time') . "\")" 
	else
		exec "call setline(\".\", \"" . TimestampText('journal') . "\")" 
		exec "silent !svn add " . l:entry
	endif
	normal o
endfunction

" }}}
function! ScratchBuffer(title) " {{{
	  exec "tabe " . a:title . " | setlocal buftype=nofile | setlocal bufhidden=hide | setlocal noswapfile"
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
function! HandleTS() " {{{
  let l:ticket = matchstr(getline("."), 'TS#[0-9]\+')
  let l:number = matchstr(l:ticket, '[0-9]\+')
  if l:ticket != "<Esc>:"
	let l:tsuri = 'http://trackstudio.nimblefish.com/task/' . l:number . '?thisframe=true'
	exec "silent !start rundll32.exe url.dll,FileProtocolHandler " . l:tsuri
	echo "Opened Ticket: " . l:number
  else
	  echo "No TS ticket found in line."
  endif
endfunction

" }}}
function! HandleURI() " {{{
  let l:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;]*')
  if l:uri != ""
	  if has("win32")
		  exec "silent !start rundll32.exe url.dll,FileProtocolHandler " . l:uri
	  else
		  exec "silent !open \"" . l:uri . "\""
	  endif
	  echo "Opened URI: " . l:uri
  else
	  echo "No URI found in line."
  endif
endfunction

" }}}
function! FormatSqlStatement() " {{{
  3match Todo /select .*/
  let l:uri = matchstr(getline("."), '\cselect .*')
  if l:uri != ""
	  let @a = l:uri
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

" Vimperator:
function! FormFieldArchive() " {{{
	let l:contents = getbufline("%", 1, "$")
	let l:filepath = expand("%")
	let l:filename = expand("%:t:r")
	let l:formfielddir = $HOME . "/sandbox/personal/forms/"
	let l:currentdate = TimestampText('date')
	let l:entry = l:formfielddir . l:currentdate . ".txt"
	let l:entryexists = filereadable(l:entry)
	exec "split " . l:entry
	if l:entryexists
		normal Go
		normal o
		exec "call setline(\".\", \"" . TimestampText('time') . "\")" 
	else
		exec "call setline(\".\", \"" . TimestampText('journal') . "\")" 
		exec "silent !svn add " . l:entry
	endif
	normal o
	exec "call setline(\".\", \"" . l:filename . "\")" 
	normal o
	exec "call setline(\".\", " . string(l:contents) . ")" 
	write
	bd
endfunction

" }}}

"}}}
" SYNTAX: {{{

" Java: " {{{
augroup java
	au BufReadPre *.java setlocal foldmethod=syntax
	au BufReadPre *.java setlocal foldlevelstart=-1
augroup END

" }}}
" SVN: " {{{
augroup svn
	au BufNewFile,BufRead  svn-commit.* setf svn	" handle svn commits
augroup END

" }}}
" Text: " {{{
augroup txt
	au BufNewFile *.txt set fdm=marker
augroup END

" }}}

"}}}
" PLUGINS: {{{

" Taskstack: {{{
augroup TaskStack
	au! BufRead *.tst.* set indentkeys-=o indentkeys-=0 showbreak=\ \  filetype=_.tst.txt noai fdm=marker cms= ts=2
	au BufRead *.tst.* nmap <buffer> $ :call TaskstackEOL()<CR>
	au BufRead *.tst.* nmap <buffer> XX :call TaskstackAbortItem()<CR>
	au BufRead *.tst.* imap <buffer> XX <C-c>:call TaskstackAbortItem()<CR>
	au BufRead *.tst.* nmap <buffer> QQ :call TaskstackCompleteItem()<CR>
	au BufRead *.tst.* imap <buffer> QQ <C-c>:call TaskstackCompleteItem()<CR>
	au BufRead *.tst.* nmap <buffer> NN :call TaskstackNewItem()<CR>
	au BufRead *.tst.* imap <buffer> NN <C-c>:call TaskstackNewItem()<CR>
	au BufRead *.tst.* nmap <buffer> ZZ :call TaskstackHide()<CR>
	au BufRead *.tst.* imap <buffer> ZZ <C-c>:call TaskstackHide()<CR>
	au BufRead *.tst.* nmap <buffer> LL :call TaskstackScratch()<CR>
	au BufRead *.tst.* nmap <buffer> <C-j> :call TaskstackMoveItemDown()<CR>
	au BufRead *.tst.* nmap <buffer> <C-k> :call TaskstackMoveItemUp()<CR>
	au BufRead *.tst.* nmap <buffer> :w<CR> :call TaskstackAutosaveReminder()<CR>
	" Use <C-c> to avoid adding or updating a timestamp after editing.
	au! InsertLeave *.tst.* :call AddOrUpdateTimestamp("")
    au! FocusLost *.tst.* write
augroup END

function! TaskstackEOL() " {{{
	let l:timestamp_location = match(getline("."), TimestampTag("") . ".*")
	if l:timestamp_location > 0
		call cursor(line("."), l:timestamp_location)
	end
endfunction

" }}}
function! TaskstackMain() " {{{
	silent! wincmd t
	if FindNode("DOING") == 0
		exe "normal ggO" . "DOING"
		call FoldWrap()
	end
	call FindNode("DOING")
	silent! normal zo
endfunction

" }}}
function! TaskstackNewItem() " {{{
	call AutoTimestampBypass()
	call TaskstackMain()
	exe "normal o-  "
	startinsert
	call AutoTimestampEnable()
endfunction

" }}}
function! TaskstackCompleteItem() " {{{
	call AutoTimestampBypass()
	silent! call InsertItem(getline("."), "o")
	call AutoTimestampEnable()
endfunction

" }}}
function! TaskstackAbortItem() " {{{
	call AutoTimestampBypass()
	silent! call InsertItem(getline("."), "x")
	call AutoTimestampEnable()
endfunction

" }}}
function! TaskstackScratch() " {{{
	call AutoTimestampBypass()
	silent! wincmd b
	if FindNode("SCRATCH") == 0
		exe "normal Go" . "SCRATCH"
		call FoldWrap()
	end
	call FindNode("SCRATCH")
	normal zozt]zk
	call AutoTimestampEnable()
endfunction

" }}}
function! TaskstackMoveItemDown() " {{{
	normal ddp
endfunction

" }}}
function! TaskstackMoveItemUp() range " {{{
	let l:motion = a:lastline - a:firstline
	if line(".") != 1
		normal dd
		if (l:motion > 0)
			exe "normal " . l:motion . "k"
		end
		normal k
		normal P
	end
endfunction

" }}}
function! TaskstackHide() " {{{
	macaction hide:
endfunction

" }}}
function! TaskstackAutosaveReminder() " {{{
	exe ":echo 'Taskstack buffers auto save when you switch away. Use ZZ.'"
	silent write
endfunction

" }}}

" }}}
" Vimperator: " {{{
augroup Vimperator
	au! BufRead vimperator-* nmap <buffer> ZZ :call FormFieldArchive() \| :silent write \| :bd \| :macaction hide:<CR>
	au BufRead vimperator-* imap <buffer> ZZ <Esc>ZZ
augroup END

" }}}
" Crontab: " {{{
augroup crontab
	au! BufRead crontab.* set nowritebackup
	au BufRead crontab.* set filetype=crontab
augroup END

" }}}
" Cocoa: " {{{
augroup Cocoa
	au BufRead *.[mh] nmap <buffer> <d-1> :ListMethods<CR>
augroup END

" }}}
" Html: autocomplete tags " {{{
au! FileType xhtml inoremap <buffer> > <Esc>:call AutoTagComplete()<CR>

" }}}
" Python Syntax: " {{{
let python_highlight_all = 1

" }}}
" HTML: " {{{
let g:no_html_tab_mapping=1
let g:no_html_toolbar=1

" }}}
" Minbufexplorer: " {{{
let g:miniBufExplVSplit=30
let g:miniBufExplMaxSize = 50
let g:miniBufExplMapCTabSwitchBufs = 1

" }}}
" Sessionman: " {{{
let g:sessionman_save_on_exit = 0

" }}}
" BufExplorer: " {{{
map <silent> <C-Tab> :BufExplorer<CR>j
map <silent> <C-S-Tab> :BufExplorer<CR>k
augroup BufExplorerAdd
	if !exists("g:BufExploreAdd")
		let g:BufExploreAdd = 1
		au BufWinEnter \[BufExplorer\] map <buffer> <Tab> <CR>
		" FIXME: Subsequent invocations fail with this autoselect for some reason.
		" Navigate to the file under the cursor when you let go of Tab
		"au BufWinEnter \[BufExplorer\] set updatetime=1000
		" o is the BufExplorer command to select a file
		"au! CursorHold \[BufExplorer\] normal o 
	endif	
augroup END

" }}}
" Pydiction: " {{{
let g:pydiction_location = '~/.vim/complete-dict'

" }}}
" Paster: " {{{
let g:PASTER_BROWSER_COMMAND = 'open'

" }}}
" Rope: " {{{
"" let $PYTHONPATH .= ":/Library/Python/2.5/site-packages/ropemode:/Library/Python/2.5/site-packages:/Users/seth/sandbox/code/python/"
"" source ~/sandbox/code/python/ropevim/ropevim.vim
let $PATH .= ';C:\Python24\'
let $PYTHONPATH = 'C:\Python24\'

" }}}
" SnipMate: " {{{
let g:snips_author = 'Seth Milliken'
map <silent> <Leader>snip <Esc>:call ResetSnippets() \| call GetSnippets(g:snippets_dir, "_") \| call GetSnippets(g:snippets_dir, &ft)<CR><Esc>:echo "Snippets for format \"" . &ft . "\" updated."<CR>

" }}}
" Vimwiki: " {{{
map <silent> <Leader>w2 <Esc>:w<CR>:VimwikiAll2HTML<CR><Esc>:echo "Saved wiki to HTML."<CR>
"" let wiki.nested_syntaxes = {'python': 'python'}
let g:vimwiki_hl_headers = 1 				" hilight header colors
let g:vimwiki_hl_cb_checked = 1 			" hilight todo item colors
let g:vimwiki_list_ignore_newline = 0 		" convert newlines to <br /> in list
let g:vimwiki_folding = 0                   " don't allow outline folding
let g:vimwiki_fold_lists = 0                " don't allow folding of list subitems
let g:vimwiki_list = [{'path': '~/sandbox/personal/vimwiki/', 'index': 'PersonalWiki'}, {'path': '~/sandbox/public/wiki', 'index': 'SethMilliken', 'auto_export': 1}, {'path': '~/sandbox/work/wiki/', 'index': 'SethMilliken', 'html_header': '~/sandbox/work/wiki/header.tpl', 'auto_export': 1}]

" }}}
" TOhtml: " {{{
let html_dynamic_folds = 1
let html_use_css = 1
let html_number_lines = 1
let use_xhtml = 1
"" unlet html_no_foldcolumn
"" unlet html_hover_unfold
let html_no_pre = 1

" }}}
" AppleScript: " {{{
au! BufNewFile,BufRead *.applescript   setf applescript

" }}}

" }}}
" EXPERIMENT: {{{

" type number then : to get relative range prepopulated in cmdline
" new vocab word "idem" to get relative range prepopulated in cmdline
" . as range, e.g. :.w >> foo
" can @ take a range?

" :help local-additions
" :help guioptions

" :options
" :runtime syntax/colortest.vim
" :file
" :diffpatch
" :set ff=unix
" :let string="!echo 'bar' | ls"
" :let mapleader=","

" }}}
" vim: set ft=vim fdm=marker cms=\ \"\ %s  :
