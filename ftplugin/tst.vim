" INFO: " {{{

" Maintainer:
"   Seth Milliken <seth_vim@araxia.net>
"   Araxia on #vim irc.freenode.net

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

au FileType *tst* map <buffer> <Space> <Plug>ToggleLine
au FileType *tst* map <buffer> Nc <Plug>CompleteLine
au FileType *tst* map <buffer> Na <Plug>AbandonLine

noremap <script> <Plug>AbandonLine <SID>AbandonLine
noremap <SID>AbandonLine :call <SID>AbandonLine()<CR>
function! s:AbandonLine()
    if !exists("s:statusabandoned") | let s:statusabandoned = NewStatusToggler("x") | end
    call s:statusabandoned.toggle()
endfunction

noremap <script> <Plug>CompleteLine <SID>CompleteLine
noremap <SID>CompleteLine :call <SID>CompleteLine()<CR>
function! s:CompleteLine()
    if !exists("s:statuscomplete") | let s:statuscomplete = NewStatusToggler("o") | end
    call s:statuscomplete.toggle()
endfunction

noremap <script> <Plug>ToggleLine <SID>ToggleLine
noremap <SID>ToggleLine :call <SID>ToggleLine()<CR>
function! s:ToggleLine()
    if !exists("s:statustoggle") | let s:statustoggle = NewStatusToggler("-","o","x") | end
    call s:statustoggle.toggle()
endfunction

"}}}
" SYNTAX: " {{{

"}}}
" OBJECTS: " {{{

" BASEOBJECT OBJECT: v5 " {{{
function! Super() dict " {{{
   call self['parent']._init()
   let self['inited'] += 1
endfunction

" }}}
function! Noop() dict " {{{
endfunction

" }}}
function! Alloc(...) dict " {{{
    if len(a:000) == 1
        let baseclass = a:000[0]
        if empty(baseclass)
            let self['parent'] = {}
        else
            if type(baseclass) == type({})
                exec "let self['parent'] = g:" . baseclass['class'] . ".New()"
            else
                exec "let self['parent'] = " . baseclass . ".New()"
            endif
        end
    else
        let self['parent'] = g:baseobject.New()
    endif
    let l:new = extend(deepcopy(self['parent']), deepcopy(self))
    let l:new['Super'] = function("Super")
    exec "call l:new._init()"
    return l:new
endfunction

" }}}
let g:nullObject = {}
func nullObject.foldsave() dict " {{{
    echo "save"
endfunction

" }}}
func nullObject.foldrest() dict " {{{
    echo "rest"
endfunction

" }}}

let g:baseobject = {
                    \ 'parent': {},
                    \ 'class': "baseobject",
                    \ 'contentlist': [""],
                    \ 'start': 1,
                    \ 'debug': 0,
                    \ 'inited': 0,
                    \ 'state': {},
                    \ }
func baseobject.New(...) dict " {{{
    let self['Alloc'] = function("Alloc")
    let self['state'] = g:nullObject
    let l:new = self['Alloc'](self['parent'])
    if len(a:000) == 1
        let initial_funct = a:000[0]
        exec "call l:new." . initial_funct . "()"
    endif
    return l:new
endfunction

" }}}
func baseobject._name() dict " {{{
    return "Generic Object"
endfu

" }}}
fu baseobject.value() dict " {{{
    return string(self)
endfu

" }}}
func baseobject._init() dict " {{{
   let self['inited'] = 1 
endfunction

" }}}
func baseobject._debug(...) dict " {{{
    if self['debug']
        echo string(a:000)
    end
endfu

" }}}
fu baseobject._address() dict " {{{
    if self._isvalid()
        let issilent = "silent"
        if self['debug']
            let issilent = ""
        end
        return ":" . issilent . self._start() . "," . self._end()
    else
        return ":\"" . "( Object: \"" . self._name() . "\" is invalid. )"
    end
endfu

" }}}
func baseobject._start() dict " {{{
    let verifiedposition = self._verifyposition(self['start'])
    if verifiedposition == 0
        return self['start']
    else
        return verifiedposition
    end
endfu

" }}}
func baseobject._end() dict " {{{
    return line("$")
endfu

" }}}
fu baseobject._isvalid() dict " {{{
    call self._refresh()
    return !!self._start()
endfu

" }}}
fu baseobject._refresh() dict " {{{
        let self['start'] = self._verifyposition()
endfu

" }}}
func baseobject._firstline() dict " {{{
    return [ getline("1") ] 
endfu

" }}}
func baseobject._lastline() dict " {{{
    return [ getline("$") ]
endfu

" }}}
func baseobject._contents() dict " {{{
        return getbufline(getbuffer("%"), line("."), line("$"))
endfu

" }}}
fu baseobject._verifyposition(...) dict " {{{
    call self['state'].foldsave()
    let foundposition = 0
    let searchstring = get(self._firstline(), 0)
    if len(a:000) == 0
        " partial search
        silent normal 10k
        let foundposition = search(searchstring, 'cW', self._end())
        if foundposition == 0
            return self._verifyposition("full")
        end
    else
        " full search
        let foundposition = search(searchstring, 'cw')
    end
    call self['state'].foldrest()
    return foundposition
endfu

" }}}

" }}}
" STATEINFO OBJECT: v4 " {{{
let g:stateinfo = {
                \ 'parent': 'g:baseobject',
                \ 'class': "stateinfo",
                \ 'view':'myviewhere',
                \ 'winsaveview': {},
                \ 'getpos': []
                \ }
function stateinfo.New(...) dict " {{{
    let self['Alloc'] = function("Alloc")
    let l:new = self['Alloc'](self['parent'])
    if len(a:000) == 1
        let initial_funct = a:000[0]
        exec "call l:new." . initial_funct . "()"
    endif
    return l:new
endfunction

" }}}
function stateinfo._init() dict " {{{
   call self.Super()
endfunction

" }}}
function stateinfo.foldsave() dict " {{{
    let b:original_vop = &vop
    exec "let b:viewfile = " . "\"" . &viewdir . "/foldsave.vim" . "\""
    set vop=folds,cursor
    exec "silent mkview! " . b:viewfile
    call self._fixview()
endfunction

" }}}
function stateinfo.foldrest() dict " {{{
    if exists("b:original_vop") && exists("b:viewfile")
        exec "silent! source " . b:viewfile
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
        silent exec "call winrestview(" . string(self['winsaveview']) . ")"
    endif
endfunction

" }}}
function stateinfo.possave() dict " {{{
    if !empty(self['getpos'])
        silent exec "set setpos(\".\"" . self['getpos'] . ")"
    endif
endfunction

" }}}
function stateinfo.posrest() dict " {{{
    let self['getpos'] = getpos(line("."))
endfunction

" }}}

" }}}
" FOLDCONTAINER OBJECT: v5 " {{{
let g:foldcontainer = {
                \ 'parent': 'g:baseobject',
                \ 'class': "foldcontainer",
                \ 'header': "",
                \ }
fu foldcontainer.New(header) dict " {{{
    return foldercontainer.for(a:header)
endfu

" }}}
fu foldcontainer.for(header) dict " {{{
    " Class-scoped instance cache
    if ! has_key(self, 'ALL') 
        let self['ALL'] = {}
    endif
    if has_key(self['ALL'], a:header)
        " echo "cache hit: " . string(self['ALL'][a:header])
        return self['ALL'][a:header]
    endif
    let self['Alloc'] = function("Alloc")
    let l:new = self['Alloc'](self['parent'])
    let l:new['header'] = a:header
    let l:new['state'] = g:stateinfo.New()
    let self['ALL'][a:header] = l:new
    call remove(l:new, 'ALL')
    return l:new
endfu

" }}}
fun foldcontainer._init() dict " {{{
   call self.Super()
endfu

" }}}
fun foldcontainer._end() dict " {{{
        " preserve folds
        call self['state'].winsave()
        normal $
        let result = searchpair(FoldMarkerOpen(), "", FoldMarkerClose(), 'W')
        call self['state'].winrest()
        return result
endfu

" }}}
fun foldcontainer._firstline() dict " {{{
    " TODO: fix with FoldMarkerOpen()
    return [ self['header'] . " " . " \" {{" . "{" ]
endfu

" }}}
fun foldcontainer._lastline() dict " {{{
    return [ "\" }}" . "}" ]
endfu

" }}}
fu foldcontainer._contents() dict " {{{
         return self._firstline() + self['contentlist'] + self._lastline()
endfu

" }}}
fun foldcontainer._name() dict " {{{
    return self['header']
endfu

" }}}
fu foldcontainer.create_at(line) dict " {{{
    if self._isvalid()
        call self.move_to(a:line)
    else
        let self['start'] = a:line + 1
        let contents = self._contents()
        call append(a:line, contents)
    end
endfu

" }}}
fu foldcontainer.move_to(destination) dict " {{{
    let fullcommand = self._address() . "m" . a:destination | exec fullcommand | return fullcommand
endfu

" }}}
fu foldcontainer.move_into(target) dict " {{{
    let targetline = a:target._start()
    call self.move_to(targetline)
endfu

" }}}
fu foldcontainer.move_under(target) dict " {{{
    let targetline = a:target._end()
    call self.move_to(targetline)
endfu

" }}}
fu foldcontainer.move_above(target) dict " {{{
    let targetline = a:target._start() - 1
    call self.move_to(targetline)
endfu

" }}}
fu foldcontainer.delete() dict " {{{
    let fullcommand = self._address() . "d" | silent exec fullcommand | return fullcommand
endfu

" }}}

" }}}
" TASKSTACK OBJECT: v5 " {{{
let g:taskstack = {
                \ 'parent': 'g:baseobject',
                \ 'class': "taskstack",
                \ 'name': "TaskStack",
                \ 'start': 0,
                \ 'nodes': {},
                \ 'node_names': { 'main':'DOING', 'done':'COMPLETED','dates':'DATES','projects':'PROJECTS','scratch':'SCRATCH'},
                \ 'layout': [ 'main', 'done', ['dates'], 'projects', 'scratch' ]
                \ }
func taskstack.New(...) dict " {{{
    let self['Alloc'] = function("Alloc")
    let l:new = self['Alloc'](self['parent'])
    if len(a:000) == 1
        let initial_line = a:000[0]
        let l:new['beginline'] = initial_line
        call l:new._find_end()
    endif
    return l:new
endfunction

" }}}
fu taskstack._init() dict " {{{
   call self.Super()
endfu

" }}}
fu taskstack._start() dict " {{{
    return self['start']
endfu

" }}}
fu taskstack._name() dict " {{{
    return self['name']
endfu

" }}}
fu taskstack._layouttry1(list, firstposition, parentnodes, ...) dict " {{{
    " illegal for first item in list to be a list (can't put something into
    " nothing)
    if len(a:000) == 0
        let indentlevel = 0
    else
        let indentlevel = a:000[0]
    endif
    if a:parentnodes == type([])
        let parents = a:parentnodes
    else
        let parents = add([], a:parentnodes)
    endif
    let node = self['nodes'][remove(list, 0)]
    call node.move_to(firstposition)
    for nodelabel in a:list
        if type(nodelabel) == type([])
            call self._layout(nodelabel, parents, indentlevel + 1)
        else
            let index = index(a:list, nodelabel)
            let parent = get(parents, 0)
            if type(parent) == type(0)
            else
                call node.move_under(parent)
            end
            let nextnodelabel = get(a:list, index + 1)
            if nextnodelabel == 0
                " pop
            else if type(nextnodelabel) == type([])
                call add(insertlines, node._start())
                call self._layout(nextnodelabel, node._start(), indentlevel + 1)
            else
                let indentmult = 2
                exec "let nodedisplay = printf(\"%." . indentmult * indentlevel . "s%s\", \"       \", \"" . node._name() . "\")"
                call self._debug(nodedisplay)
            end
            unlet nextnodelabel
        endif
    endif
    unlet nodelabel
endfor
endfu

" }}}
fu taskstack._layout(list, location) dict " {{{
    " illegal for first item in list to be a list (can't put something into
    " nothing)
    let fulllist = copy(a:list)
    let peeklist = copy(a:list)
    call remove(peeklist, 0)
    if type(peeklist) == type(0)
        let nextitem = 0
    else
        let nextitem = get(peeklist, 0)
    end
    let thisitem = get(fulllist, 0)
    let thisnode = self['nodes'][thisitem]
    if has_key(a:location, 'line')
        call thisnode.move_to(a:location['line'])
    else
        if has_key(a:location, 'container')
            call thisnode.move_into(a:location['container'])
        else
            if has_key(a:location, 'peer')
                call thisnode.move_under(a:location['peer'])
            endif
        endif
    endif
    if type(nextitem) == type(0)
        return
    endif
    if type(nextitem) == type([])
        call self._layout(nextitem, { 'container': thisnode })
        call remove(fulllist, 1)
    endif
    call remove(fulllist, 0)
    call self._layout(fulllist, { 'peer': thisnode })
endfu

" }}}
fu taskstack._layout3(list, location) dict " {{{
    " illegal for first item in list to be a list (can't put something into
    " nothing)
    let fulllist = copy(a:list)
    echo string(peeklist)
    if type(peeklist) == type(0)
        let nextitem = 0
    else
        let nextitem = get(peeklist, 0)
    end
    echo string(nextitem)
    let thisitem = get(fulllist, 0)
    let thisnode = self['nodes'][thisitem]
    if has_key(a:location, 'line')
        echo thisnode._name() . " move_to " . a:location['line']
        call thisnode.move_to(a:location['line'])
    endif
    let nextnode = self['nodes'][nextitem]
    let nextnode.move_under(thisnode)

    call remove(peeklist, 0)
    echo string(peeklist)
    if type(peeklist) == type(0)
        let nextitem = 0
    else
        let nextitem = get(peeklist, 0)
    end
    let nextnode = self['nodes'][nextitem]
    let nextnode.move_under(thisnode)
    return
    else
        if has_key(a:location, 'container')
            echo thisnode._name() . " move_into " . a:location['container']._name()
            call thisnode.move_into(a:location['container'])
        else
            if has_key(a:location, 'peer')
                echo thisnode._name() . " move_under " . a:location['peer']._name()
                call thisnode.move_under(a:location['peer'])
            endif
        endif
    endif
    if nextitem == 0
        return
    endif
    if type(nextitem) == type([])
        call self._layout(nextitem, { 'container': thisitem })
        call remove(fullist, 1)
    endif 
    call self._layout(fulllist, { 'peer': thisitem })
endfu

" }}}
fu taskstack._instantiatenodes() dict " {{{
    for label in keys(self['node_names'])
        let nodename = self['node_names'][label]
        let foldnode = g:foldcontainer.for(nodename)
        let self['nodes'][label] = foldnode
        call foldnode.create_at("$")
        echo foldnode._name()
    endfor
endfu

" }}}
fu taskstack.create_at(line) dict " {{{
    let self['start'] = a:line
    call self._instantiatenodes()
    call self._layout(self['layout'], { 'line': self['start'] })
endfu

" }}}
fu taskstack.delete() dict " {{{
    let fullcommand = self._address() . "d" | silent exec fullcommand | return fullcommand
endfu

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

"}}}
" FUNCTIONS: " {{{

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
    call timestamp#autoUpdateBypass() " FIXME: External Dependency
    " silent! wincmd t
    if FindNode(s:groups_node_name) == 0
        call TaskstackMain()
        normal zc
        exe "normal o" . s:groups_node_name
        call FoldWrap()
    end
    call FindNode(s:groups_node_name)
    silent! normal zo
    call timestamp#autoUpdateEnable() " FIXME: External Dependency
endfunction

" }}}
function! TaskstackCompleted() " {{{
    call timestamp#autoUpdateBypass() " FIXME: External Dependency
    " silent! wincmd t
    if FindNode(s:completed_node_name) == 0
        call TaskstackMain()
        normal zc
        exe "normal o" . s:completed_node_name
        call FoldWrap()
    end
    call FindNode(s:completed_node_name)
    silent! normal zo
    call timestamp#autoUpdateEnable() " FIXME: External Dependency
endfunction

" }}}
function! TaskstackDates() " {{{
    call timestamp#autoUpdateBypass() " FIXME: External Dependency
    " silent! wincmd t
    if FindNode(s:dates_node_name) == 0
        call TaskstackCompleted()
        normal zo
        exe "normal o" . s:dates_node_name
        call FoldWrap()
    end
    call FindNode(s:dates_node_name)
    silent! normal zo
    call timestamp#autoUpdateEnable() " FIXME: External Dependency
endfunction

" }}}
function! TaskstackDate() "{{{
    let l:currentdate = timestamp#text('date')
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
    call timestamp#autoUpdateBypass() " FIXME: External Dependency
    " silent! wincmd b
    if FindNode(s:notes_node_name) == 0
        exe "normal Go" . s:notes_node_name
        call FoldWrap()
    end
    call FindNode(s:notes_node_name)
    normal zozt]zk
    call timestamp#autoUpdateEnable() " FIXME: External Dependency
endfunction

" }}}

" Tasks: change status
function! TaskstackNewItem() " {{{
    call timestamp#autoUpdateBypass() " FIXME: External Dependency
    call TaskstackMain()
    exe "normal o- "
    startinsert!
    call timestamp#autoUpdateEnable() " FIXME: External Dependency
endfunction

" }}}
function! TaskstackCompleteItem(prefix) " {{{
    call timestamp#autoUpdateBypass() " FIXME: External Dependency

    if empty(TaskstackFoldbounds())
        silent call MoveItemToDateNode(getline("."), a:prefix)
    else
        silent call MoveFoldToDateNode(TaskstackFoldbounds(), a:prefix)
    end
    call timestamp#autoUpdateEnable() " FIXME: External Dependency
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
    let l:result = printf("%s [%s] %s%s", a:status, timestamp#text('short'), l:enclosing_project, l:itemnostatus)
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
    let l:result = printf("%s [%s] %s%s", a:status, timestamp#text('short'), l:enclosing_project, l:itemnostatus)
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
    normal zv
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
    let l:timestamp_location = match(getline("."), timestamp#pattern() . ".*")
    if l:timestamp_location > 0
        call cursor(line("."), l:timestamp_location)
    else
        normal g_
    end
endfunction

" }}}

" }}}
" vim: set sw=4 ft=vim fdm=marker cms=\ \"\ %s  :
