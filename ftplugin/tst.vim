" INFO: {{{

" Maintainer:
" 	Seth Milliken <seth_vim@araxia.net>
" 	Araxia on #vim irc.freenode.net

" Version:
" 0.1 " 2010-09-06 05:04:26 EDT

" Notes:

" Todo:

"}}}
" VARIABLES: {{{
let s:main_node_name = "DOING"
let s:groups_node_name = "PROJECTS"
let s:notes_node_name = "SCRATCH"

let s:aborted_prefix = "x"
let s:completed_prefix = "o"

"}}}
" SYNTAX: {{{

"}}}
" FUNCTIONS: {{{

" Fold prototype " {{{
let s:Fold = {}
" functions 
function! s:Fold.locate() "{{{
		let l:openmarker = CommentedFoldMarkerOpen()
		let l:expression = self.header . "\\s*" . l:openmarker
		let self.topline = search(l:expression, 'csw')
		let l:foo = input("Currentb: ", self.topline . " " . self.header)
		return self.topline
endfunction

" }}}
" constructor
function! s:Fold.New(header) " {{{
		let newFold = copy(self)
		let newFold.header = a:header  
		let newFold.upperpeer = []
		let newFold.lowerpeer = []
		let newFold.topline = -1
		let newFold.bottomline = -1
		return newFold
endfunction " }}}
function! s:Fold.calculateBottom() " {{{
		let l:place = self.locate()
		let l:foo = input("Currentb: ", self.topline . " " . self.header)
		redraw
		let l:loop = 0
		let l:foldCounter = 0
		let l:foo = input("Currenta: ", self.header. " " . l:foldCounter . " " . foldclosedend(self.topline))
		while foldclosedend(self.topline) > -1
				let l:loop += 1
				normal zo
				let l:foldCounter += 1
				redraw
		endwhile
		normal zc
		let self.bottomline = foldclosedend(self.topline)
		if l:loop == 0
				let l:foo = input("Current: ", l:foldCounter)
				normal zo
		end	
		while l:foldCounter > 0
				normal zc
				let l:foldCounter -= 1
		endwhile
		return self
endfunction " }}}
function! s:Fold.setHeader(argument) " {{{
		call add(self.header, a:argument)
		call self.locate()
endfunction " }}}
function! s:Fold.setUpperPeer(argument) " {{{
		call add(self.upperpeer, a:argument)
endfunction " }}}
function! s:Fold.setLowerPeer(argument) " {{{
		call add(self.lowerpeer, a:argument)
endfunction " }}}
function! s:Fold.name() " {{{
		echo "My name is: " . self.header . " I think I start at " . string(self.topline) . " and end at " . string(self.bottomline)
endfunction " }}}

" let myfold = s:Fold.New("test")
"call myfold.calculateBottom()
" call myfold.name()

function! s:Fold.render() " {{{
		if line == 1
				normal O
				normal k
		elseif line == line("$")
				normal o
		end
		exec "normal I" . self.header
endfunction " }}}
" Fold }}}

" Navigation:
function! CreateNodeUnderNodeIfMissing(nodename, previous_node_name) " {{{
	let l:origview = winsaveview()
	if FindNode(a:nodename) == 0
			if a:previous_node_name != ""
					if FindNode(a:previous_node_name) == 0
							call CreateNodeUnderNodeIfMissing(a:previous_node_name, "")
					end
					call FoldUnfolded()
					normal o
			else
					normal ggO
					normal k
			end
			exe "normal I" . a:nodename
			call FoldWrap()
			call FoldUnfolded()
	end
	call winrestview(l:origview)
endfunction

" }}}
function! TaskstackMain() " {{{
	" silent! wincmd t
	if FindNode(s:main_node_name) == 0
		normal gg
		if len(getline(".")) == 0
			call AppendText(s:main_node_name)
		else
			exe "normal O" . s:main_node_name
		end
		call FoldWrap()
	end
	call FindNode(s:main_node_name)
	silent! normal zo
endfunction

" }}}
function! TaskstackGroups() " {{{
	call AutoTimestampBypass() " FIXME: External Dependency
	" silent! wincmd t
	if FindNode(s:groups_node_name) == 0
		call TaskstackMain()
		normal zc
		exe "normal o" . s:groups_node_name
		call FoldWrap()
	end
	call FindNode(s:groups_node_name)
	silent! normal zo
	call AutoTimestampEnable() " FIXME: External Dependency
endfunction

" }}}
function! TaskstackDate() "{{{
	let l:currentdate = TimestampText('date')
	if FindNode(l:currentdate) == 0
		let l:origview = winsaveview()
		if FindNode(s:groups_node_name) != 0
			call TaskstackGroups()
		else
			call TaskstackMain()
		end
		normal ]z
		call append(line("."), [""])
		normal j
		call AppendText(l:currentdate)
		call FoldWrap()
		" normal zMzo
		" silent! call TaskstackMain()
		call winrestview(l:origview)
	endif
	call OpenNode(l:currentdate)
endfunction

"}}}
function! TaskstackScratch() " {{{
	call AutoTimestampBypass() " FIXME: External Dependency
	" silent! wincmd b
	if FindNode(s:notes_node_name) == 0
		exe "normal Go" . s:notes_node_name
		call FoldWrap()
	end
	call FindNode(s:notes_node_name)
	normal zozt]zk
	call AutoTimestampEnable() " FIXME: External Dependency
endfunction

" }}}

" Tasks: change status
function! TaskstackNewItem() " {{{
	call AutoTimestampBypass() " FIXME: External Dependency
	call TaskstackMain()
	exe "normal o-  "
	startinsert
	call AutoTimestampEnable() " FIXME: External Dependency
endfunction

" }}}
function! TaskstackCompleteItem(prefix) " {{{
	call AutoTimestampBypass() " FIXME: External Dependency
	if foldclosed(line(".")) == -1
		silent call MoveItemToDateNode(getline("."), a:prefix)
	else
		echo "Can't yet move a fold."
		" silent call MoveItemToDateNode(getline(foldclosed(line(".")), foldclosedend(line("."))), a:prefix)
	end
	call AutoTimestampEnable() " FIXME: External Dependency
endfunction

" }}}
function! MoveItemToDateNode(text, status) "{{{
	let l:origview = winsaveview()
	call TaskstackDate()
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
	call winrestview(l:origview)
	normal dd
	echo "Item marked as completed and moved."
endfunction

"}}}

" Movement:
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

" Miscellaneous:
function! TaskstackHide() " {{{
	macaction hide:
endfunction

" }}}
function! TaskstackAutosaveReminder() " {{{
	exe ":echo 'Taskstack buffers auto save when you switch away. Use ZZ.'"
	silent write
endfunction

" }}}
function! TaskstackEOL() " {{{
	let l:timestamp_location = match(getline("."), TimestampPattern() . ".*")
	if l:timestamp_location > 0
		call cursor(line("."), l:timestamp_location)
	else
		normal g_
	end
endfunction

" }}}

" }}}
" vim: set ft=vim fdm=marker cms=\ \"\ %s  :
