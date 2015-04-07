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

let s:main_node_name      = "DOING"
let s:groups_node_name    = "PROJECTS"
let s:completed_node_name = "COMPLETED"
let s:dates_node_name     = "DATES"
let s:notes_node_name     = "SCRATCH"

augroup TaskStack
    au FileType *tst* map <buffer> <C-Space> <Plug>ToggleLine
    au FileType *tst* map <buffer> QQ <Plug>CompleteItem
    au FileType *tst* map <buffer> Qx <Plug>AbandonItem
    au FileType *tst* map <buffer> Qr <Plug>ResetTogglers
    au FileType *tst* map <buffer> QW :call TaskstackMoveItemToProject("@queue")<CR>
    au FileType *tst* map <buffer> QA :call TaskstackMoveItemToProject("@active")<CR>
augroup END

noremap <script> <Plug>AbandonItem <SID>AbandonItem
noremap <SID>AbandonItem :call <SID>AbandonItem(line("."))<CR>
function! s:AbandonItem(line)
    if !exists("s:statusabandoned") | let s:statusabandoned = util#NewStatusToggler("x") | end
    call s:statusabandoned.decorate(a:line)
    call s:statusabandoned.toggle(a:line)
    call TaskstackMoveItemToToday()
endfunction

noremap <script> <Plug>CompleteItem <SID>CompleteItem
noremap <SID>CompleteItem :call <SID>CompleteItem(line("."))<CR>
function! s:CompleteItem(line)
    if !exists("s:statuscomplete") | let s:statuscomplete = util#NewStatusToggler("o") | end
    call s:statuscomplete.decorate(a:line)
    call s:statuscomplete.toggle(a:line)
    call TaskstackMoveItemToToday()
endfunction

noremap <script> <Plug>ToggleLine <SID>ToggleLine
noremap <SID>ToggleLine :call <SID>ToggleLine(line("."))<CR>
function! s:ToggleLine(line)
    if !exists("s:statustoggle") | let s:statustoggle = util#NewStatusToggler("-","o","x") | end
    call s:statustoggle.toggle(a:line)
endfunction

noremap <script> <Plug>ResetTogglers <SID>ResetTogglers
noremap <SID>ResetTogglers :call <SID>ResetTogglers()<CR>
function! s:ResetTogglers()
    for item in [ "s:statustoggle", "s:statuscomplete", "s:statusabandoned" ]
        if exists(item)
            exec "unlet " . item
        endif
    endfor
    echo "Togglers reset."
endfunction

"}}}
"
" SYNTAX: " {{{

"}}}
" OBJECTS: " {{{

" NULL OBJECT: v6 " {{{
function! NullObject()
    let instance = {
                        \ 'parent': {},
                        \ 'class': "NullObject",
                        \ 'contentlist': [""],
                        \ 'start': 1,
                        \ 'debug': 0,
                        \ 'inited': 1,
                        \ 'state': {},
                        \ }
    fu instance.foldsave() dict " {{{
        echo "save"
    endfu " }}}
    fu instance.foldrest() dict " {{{
        echo "rest"
    endfu " }}}

    return instance
endfunction

" }}}
" BASE OBJECT: v6 " {{{
function! NullObject() " {{{
    let instance = {
                        \ 'parent': {},
                        \ 'class': "NullObject",
                        \ 'contentlist': [""],
                        \ 'start': 1,
                        \ 'debug': 0,
                        \ 'inited': 1,
                        \ 'state': {},
                        \ }
    fu instance.foldsave() dict " {{{
        echo "save"
    endfu " }}}
    fu instance.foldrest() dict " {{{
        echo "rest"
    endfu " }}}

    return instance
endfunction

" }}}
function! BaseObject(...) " {{{
    if exists("g:baseobject_singleton")
        return g:baseobject_singleton
    end
    let instance = {
                        \ 'parent': {},
                        \ 'class': "BaseObject",
                        \ 'contentlist': [""],
                        \ 'start': 1,
                        \ 'debug': 0,
                        \ 'inited': 0,
                        \ 'state': NullObject(),
                        \ }
    fu instance.New(...) dict " {{{
         return self
         let l:new = self.Alloc()
         if len(a:000) == 1
            "let initial_funct = a:000[0]
            "exec "call l:new." . initial_funct . "()"
         endif
         return l:new
    endfu " }}}
    fu instance.Alloc() dict " {{{
        return self
        let baseclass = self['parent']
        if empty(baseclass)
            if self['class'] == "BaseObject"
                let self['parent'] = {}
            else
                let self['parent'] = BaseObject().New()
            endif
        else
            if type(baseclass) == type({})
                exec "let self['parent'] = " . baseclass['class'] . "().New()"
            else
                exec "let self['parent'] = " . baseclass . "().New()"
            endif
        endif
        let l:new = extend(deepcopy(self['parent']), deepcopy(self))
        exec "call l:new._init()"
        exec "call l:new._super()"
        exec "let l:new['inited'] = 1"
        return l:new
    endfu " }}}
    fu instance._noop() dict " {{{
        return
    endfu " }}}
    fu instance._super() dict " {{{
       if has_key(self['parent'], '_init')
           call self['parent']._init()
       endif
    endfu " }}}
    fu instance._name() dict " {{{
        return "Generic Object"
    endfu " }}}
    fu instance.value() dict " {{{
        return string(self)
    endfu " }}}
    fu instance._init() dict " {{{
        return
    endfu " }}}
    fu instance._debug(...) dict " {{{
        if self['debug']
            echo string(a:000)
        end
    endfu " }}}
    fu instance._address() dict " {{{
        if self._isvalid()
            let issilent = "silent"
            if self['debug']
                let issilent = ""
            end
            return ":" . issilent . self._start() . "," . self._end()
        else
            return ":\"" . "( Object: \"" . self._name() . "\" is invalid. )"
        end
    endfu " }}}
    fu instance._start() dict " {{{
        let verifiedposition = self._verifyposition(self['start'])
        if verifiedposition == 0
            return self['start']
        else
            return verifiedposition
        end
    endfu " }}}
    fu instance._end() dict " {{{
        return line("$")
    endfu " }}}
    fu instance._isvalid() dict " {{{
        call self._refresh()
        return !!self._start()
    endfu " }}}
    fu instance._refresh() dict " {{{
            let self['start'] = self._verifyposition()
    endfu " }}}
    fu instance._firstline() dict " {{{
        return [ getline("1") ] 
    endfu " }}}
    fu instance._lastline() dict " {{{
        return [ getline("$") ]
    endfu " }}}
    fu instance._contents() dict " {{{
            return getbufline(getbuffer("%"), line("."), line("$"))
    endfu " }}}
    fu instance._verifyposition(...) dict " {{{
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
    endfu " }}}

    let g:baseobject_singleton = instance
    return BaseObject()
endfunction

" }}}
" }}}
" STATEINFO OBJECT: v6 " {{{
function! StateInfo(...)
    let instance = {
                        \ 'parent': 'BaseObject',
                        \ 'class': "StateInfo",
                        \ 'view':'myviewhere',
                        \ 'winsaveview': {},
                        \ 'getpos': []
                        \ }
    let instance = extend(deepcopy(BaseObject()), instance)
    fu instance.foldsave() dict " {{{
        let b:original_vop = &vop
        exec "let b:viewfile = " . "\"" . &viewdir . "/foldsave.vim" . "\""
        set vop=folds,cursor
        exec "silent mkview! " . b:viewfile
        call self._fixview()
    endfu " }}}
    fu instance.foldrest() dict " {{{
        if exists("b:original_vop") && exists("b:viewfile")
            exec "silent! source " . b:viewfile
            exec "set vop=" . b:original_vop
            unlet b:original_vop
            "unlet b:viewfile
        endif
    endfu " }}}
    fu instance._fixview() dict " {{{
      exe "vsplit " . b:viewfile
      exe "%s/^edit /buffer /ge"
      exe "g/SessionLoadPost/d"
      silent write
      close
    endfun " }}}
    fu instance.winsave() dict " {{{
        let self['winsaveview'] = winsaveview()
    endfu " }}}
    fu instance.winrest() dict " {{{
        if !empty(self['winsaveview']) && type(self['winsaveview']) == type({})
            silent exec "call winrestview(" . string(self['winsaveview']) . ")"
        endif
    endfunction

    " }}}
    fu instance.possave() dict " {{{
        if !empty(self['getpos'])
            silent exec "set setpos(\".\"" . self['getpos'] . ")"
        endif
    endfu " }}}
    fu instance.posrest() dict " {{{
        let self['getpos'] = getpos(line("."))
    endfu " }}}

    return instance
endfunction

" }}}
" FOLDCONTAINER OBJECT: v6 " {{{
function! FoldContainer(...)
    let instance = {
                   \ 'parent': 'BaseObject',
                   \ 'class': "FoldContainer",
                   \ 'header': "",
                   \ }
    let instance = extend(deepcopy(BaseObject()), instance)
    fu! instance.New(header) dict " {{{
        return self.for(a:header)
    endfu " }}}
    fu instance._new(header) dict " {{{
        let l:new = self.Alloc()
        let l:new['header'] = a:header
        let l:new['state'] = StateInfo().New()
        return l:new
    endfu " }}}
    fu instance.for(header) dict " {{{
        " Class-scoped instance cache
        if ! exists('g:foldcontainer_cache')
            let g:foldcontainer_cache = {}
            let g:foldcontainer_cache['ALL'] = {}
        endif
        if ! has_key(g:foldcontainer_cache, 'ALL') 
            let g:foldcontainer_cache['ALL'] = {}
        endif
        if has_key(g:foldcontainer_cache['ALL'], a:header)
            " echo "cache hit: " . string(self['ALL'][a:header])
            return g:foldcontainer_cache['ALL'][a:header]
        endif
        let l:new = FoldContainer()._new(a:header)
        call remove(l:new, 'ALL')
        call remove(l:new, 'for')
        let g:foldcontainer_cache['ALL'][a:header] = l:new
        return l:new
    endfu " }}}
    fu instance._end() dict " {{{
            " preserve folds
            call self['state'].winsave()
            normal $
            let result = searchpair(FoldMarkerOpen(), "", FoldMarkerClose(), 'W')
            call self['state'].winrest()
            return result
    endfu " }}}
    fu instance._firstline() dict " {{{
        " TODO: fix with FoldMarkerOpen()
        return [ self['header'] . " " . " \" {{" . "{" ]
    endfu " }}}
    fu instance._lastline() dict " {{{
        return [ "\" }}" . "}" ]
    endfu " }}}
    fu instance._contents() dict " {{{
       return self._firstline() + self['contentlist'] + self._lastline()
    endfu " }}}
    fu! instance._name() dict " {{{
        return self['header']
    endfu " }}}
    fu instance.create_at(line) dict " {{{
        if self._isvalid()
            call self.move_to(a:line)
        else
            let self['start'] = a:line + 1
            let contents = self._contents()
            call append(a:line, contents)
        end
    endfu " }}}
    fu instance.move_to(destination) dict " {{{
        let fullcommand = self._address() . "m" . a:destination | exec fullcommand | return fullcommand
    endfu " }}}
    fu instance.move_into(target) dict " {{{
        let targetline = a:target._start()
        call self.move_to(targetline)
    endfu " }}}
    fu instance.move_under(target) dict " {{{
        let targetline = a:target._end()
        call self.move_to(targetline)
    endfu " }}}
    fu instance.move_above(target) dict " {{{
        let targetline = a:target._start() - 1
        call self.move_to(targetline)
    endfu " }}}
    fu instance.delete() dict " {{{
        let fullcommand = self._address() . "d" | silent exec fullcommand | return fullcommand
    endfu

    " }}}
    return instance
endfunction

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
    "let instance = extend(deepcopy(BaseObject()), instance)
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

function! NewFoldAgent(...) " {{{
    let foldagent = {}
    let foldagent.begin = "^\\s*\\zs"
    let foldagent.trail = "\\s"
    let foldagent.custom_line = 0
    fu! foldagent.line()
      if self.custom_line > 0
        return self.custom_line
      else
        return line(".")
      end
    endfu
    fu! foldagent.getline()
        return getline(self.line())
    endfu
    fu! foldagent.toggle(...) dict
        if len(a:000) > 0
          let self.custom_line = a:000[0]
        end
        if self._nexttoggle()
          call self._setstatus(self.toggleset[0], self.toggleset[1])
        end
    endfu
    fu! foldagent.debug(output)
        if &verbose > 0
            echo printf("%s: %s", expand("<sfile>"), a:output)
        endif
    endfu
    fu! foldagent._setstatus(from,to)
        let escapechars = '[]'
        let from = escape(a:from, escapechars)
        let to = escape(a:to, escapechars)
        call self.debug(printf("match: \'%s\' with %s", match(self.getline(), self.begin . from . self.trail), self.begin . from . self.trail))
        if match(self.getline(), self.begin . from . self.trail) > -1
            call setline(self.line(), substitute(self.getline(), self.begin . from, to, ''))
        endif
    endfu
    fu! foldagent.status_indicator()
        let togglepattern = substitute(self.toggleset[0], ".", "[^\\\\\\\\s]", "g")
        call self.debug(printf("togglepattern: %s", togglepattern))
        let indicator = matchstr(self.getline(), self.begin . togglepattern)
        call self.debug(printf("line: %s, begin: %s, pattern: %s", self.getline(), self.begin, togglepattern))
        return indicator
    endfu
    fu! foldagent._nexttoggle()
        let indicator = self.status_indicator()
        if len(self.toggleset) == 1
           call self._setstatus(indicator, self.toggleset[0])
           return 0
        end
        let matchpos = match(self.toggleset, indicator)
        if matchpos == -1
            echo "No toggle match."
        elseif matchpos > 0
            call self._rotate_toggleset(matchpos)
        end
        return 1
    endfu
    fu! foldagent._rotate_toggleset(matchpos)
        let swap = remove(self.toggleset, 0, a:matchpos - 1)
        call extend(self.toggleset, swap)
    endfu

    fu! foldagent.decorate(...)
        if len(a:000) > 0
          let self.custom_line = a:000[0]
        end
        " prevent multiple-decoration
        let l:enclosing_project = "" " detect this
        if l:enclosing_project != "" | let l:enclosing_project .= ": " | end
        let l:itemnostatus = substitute(self.getline(), '^\s*\(.\) ', '', '')
        let l:result = printf("%s [%s] %s%s", self.status_indicator(), timestamp#text('short'), l:enclosing_project, l:itemnostatus)
        call setline(self.line(), l:result)
    endfu

    return copy(foldagent)
endfunction

" }}}
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
function! TaskstackMain(...) " {{{
    " silent! wincmd t
    if NodeLocation(s:main_node_name) == 0
        if a:000[0] == "nocreate"
            normal 1G
        else
            normal gg
            if len(getline(".")) == 0
                call text#append(s:main_node_name)
            else
                exe "normal O" . s:main_node_name
            end
            call FoldWrap()
        end
    end
    call FindNode(s:main_node_name)
    silent! normal zo
endfunction

" }}}
function! TaskstackGroups() " {{{
    call timestamp#autoUpdateBypass()
    " silent! wincmd t
    if FindNode(s:groups_node_name) == 0
        call TaskstackMain()
        normal zc
        exe "normal o" . s:groups_node_name
        call FoldWrap()
    end
    call FindNode(s:groups_node_name)
    silent! normal zo
    call timestamp#autoUpdateEnable()
endfunction

" }}}
function! TaskstackCompleted() " {{{
    call timestamp#autoUpdateBypass()
    " silent! wincmd t
    if FindNode(s:completed_node_name) == 0
        call TaskstackMain()
        normal zc
        exe "normal o" . s:completed_node_name
        call FoldWrap()
    end
    call FindNode(s:completed_node_name)
    silent! normal zo
    call timestamp#autoUpdateEnable()
endfunction

" }}}
function! TaskstackDates() " {{{
    call timestamp#autoUpdateBypass()
    " silent! wincmd t
    if NodeLocation(s:dates_node_name) == 0
        call TaskstackCompleted()
        normal zo
        exe "normal o" . s:dates_node_name
        call FoldWrap()
    end
    call FindNode(s:dates_node_name)
    silent! normal zo
    call timestamp#autoUpdateEnable()
endfunction

" }}}
function! TaskstackDate() "{{{
    let l:currentdate = timestamp#text('date')
    call TaskstackCreateDate(l:currentdate)
    call OpenNode(l:currentdate)
endfunction

"}}}
function! TaskstackCreateDate(date) "{{{
    if NodeLocation(a:date) == 0
        let l:origview = winsaveview()
        call TaskstackDates()
        call append(line("."), [""])
        normal j
        call text#append(a:date)
        call FoldWrap()
        call winrestview(l:origview)
    endif
endfunction

"}}}
function! TaskstackScratch() " {{{
    call timestamp#autoUpdateBypass()
    " silent! wincmd b
    if FindNode(s:notes_node_name) == 0
        exe "normal Go" . s:notes_node_name
        call FoldWrap()
    end
    call FindNode(s:notes_node_name)
    normal zozt]zk
    call timestamp#autoUpdateEnable()
endfunction

" }}}

" Tasks: change status
function! TaskstackNewProjectItem() " {{{
    let l:project_name_line = TaskstackContainingProjectNameLine(line("."))
    call TaskstackNewItemAt(l:project_name_line)
endfunction

" }}}
function! TaskstackNewItemAt(line) " {{{
    call timestamp#autoUpdateBypass()
    if a:line == 0
        call append(0, [''])
        normal 1G
        exe 'normal O' | startinsert
    else
        exe "normal " . (a:line + 1) . "G"
        call TaskstackSkipSticky()
        exe "normal o- "
        startinsert!
    end
    call timestamp#autoUpdateEnable()
endfunction

" }}}
function! TaskstackNewItem() " {{{
    call TaskstackMain("nocreate")
    call TaskstackNewItemAt(line("."))
endfunction

" }}}
function! TaskstackNewItemFromPasteAt(line) " {{{
    call timestamp#autoUpdateBypass()
    " TODO: detect if pasteboard is linewise and treat appropriately
    exe "normal o- \<Esc>p_w"
    call timestamp#autoUpdateEnable()
endfunction

" }}}
function! TaskstackNewItemFromPaste() " {{{
    call TaskstackMain()
    call TaskstackNewItemFromPasteAt(line("."))
endfunction

" }}}
function! TaskstackSkipSticky() " {{{
    while match(getline('.'), '^[A-Z]\+') > -1
        normal j
    endwhile
    normal k
endfunction

" }}}
function! TaskstackCompleteItem(prefix) " {{{
    call timestamp#autoUpdateBypass()

    if empty(TaskstackFoldbounds())
        silent call MoveItemToDateNode(getline("."), a:prefix)
    else
        silent call MoveFoldToDateNode(TaskstackFoldbounds(), a:prefix)
    end
    call timestamp#autoUpdateEnable()
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
    call Notify("Move", "Item marked as completed and moved.")
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
    if text#line_is_whitespace(getline("."))
        call append(line(".") - 1, l:toappend)
    else
        call insert(l:toappend, "", len(l:toappend))
        call append(line("."), l:toappend)
    endif
        call l:state.foldrest()
    normal zodd
    call Notify("Move", "Item marked as completed and moved.")
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
function! TodayNode() " {{{
    let l:currentdate = timestamp#text('date')
    call TaskstackCreateDate(l:currentdate)
    let l:nodeline = NodeLocation(l:currentdate)
    return l:nodeline
endfunction

"}}}
function! TaskstackContainingProjectNameLine(line) " {{{
    let current = a:line
    while current > 0 && !IsProjectHeaderLine(current)
        let current = current - 1
    endwhile
    return current
endfunction

" }}}
function! TaskstackDetectHeaderName(line) " {{{
    let l:project_name = matchstr(getline(a:line), '\(' . ProjectRawMatchPattern() . '\|' . CategoryRawMatchPattern() . '\)' . FoldMarkerOpen())
    return l:project_name
endfunction

" }}}
function! TaskstackDetectProjectName(line) " {{{
    let l:project_name = matchstr(getline(a:line),'^\(. \|@\)\zs\(\<[-_.+[:alnum:]]*\>\.*\s*\)\{,3}\ze:')
    return l:project_name
endfunction

" }}}
function! TaskstackMoveItemToNode(item,node) " {{{
    if type(a:node) == type(0)
        let l:nodeline = a:node
    else
        let l:nodeline = NodeLocation(a:node)
    end
    let l:result = ""
    if l:nodeline != 0
        let save_cursor = getpos(".")
        exe ':' . a:item . 'm' . nodeline
        call setpos(".", save_cursor)
    end
    let result_dict = { "start": split(a:item, ",")[0], "end": split(a:item, ",")[1], "destination": nodeline  }
    return result_dict
endfunction

" }}}
function! TaskstackMoveItemToToday() " {{{
    return TaskstackMoveItemToNode(TaskstackFindItemGroup(),TodayNode())
endfunction

" }}}

function! CategoryRawMatchPattern() " {{{
    return '^\zs\([A-Z]\{3,}\s*\)\{1,3}\ze\s\+'
endfunction

"}}}
function! ProjectRawMatchPattern() " {{{
    return '^@\zs\(\<[-_.+[:alnum:]]*\>\.*\s*\)\{,3}\ze\s\+'
endfunction

"}}}
function! TaskstackProjectNamesList() " {{{
    let l:results = []
    for line in getline(1,"$")
        let l:candidate = matchstr(line, ProjectRawMatchPattern())
        if len(l:candidate) > 0
            call add(l:results, l:candidate)
        end
    endfor
    return sort(l:results)
endfunction

" }}}
function! TaskstackProjectNameCompletion(A,L,P) " {{{
    return join(TaskstackProjectNamesList(), "\n")
endfunction

" }}}
function! TaskstackPromptProjectName(...) " {{{
    if !exists("s:last_selection")
        let s:last_selection = ""
    endif
    let l:pre_populate = s:last_selection
    if len(a:000) > 0
      if index(TaskstackProjectNamesList(), a:000[0]) > 0
        let l:pre_populate = a:000[0]
      end
    end
    let l:project_name = input("Project name: ", l:pre_populate, "custom,TaskstackProjectNameCompletion")
    let s:last_selection = l:project_name
    return l:project_name
endfunction

" }}}
function! TaskstackNavigateToProjectPrompted() " {{{
    let l:incoming = input("Navigate to: ", "", "custom,TaskstackProjectNameCompletion")
    let destination = NodeLocation("@" . l:incoming)
    call BalancedMove([destination, 0])
endfunction

"}}}
function! TaskstackNextProject(...) " {{{
    let l:options = 'n'
    if len(a:000) > 0
        let l:options .= 'b'
    end
    let l:next_project = searchpos(ProjectRawMatchPattern() . '\|' . CategoryRawMatchPattern(), l:options)
    if l:next_project != [0, 0]
        call BalancedMove(l:next_project)
    endif
endfunction

"}}}
function! BalancedMove(destination) " {{{
    let first_visible = line("w0")
    let last_visible = line("w$")
    let original_line = line(".")
    let in_range = index(range(first_visible, last_visible), a:destination[0])
    " echo [[first_visible, last_visible], a:destination, in_range, original_line]
    call cursor(a:destination)
    if in_range == -1
        "let offset_from_top = original_line - first_visible
        "call cursor(a:destination - offset_from_top, 0)
        normal zt
    end
endfunction

"}}}
function! TaskstackMoveToProjectPrompt() " {{{
    let l:origview = winsaveview()
    let l:item_validity = TaskstackValidateItemForMove()
    if l:item_validity != ""
      return l:item_validity
    endif
    let l:project_name = TaskstackPromptProjectName(TaskstackDetectProjectName(line(".")))
    call winrestview(l:origview)
    call Notify("Project Move", TaskstackMoveItemToProject(l:project_name))
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
    call Notify("Auto Project Move", TaskstackMoveItemToProject(l:project_name))
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
            if l:move_result == {}
                let l:result_message = "Project \"@" . a:project_name . "\" not found."
            else
                let l:result_message = printf("Moved item to project \"@%s\" (:%s,%sm%s)", a:project_name, l:move_result["start"], l:move_result["end"], l:move_result["destination"])
            endif
    else
            let l:result_message = "Can't move non-item."
    endif
    call winrestview(l:origview)
    " Adjust for positioning offset caused by moving lines up
    if line(".") > l:move_result["destination"]
        exe printf("normal %sj", (l:move_result["end"] - l:move_result["start"]) + 1)
    end
    return l:result_message
endfunction

" }}}
function! TaskstackFindItemGroup() "{{{
    return TaskstackFindItemGroupLine(line("."))
endfunction

" }}}
function! TaskstackFindItemGroupLine(line) "{{{
    if IsAntiItemLine(a:line)
            return 0
    end
    let l:max_lines_without_warning = 5
    let l:begin_line = a:line
    let l:end_line = a:line
    let l:current_line = l:begin_line
    while l:end_line < line("$")
        let l:current_line += 1
        if IsItemLine(l:current_line) || IsAntiItemLine(l:current_line)
            break
        endif
        let l:end_line = l:current_line
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
    return IsItemLine(getline("."))
endfunction

" }}}
function! IsItemLine(line) " {{{
    let l:itemMatches = "^\[-ox?+@]\\s*"
    let l:match_result = match(getline(a:line), l:itemMatches)
    return l:match_result + 1
endfunction

" }}}
function! IsAntiItem() " {{{
    return IsAntiItemLine(getline("."))
endfunction

" }}}
function! IsAntiItemLine(line) " {{{
    let boundaryMatches = "^" . text#strip(CommentStringOpen()) . "\\s*\\w*\\s*\[}{]"
    return match(getline(a:line), boundaryMatches . "\\|" . "^$") + 1
endfunction

" }}}
function! IsProjectHeaderLine(line) " {{{
   let l:project = TaskstackDetectHeaderName(a:line)
   return (len(l:project) > 0)
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
function! Notify(headline,contents) " {{{
    let l:command = ':!notify taskstack "false" "' . a:contents. '" "' . a:headline . '"'
    silent! exec l:command
    redraw!
endfunction

" }}}

" }}}
" vim: set sw=4 ft=vim fdm=marker cms=\ \"\ %s  :
