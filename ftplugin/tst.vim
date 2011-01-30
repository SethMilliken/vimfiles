" INFO: " {{{

" Maintainer:
" 	Seth Milliken <seth_vim@araxia.net>
" 	Araxia on #vim irc.freenode.net

" Version:
" 0.1 " 2010-09-06 05:04:26 EDT

" Notes:

" Todo:

"}}}
" VARIABLES: " {{{
let s:main_node_name = "DOING"
let s:groups_node_name = "PROJECTS"
let s:completed_node_name = "COMPLETED"
let s:dates_node_name = "DATES"
let s:notes_node_name = "SCRATCH"

let s:aborted_prefix = "x"
let s:completed_prefix = "o"

"}}}
" SYNTAX: " {{{

"}}}
" FUNCTIONS: " {{{

" STATEINFO OBJECT: v0.2 " {{{
let g:stateinfo = {
                \ 'view':'myviewhere',
                \ 'winsaveview': {},
                \ 'getpos': []
                \ }
function stateinfo.New(...) dict " {{{
    let l:new = copy(self)
    if len(a:000) == 1
        let initial_funct = a:000[0]
        exec "call l:new." . initial_funct . "()"
    endif
    return l:new
endfunction

" }}}
function stateinfo.value() dict " {{{
    return string(self)
endfunction

" }}}
function stateinfo.foldsave() dict " {{{
    let b:original_vop = &vop
    exec "let b:viewfile = " . "\"" . &viewdir . "/foldsave.vim" . "\""
    echo b:viewfile
    set vop=folds,cursor
    " ,options,cursor
    exec "mkview! " . b:viewfile
    call self._fixview()
endfunction

" }}}
function stateinfo.foldrest() dict " {{{
    if exists("b:original_vop") && exists("b:viewfile")
        exec "source " . b:viewfile
        exec "set vop=" . b:original_vop
        unlet b:original_vop
        "unlet b:viewfile
    endif
endfunction

" }}}
function stateinfo._fixview() dict " {{{
  exe "vsplit " . b:viewfile
  exe "%s/^edit /buffer /ge"
  exe "g/SessionLoadPost/d"
  silent write
  close
endfunction

" }}}
function stateinfo.winsave() dict " {{{
    let self['winsaveview'] = winsaveview()
endfunction

" }}}
function stateinfo.winrest() dict " {{{
    if !empty(self['winsaveview']) && type(self['winsaveview']) == type({})
        exec "call winrestview(" . string(self['winsaveview']) . ")"
    endif
endfunction

" }}}
function stateinfo.possave() dict " {{{
    if !empty(self['getpos'])
        exec "set setpos(\".\"" . self['getpos'] . ")"
    endif
endfunction

" }}}
function stateinfo.posrest() dict " {{{
    let self['getpos'] = getpos(line("."))
endfunction

" }}}

" }}}
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
function! TaskstackCompleted() " {{{
	call AutoTimestampBypass() " FIXME: External Dependency
	" silent! wincmd t
	if FindNode(s:completed_node_name) == 0
		call TaskstackMain()
		normal zc
		exe "normal o" . s:completed_node_name
		call FoldWrap()
	end
	call FindNode(s:completed_node_name)
	silent! normal zo
	call AutoTimestampEnable() " FIXME: External Dependency
endfunction

" }}}
function! TaskstackDates() " {{{
	call AutoTimestampBypass() " FIXME: External Dependency
	" silent! wincmd t
	if FindNode(s:dates_node_name) == 0
		call TaskstackCompleted()
		normal zo
		exe "normal o" . s:dates_node_name
		call FoldWrap()
	end
	call FindNode(s:dates_node_name)
	silent! normal zo
	call AutoTimestampEnable() " FIXME: External Dependency
endfunction

" }}}
function! TaskstackDate() "{{{
	let l:currentdate = TimestampText('date')
	if FindNode(l:currentdate) == 0
		let l:origview = winsaveview()
                call TaskstackDates()
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
	exe "normal o- "
	startinsert!
	call AutoTimestampEnable() " FIXME: External Dependency
endfunction

" }}}
function! TaskstackCompleteItem(prefix) " {{{
	call AutoTimestampBypass() " FIXME: External Dependency

	if empty(TaskstackFoldbounds())
		silent call MoveItemToDateNode(getline("."), a:prefix)
	else
		silent call MoveFoldToDateNode(TaskstackFoldbounds(), a:prefix)
	end
	call AutoTimestampEnable() " FIXME: External Dependency
	echo ""
endfunction

" }}}
function! DetectEnclosingProjectName(line) " {{{
    let l:origview = winsaveview()
    exec "normal " a:line . "G"
    let result = ""
    let iterations = foldlevel(line("."))
    let currentiteration = 0
    let initial_fold_was_opened = 0
    if foldclosed(line(".")) == -1 | let initial_fold_was_opened = 1 | end
    while currentiteration < iterations
        exec "normal zc"
        let projectname = TaskstackDetectProjectName(foldclosed(line(".")))
        if projectname != ""
            let result = projectname
            break
        end
        let currentiteration += 1
    endwhile
    while currentiteration > -1
        exec "normal zo"
        let currentiteration -= 1
    endwhile
    if initial_fold_was_opened == 1 | exec "normal zo" | end
    call winrestview(l:origview)
    return result
endfunction

"}}}
function! TaskstackFoldbounds() " {{{
    let result = []
    if foldlevel(line(".")) > 0
        let fold_was_open = 0
        if foldclosed(line(".")) == -1 | let fold_was_open = 1 | exec "normal zc" | end
        let original_line = line(".")
        if foldclosed(line(".")) == original_line
            let result = [foldclosed(line(".")),foldclosedend(line("."))]
        endif
        if fold_was_open == 1 | exec "normal zo" | end
    endif
    return result
endfunction

" }}}
function! CompleteFoldedItems(foldbounds, status) "{{{
    let start = a:foldbounds[0] + 1
    let end = a:foldbounds[1] - 1
    let lines = getline(start, end)
    let linenumber = start
    for line in lines
	let l:itemnostatus = substitute(line, '^\s*. ', '', 'g')
	let l:result = printf("%s %s", a:status, l:itemnostatus)
        call setline(linenumber, l:result)
        let linenumber += 1
    endfor
endfunction
    
" }}}
function! MoveFoldToDateNode(foldbounds, status) "{{{
        let l:state = g:stateinfo.New('foldsave')
        echo "bounds: " . string(a:foldbounds) . " status: " . a:status
	call TaskstackDate()
        let moveto_line = line(".")
        let mytext = getline(a:foldbounds[0])
	let l:itemnostatus = substitute(mytext, '^\s*. ', '', 'g')
        let l:enclosing_project = DetectEnclosingProjectName(a:foldbounds[0])
        if l:enclosing_project != "" | let l:enclosing_project .= ": " | end
	let l:result = printf("%s [%s] %s%s", a:status, TimestampText('short'), l:enclosing_project, l:itemnostatus)
        call CompleteFoldedItems(a:foldbounds, a:status)
        call setline(a:foldbounds[0], l:result)
        exec ":" . a:foldbounds[0] . "," . a:foldbounds[1] . "m" . moveto_line
        call l:state.foldrest()
	echo "Item marked as completed and moved."
endfunction

"}}}
function! MoveItemToDateNode(text, status) "{{{
        let l:state = g:stateinfo.New('foldsave')
        let l:enclosing_project = "" " DetectEnclosingProjectName()
	call TaskstackDate()
	normal ]zk
        if l:enclosing_project != "" | let l:enclosing_project .= ": " | end
	let l:itemnostatus = substitute(a:text, '^\s*. ', '', 'g')
	let l:result = printf("%s [%s] %s%s", a:status, TimestampText('short'), l:enclosing_project, l:itemnostatus)
	let l:toappend = [l:result]
	if LineIsWhiteSpace(getline("."))
		call append(line(".") - 1, l:toappend)
	else
		call insert(l:toappend, "", len(l:toappend))
		call append(line("."), l:toappend)
	endif
        call l:state.foldrest()
	normal zodd
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
function! TaskstackDetectProjectName(line) " {{{
	let l:project_name = matchstr(getline(a:line),'^\(. \|@\)\zs\(\<\w*\>\s*\)\{,3}\ze:*')
	return l:project_name	
endfunction

" }}}
function! TaskstackMoveItemToNode(item,node) " {{{
	let l:nodeline = FindNode(a:node)
	let l:result = ""
	if l:nodeline != 0
		let l:result = ':' . a:item . 'm' . nodeline
		exe l:result
	end
	return l:result
endfunction

" }}}

function! ProjectRawMatchPattern() " {{{
    return '^@\zs\(\<\w*\>\s*\)\{,3}\ze\s' 
endfunction

"}}}
function! TaskstackProjectNameCompletion(A,L,P) " {{{
	  let l:origview = winsaveview()
    let l:results = ""
    g/^@/let l:results .= matchstr(getline("."), ProjectRawMatchPattern()) . "\n"
    call winrestview(l:origview)
    return l:results
endfunction

" }}}
function! TaskstackPromptProjectName() " {{{
    if !exists("s:last_selection")
        let s:last_selection = ""
    endif
    let l:project_name = input("Project name: ", s:last_selection, "custom,TaskstackProjectNameCompletion")
    let s:last_selection = l:project_name
    return l:project_name
endfunction

" }}}
function! TaskstackNavigateToProjectPrompted() " {{{
    let l:incoming = input("Navigate to: ", "", "custom,TaskstackProjectNameCompletion")
    call FindNode("@" . l:incoming)
endfunction

"}}}
function! TaskstackMoveToProjectPrompt() " {{{
	let l:origview = winsaveview()
    let l:item_validity = TaskstackValidateItemForMove()
    if l:item_validity != ""
      return l:item_validity
    endif
	let l:project_name = TaskstackPromptProjectName()
	call winrestview(l:origview)
  return TaskstackMoveItemToProject(l:project_name)
endfunction

" }}}
function! TaskstackMoveToProjectAutoDetect() " {{{
	let l:origview = winsaveview()
    let l:item_validity = TaskstackValidateItemForMove()
    if l:item_validity != ""
      return l:item_validity
    endif
	let l:project_name = TaskstackDetectProjectName(line("."))
	call winrestview(l:origview)
  return TaskstackMoveItemToProject(l:project_name)
endfunction

" }}}
function! TaskstackValidateItemForMove() " {{{
    if TaskstackFindItemGroup() == 0
			return "Can't move non-item."
    endif
    return ""
endfunction

" }}}
function! TaskstackMoveItemToProject(project_name) "{{{
	let l:origview = winsaveview()
	if a:project_name == ""
		return "No project specified."
	end
	let l:group_lines = TaskstackFindItemGroup()
	let l:result_message = ""
	if l:group_lines != 0
			let l:move_result = TaskstackMoveItemToNode(l:group_lines,a:project_name)
			if l:move_result == ""
				let l:result_message = "Project \"@" . a:project_name . "\" not found."
			else
					let l:result_message = "Moved item to project \"@" . a:project_name . "\". (" . l:move_result . ")"
			endif
	else
			let l:result_message = "Can't move non-item."
	endif
	call winrestview(l:origview)
	return l:result_message
endfunction

" }}}
function! TaskstackFindItemGroup() "{{{
	if IsAntiItem()
			return 0
	end
	let l:max_lines_without_warning = 5
	let l:begin_line = line(".")
	let l:end_line = line(".")
	while l:end_line < line("$")
		normal j
		if IsItem() || IsAntiItem()
				break
		endif
		let l:end_line = line(".")
	endwhile

	let l:lines_to_move = l:end_line - l:begin_line
  " TODO: this clause should be in calling function, so this function could be
  " generalized.
	if l:lines_to_move > l:max_lines_without_warning
			let l:continue = input("About to move " . l:lines_to_move . " lines. Proceed? ")
			if l:continue != "y"
				return 0
			endif
	endif
	return l:begin_line . "," . l:end_line
endfunction

" }}}
function! IsItem() " {{{
	let l:itemMatches = "^\[-ox?+@]\\s*"
	let l:match_result = match(getline("."), l:itemMatches)
	return l:match_result + 1
endfunction

" }}}
function! IsAntiItem() " {{{
	let boundaryMatches = "^" . Strip(CommentStringOpen()) . "\\s*\\w*\\s*\[}{]"
	return match(getline("."), boundaryMatches . "\\|" . "^$") + 1
endfunction

" }}}
function! TaskstackHide() " {{{
	macaction hide:
endfunction

" }}}
function! TaskstackSave() " {{{
	silent write
	call CommitSession() " FIXME: External Dependency
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
