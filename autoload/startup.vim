" INFO: " {{{

" Maintainer:
"   Seth Milliken <seth_vim@araxia.net>
"   Araxia on #vim irc.freenode.net

" Version:
" 1.1 " 2014-03-13 17:24:17 PDT
" 1.0 " 2011-05-09 18:31:25 PDT

" Notes:
"   - Using OO prototyping; see :help self

" Todo:
"   - Make snippet for creating new host.

"}}}
"
" Create proper object based on hostname. " {{{
function! startup#handler()
    exe "return startup#" . startup#host() . "()"
endfunction

"}}}
" Determine hostname. " {{{
function! startup#host()
    if has('win32')
        let host = substitute(text#strip($USERDOMAIN), "-", "", "")
    else
        let host = toupper(text#strip(system('hostname -s')))
    end
    if host == ""
        let host = "base"
    endif
    return host
endfunction

"}}}

" Host prototype " {{{
function! startup#base()
    let s:obj = {}

    fun s:obj.class() dict
        return "base.class"
    endfun

    " Only run if subclass
    " (avoids triggering behavior on generic vim instances)
    fun s:obj.virtual() dict
        if self.class() == "base.class" | return 1 | end
    endfun

    fun s:obj.swapchoice() dict
        if self.virtual() | return | end
        if self.app() == "vimwikiApp"
            return "let v:swapchoice='e' \| set shortmess +=A"
        else
            return "let v:swapchoice='a' \| set shortmess +=A"
        endif
    endfun

    fun s:obj.vimhelpApp() dict
        help help
    endfun

    fun s:obj.docroot() dict
        return $HOME . "/sandbox/personal/"
    endfun

    fun s:obj.twitvimApp() dict
        if self.virtual() | return | end
        edit ~/.vim/twitcommands.vim
        so %
        let twitvim_count = 100
        VimSearch
        wincmd H
        wincmd t
        40wincmd  |
    endfun

    fun s:obj.todoApp() dict
        if self.virtual() | return | end
        exe 'edit' self.docroot() . "todo/todo.txt"
        vsplit | vsplit
        exe 'tabnew' self.docroot() . "todo/techtodo.txt"
        vsplit | vsplit
        exe 'tabnew' self.docroot() . "lists/readinglist.txt"
        exe 'vsplit' self.docroot() . "lists/videolist.txt"
        wincmd =
    endfun

    fun s:obj.colloquyvimApp() dict
        if self.virtual() | return | end
        call AdjustFont(-2)
        edit ~/.vim/swap/transcript.colloquy
    endfun

    fun s:obj.adiumvimApp() dict
        if self.virtual() | return | end
        call AdjustFont(-4)
        edit ~/.vim/swap/transcript.adium
    endfun

    fun s:obj.sourcecodeApp() dict
        if self.virtual() | return | end
        edit ~/.vim/.vimrc
        vsplit ~/.vim/.gvimrc | wincmd t | wincmd =
        tabnew ~/.vim/autoload/startup.vim | tabprev
    endfun

    fun! s:obj.scratchApp() dict
        exe 'edit' self.docroot() . "scratch.scratch"
    endfun

    fun s:obj.tasksApp() dict
        exe "edit " . self['TasksFile']()
        normal ggzo
    endfun

    fun! s:obj.pentadactylApp() dict
        edit $HOME/.pentadactyl/.pentadactylrc
        vsplit $HOME/.pentadactyl/colors/araxia.penta
        windo set nolist
        wincmd t | wincmd =
    endfun

    fun! s:obj.tmuxApp() dict
        exe "edit ~/.tmux/" . tolower(startup#host()) . ".tmux"
        vsplit ~/.tmux.conf
        windo set nolist
        wincmd t | wincmd =
    endfun

    fun! s:obj.vimwikiApp() dict
        VimwikiIndex
        set nolist
    endfun

    fun! s:obj.defaultApp() dict
        "echo "default gvim instance"
    endfun

    fun! s:obj.app() dict
        if !exists('g:vim_app_name')
            if strlen(v:servername) > 0 && !(match(v:servername, "VIM") > -1)
                let g:vim_app_name = v:servername
            elseif match($VIMRUNTIME, '\.app') > 0
                let g:vim_app_name = split(split($VIMRUNTIME, '\.app')[0], '/')[1]
            else
                let g:vim_app_name = "default"
            endif
        endif
        return tolower(g:vim_app_name) . "App"
    endfun

    fun s:obj.TasksFile() dict
        return self.docroot() . "todo/personal.tst.txt"
    endfun

    fun s:obj.handle() dict
        call self[self.app()]()
    endfun

    " constructor
    fun s:obj.New() dict
        let newobj = copy(self)
        let newobj.fieldname = []
        return newobj
    endfun

    return s:obj.New()
endfunction
" base }}}

" Host SAMSARA " {{{
function! startup#SAMSARA()
    let s:obj = startup#base()

    fun! s:obj.class() dict
        return "samara.class"
    endfun

    return s:obj.New()
endfunction

" }}}
" Host NOTABLE " {{{
function! startup#NOTABLE()
    let s:obj = startup#base()

    fun! s:obj.class() dict
        return "notable.class"
    endfun

    fun! s:obj.TasksFile() dict
        call AdjustFont(4)
        return self.docroot() . "todo/notable.tst"
    endfun

    return s:obj.New()
endfunction

" }}}
" Host SETH " {{{
function! startup#SETH()
    let s:obj = startup#base()

    fun! s:obj.myname() dict
        return "seth.class"
    endfun

    fun! s:obj.vimwikiApp() dict
        normal 3\ww
        set nolist
        call UaAbbreviations()
    endfun

    fun! s:obj.docroot() dict
        return $HOME . "/sandbox/work/"
    endfun

    fun! s:obj.todoApp() dict
        call AdjustFont(-2)
        exe 'edit' self.docroot() . "projects.tst"
    endfun

    fun! s:obj.scratchApp() dict
        exe 'edit' self.docroot() . "scratch.scratch"
    endfun

    fun! s:obj.slateApp() dict
        exe 'edit' ".slate.js"
        vsplit ~/.slate-layouts/office.js
        vsplit ~/.slate-layouts/work-internal.js
    endfun

    fun! s:obj.sourcecodeApp() dict
        exe 'cd ~/sandbox/code/'
        exe 'edit ~/sandbox/code/'
        call UaAbbreviations()
    endfun

    fun! s:obj.TasksFile() dict
        return self.docroot() . "work.tst.txt"
    endfun

    return s:obj.New()
endfunction

" }}}
" Host LABORATORY " {{{
function! startup#LABORATORY()
    let s:obj = startup#base()

    fun! s:obj.class() dict
        return "laboratory.class"
    endfun

    fun! s:obj.TasksFile() dict
        return self.docroot() . "todo/laboratory.tst"
    endfun

    return s:obj.New()
endfunction

" }}}
" Host SETH-PC " {{{
function! startup#SETHPC()
    let s:obj = startup#base()

    fun! s:obj.class() dict
        return "seth-pc.class"
    endfun

    fun s:obj.dotfilesApp() dict
        edit ~/vimfiles/.vimrc
    endfun

    fun s:obj.autohotkeyApp() dict
        edit ~/My Documents/AutoHotkey.ahk
    endfun

    fun! s:obj.TasksFile() dict
        return self.docroot() . "todo/wintodo.txt"
    endfun

    return s:obj.New()
endfunction

" }}}
" Host ROCKBOX " {{{
function! startup#ROCKBOX()
    let s:obj = startup#base()

    fun! s:obj.class() dict
        return "rockbox.class"
    endfun

    fun! s:obj.TasksFile() dict
        return "self.docroot() . "todo/laboratory.txt"
    endfun

    return s:obj.New()
endfunction

" }}}
" Host LOCALHOST " {{{
function! startup#LOCALHOST()
    let s:obj = startup#base()

    fun! s:obj.class() dict
        return "mobile.class"
    endfun

    fun! s:obj.autohotkeyApp() dict
        echo "AutoHotkey instance"
        edit ~/My Documents/AutoHotkey.ahk
    endfun

    fun! s:obj.TasksFile() dict
        return self.docroot() . "todo/mobile.txt"
    endfun

    return s:obj.New()
endfunction

" }}}
" Host PIX " {{{
function! startup#PIX()
    let s:obj = startup#base()

    fun! s:obj.class() dict
        return "pix.class"
    endfun

    fun! s:obj.awesomeApp() dict
        edit ~/.config/awesome/rc.lua
        vsplit ~/.config/awesome/themes/araxia/theme.lua
        wincmd t | wincmd =
    endfun

    fun! s:obj.tasksApp() dict
        exe "edit " . self['TasksFile']()
        normal ggzo
        vsplit ~/sandbox/personal/projects/pixel_setup.txt
        wincmd t | wincmd =
    endfun

    fun! s:obj.TasksFile() dict
        return self.docroot() . "todo/pix.tst.txt"
    endfun

    return s:obj.New()
endfunction

" }}}
" Host UNNWORKABLE " {{{
function! startup#UNWORKABLE()
    let s:obj = startup#base()

    fun! s:obj.class() dict
        return "unworkable.class"
    endfun

    fun! s:obj.vimwikiApp() dict
        VimwikiIndex
        set nolist
    endfun

    fun! s:obj.tasksApp() dict
        return self.docroot() . "ax/todo.txt"
    endfun

    fun! s:obj.defaultApp() dict
        echo "default vim instance"
    endfun

    fun! s:obj.notesApp() dict
        edit ~/ax/ideas.txt
        split ~/ax/setup.txt
        split ~/ax/todo.tst.txt
        wincmd H
        wincmd t | wincmd =
        vsplit ~/ax/weechat.txt
        windo set nolist
        wincmd t | wincmd =
    endfun

    fun! s:obj.weechatpApp() dict
        edit ~/.weechat_personal/weechat.conf
        vsplit ~/.weechat_personal/irc.conf
        vsplit ~/.weechat_personal/plugins.conf
        windo set nolist
        wincmd t | wincmd =
    endfun

    fun! s:obj.weechatApp() dict
        edit ~/.weechat/weechat.conf
        vsplit ~/.weechat/irc.conf
        vsplit ~/.weechat/plugins.conf
        windo set nolist
        wincmd t | wincmd =
    endfun

    fun! s:obj.tmuxApp() dict
        exe "edit ~/.tmux/" . toupper(startup#host()) . ".tmux"
        split ~/.tmux/ua.tmux
        split ~/.tmux.conf
        wincmd L
        windo set nolist
        wincmd t | wincmd =
    endfun

    return s:obj.New()
endfunction

" }}}

" vim: set ft=vim fdm=marker fdl=0 cms=\ \"\ %s  :
