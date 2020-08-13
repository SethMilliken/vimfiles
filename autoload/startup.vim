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
    let l:host = startup#host()
    if exists("*startup#" . l:host)
        exe "return startup#" . l:host . "()"
    else
        exe "return startup#defaults()"
    endif
endfunction

"}}}
" Determine hostname: " {{{
function! startup#host()
    if has('win32')
        let host = substitute(text#strip($USERDOMAIN), "-", "", "")
    else
        let host = toupper(text#strip(system('hostname -s')))
    end
    if host =~ 'A-.*'
        let host = "AIRSHIP"
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

    " Always override this in subclasses.
    fun s:obj.class() dict
        return "base"
    endfun

    " Only run if subclass
    "
    " (avoids triggering behavior on generic vim instances)
    " Add to beginning of methods to protect:
    "
    "  if self.virtual() | return | end
    "
    fun s:obj.virtual() dict
        if self.class() =~ "\(base\|defaults\)" | return 1 | end
    endfun

    " Used to suppress swap file warnings
    fun s:obj.swaphandle() dict
        if self.virtual() | return | end
        let v:swapchoice='e'
        set shortmess +=A
    endfun

    fun! s:obj.app() dict
        if !exists('g:vim_app_name')
            if strlen(v:servername) > 0 && !match(v:servername, "^VIM$") == 0
                let g:vim_app_name = v:servername
            elseif match($VIMRUNTIME, '\.app') > 0
                let g:vim_app_name = split(split($VIMRUNTIME, '\.app')[0], '/')[-1]
            else
                let g:vim_app_name = "default"
            endif
        endif
        return tolower(g:vim_app_name) . "App"
    endfun

    fun s:obj.handle() dict
        call self.swaphandle()
        try
            call self[self.app()]()
        catch
            call self["defaultApp"]()
        endtry
    endfun

    " constructor
    fun s:obj.New() dict
        let newobj = copy(self)
        return newobj
    endfun

    return s:obj.New()
endfunction
" base }}}

" Host Defaults " {{{
function! startup#defaults()
    let s:obj = startup#base()

    fun! s:obj.class() dict
        return "defaults"
    endfun

    fun s:obj.docroot() dict
        return $HOME . "/sandbox/personal/"
    endfun

    fun! s:obj.personalroot() dict
        return $HOME . "/sandbox/personal/"
    endfun

    fun s:obj.TasksFile() dict
        return self.personalroot() . "todo/" . self.class() . ".tst.txt"
    endfun

    " Apps
    fun! s:obj.wmApp() dict
        exe 'edit' "$HOME/.hammerspoon/init.lua"
        vsplit $HOME/.hammerspoon/bindings.lua
        windo set noro
        wincmd t | wincmd =
    endfun

    fun! s:vimhome() dict
        return "~/.vim/"
    endfun

    fun! s:obj.vimApp() dict
        if self.virtual() | return | end
        exe "edit " . self.vimhome() . "vimrc"
        exe "vsplit " . self.vimhome() . "gvimrc | wincmd t | wincmd ="
        exec "tabnew " . self.vimhome() . "autoload/startup.vim"
        tab help
        tabfirst
    endfun

    fun s:obj.vimhelpApp() dict
        help help
    endfun

    fun s:obj.shfApp() dict
        e ~/.shell-functions
    endfun

    fun s:obj.zappApp() dict
        e ~/.shell-functions
        /function zapp()
        normal zz
    endfun


    fun s:obj.twitvimApp() dict
        edit ~/.vim/twitcommands.vim
        so %
        let twitvim_count = 100
        VimSearch
        wincmd H
        wincmd t
        40wincmd  |
    endfun

    fun s:obj.listsApp() dict
        exe 'edit' self.docroot() . "lists/readinglist.txt"
        exe 'vsplit' self.docroot() . "lists/videolist.txt"
        exe 'vsplit' self.docroot() . "lists/musiclist.txt"
        exe 'vsplit' self.docroot() . "lists/wishlist.txt"
        wincmd t | wincmd =
    endfun

    fun s:obj.todoApp() dict
        exe 'edit' self.docroot() . "todo/todo.txt"
        exe 'vsplit' self.docroot() . "todo/techtodo.txt"
        wincmd t | wincmd =
    endfun

    fun s:obj.colloquyvimApp() dict
        call AdjustFont(-2)
        edit ~/.vim/swap/transcript.colloquy
    endfun

    fun s:obj.adiumvimApp() dict
        call AdjustFont(-4)
        edit ~/.vim/swap/transcript.adium
    endfun

    fun s:obj.sourcecodeApp() dict
        edit ~/.vim/vimrc
        vsplit ~/.vim/gvimrc | wincmd t | wincmd =
        tabnew ~/.vim/autoload/startup.vim | tabprev
    endfun

    fun! s:obj.scratchApp() dict
        exe 'edit' self.docroot() . "scratch.scratch"
    endfun

    fun! s:obj.workscratchApp() dict
        exe ':WorkScratch'
    endfun

    fun! s:obj.worktodoApp() dict
        exe ':WorkTodo'
    endfun


    fun! s:obj.slateApp() dict
        exe 'edit' ".slate.js"
    endfun

    fun s:obj.tasksApp() dict
        exe "edit " . self['TasksFile']()
        normal ggzo
    endfun

    fun! s:obj.dactylApp() dict
        " edit $HOME/.pentadactyl/.pentadactylrc
        " vsplit $HOME/.pentadactyl/colors/araxia.penta
        " windo set nolist
        " wincmd t | wincmd =
        tabedit $HOME/.tridactylrc
    endfun

    fun! s:obj.tmuxApp() dict
        exe "edit ~/.tmux/profiles/" . tolower(startup#host()) . ".tmux"
        vsplit ~/.tmux/.tmux.conf
        windo set nolist
        wincmd t | wincmd =
    endfun

    fun! s:obj.vimwikiApp() dict
        VimwikiIndex
        set nolist
    endfun

    fun! s:obj.writeApp() dict
        call EditCurrentEntry()
        vsplit
        call EditCurrentIndex()
        exe 'cd' pages#root()
        wincmd h | wincmd =
    endfun

    fun! s:obj.readApp() dict
        exe 'cd' self.personalroot() . "zaurus/zlog/"
        exe "Reading"
        exe "NERDTree"
        normal G
        wincmd t
    endfun

    fun! s:obj.missivesApp() dict
        exe 'cd' self.personalroot() . "writing/missives/"
        exe 'edit' "scratchpad.tst"
        exe 'vsplit' self.personalroot() . "todo/write.tst"
        wincmd t | wincmd =
    endfun

    fun! s:obj.dairecApp() dict
        exe 'cd' self.personalroot() . "dairec/"
        exe 'edit' "summ.txt"
        normal Gk$
        exe 'split' "stat.txt"
        normal ggjw
        tabnew ~/.vim/bundle/vim-daily-record/ftplugin/dairec.vim
        vsplit ~/.vim/bundle/vim-daily-record/ftdetect/dairec.vim
        wincmd h
        1tabn
    endfun

    fun! s:obj.mailApp() dict
        exe 'cd' "$HOME/.procmail/"
        exe 'edit' "priority_moderate"
        exe 'vsplit' "priority_impersonal"
        exe 'vsplit' "priority_receipt"
        exe 'vsplit' "priority_high"
        exe 'split' "valid_addresses"
        exe 'tabnew' "prescreen.rc"
        exe 'split' "highlight.rc"
        exe 'tabnew' "lists.rc"
        exe 'tabnew' "blacklist"
        exe 'vsplit' "blacklines"
        exe 'split' "strictdomains"
        wincmd h
        1tabn
    endfun

    fun! s:obj.defaultApp() dict
        "echo "default gvim instance"
    endfun

    fun! s:obj.macvimApp() dict
        " echo "default MacVim instance"
    endfun

    fun! s:obj.qrithApp() dict
        exe 'edit' self.personalroot() . "projects/qrith.txt"
    endfun

    fun! s:obj.tmuxApp() dict
        exe "edit ~/.tmux/profiles/" . toupper(startup#host()) . ".tmux"
        vsplit ~/.tmux/profiles/ua.tmux
        vsplit ~/.tmux/profiles/write.tmux
        wincmd L
        windo set nolist
        wincmd t | wincmd =
        tabedit ~/.tmux/functions/mode-app-keys.tmux
        tabedit ~/.tmux/themes/araxia.theme.tmux
        tabedit ~/.tmux/main.tmux
        vsplit ~/.tmux/.tmux.conf
        wincmd L
        windo set nolist
        wincmd t | wincmd =
    endfun

    return s:obj.New()
endfunction

" defaults }}}

" Host SAMSARA " {{{
function! startup#SAMSARA()
    let s:obj = startup#defaults()

    fun! s:obj.class() dict
        return "samara"
    endfun

    fun! s:obj.slateApp() dict
        exe 'edit' ".slate.js"
        vsplit ~/.slate-layouts/office.js
        vsplit ~/.slate-layouts/work-internal.js
        windo set nolist
        wincmd t | wincmd =
    endfun

    return s:obj.New()
endfunction

" }}}
" Host NOTABLE " {{{
function! startup#NOTABLE()
    let s:obj = startup#defaults()

    fun! s:obj.class() dict
        return "notable"
    endfun

    fun! s:obj.TasksFile() dict
        call AdjustFont(4)
        return self.docroot() . "todo/notable.tst"
    endfun

    return s:obj.New()
endfunction

" }}}
" Host AIRSHIP" {{{
function! startup#AIRSHIP()
    let s:obj = startup#defaults()

    fun! s:obj.class() dict
        return "ua"
    endfun

    fun! s:obj.docroot() dict
        return $HOME . "/sandbox/work/"
    endfun

    fun! s:obj.vimwikiApp() dict
        normal 3\ww
        set nolist
        call UaAbbreviations()
    endfun

    fun! s:obj.todoApp() dict
        call AdjustFont(-2)
        exe 'edit' self.docroot() . "projects.tst"
    endfun

    fun! s:obj.scratchApp() dict
        exe 'edit' self.docroot() . "scratch.scratch"
        exe 'tabnew' self.personalroot() . "scratch.scratch"
        tabfirst
    endfun

    fun! s:obj.wmApp() dict
        exe 'edit' "$HOME/.hammerspoon/init.lua"
        vsplit $HOME/.hammerspoon/bindings.lua
        wincmd t | wincmd =
        tabe $HOME/.slate.js
        vsplit $HOME/.slate-layouts/office.js
        vsplit $HOME/.slate-layouts/work-internal.js
        windo set noro
        wincmd t | wincmd =
        tabfirst
    endfun

    fun! s:obj.sourcecodeApp() dict
        exe 'cd ~/sandbox/code/'
        exe 'edit ~/sandbox/code/'
        call UaAbbreviations()
    endfun

    fun! s:obj.tmuxApp() dict
        exe "edit ~/.tmux/profiles/" . toupper(startup#host()) . ".tmux"
        split ~/.tmux/main.tmux
        split ~/.tmux/.tmux.conf
        split ~/.tmux/profiles/pass-be.tmux
        wincmd L
        windo set nolist
        windo set noro
        wincmd t | wincmd =
    endfun

    fun! s:obj.gcpApp() dict
        exe 'edit' "services/wallet.yaml"
        exe 'vsplit' "services/wallet-callbacks.yaml"
        wincmd h
    endfun

    fun! s:obj.TasksFile() dict
        return self.docroot() . "work.tst.txt"
    endfun

    return s:obj.New()
endfunction

" }}}
" Host SETH " {{{
function! startup#SETH()
    let s:obj = startup#defaults()

    fun! s:obj.class() dict
        return "seth"
    endfun

    fun! s:obj.scratchApp() dict
        exe 'edit' self.docroot() . "scratch.scratch"
        exe 'tabnew' self.personalroot() . "scratch.scratch"
        tabfirst
    endfun

    fun! s:obj.wmApp() dict
        exe 'edit' "$HOME/.hammerspoon/init.lua"
        vsplit $HOME/.hammerspoon/bindings.lua
        wincmd t | wincmd =
        tabe $HOME/.slate.js
        vsplit $HOME/.slate-layouts/office.js
        vsplit $HOME/.slate-layouts/work-internal.js
        windo set noro
        wincmd t | wincmd =
        tabfirst
    endfun

    return s:obj.New()
endfunction

" }}}
" Host LABORATORY " {{{
function! startup#LABORATORY()
    let s:obj = startup#defaults()

    fun! s:obj.class() dict
        return "laboratory"
    endfun

    fun! s:obj.TasksFile() dict
        return self.docroot() . "todo/laboratory.tst"
    endfun

    return s:obj.New()
endfunction

" }}}
" Host SETH-PC " {{{
function! startup#SETHPC()
    let s:obj = startup#defaults()

    fun! s:obj.class() dict
        return "seth-pc"
    endfun

    fun! s:obj.vimhome() dict
        return "~/vimfiles/"
    endfun

    fun s:obj.ahkApp() dict
        edit ~/My Documents/AutoHotkey.ahk
    endfun

    fun! s:obj.TasksFile() dict
        return self.docroot() . "todo/wintodo.txt"
    endfun

    return s:obj.New()
endfunction

" }}}
" Host KSANTI " {{{
function! startup#KSANTI()
    let s:obj = startup#defaults()

    fun! s:obj.class() dict
        return "ksanti"
    endfun

    fun! s:obj.vimhome() dict
        return "~/vimfiles/"
    endfun

    fun! s:obj.ahkApp() dict
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
    let s:obj = startup#defaults()

    fun! s:obj.class() dict
        return "rockbox"
    endfun

    return s:obj.New()
endfunction

" }}}
" Host PIX " {{{
function! startup#PIX()
    let s:obj = startup#defaults()

    fun! s:obj.class() dict
        return "pix"
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

    return s:obj.New()
endfunction

" }}}
" Host ARAXIA " {{{
function! startup#ARAXIA()
    let s:obj = startup#defaults()

    fun! s:obj.class() dict
        return "araxia"
    endfun

    fun! s:obj.TasksFile() dict
        return self.docroot() . "ax/todo.txt"
    endfun

    fun! s:obj.todoApp() dict
        exe 'edit' self.docroot() . "todo/todo.txt"
        exe 'vsplit' self.docroot() . "todo/techtodo.txt"
        wincmd h
        exe 'tabedit' self.docroot() . "lists/readinglist.txt"
        exe 'vsplit' self.docroot() . "lists/videolist.txt"
        wincmd h
        exe 'tabedit' self.docroot() . "todo/araxia.tst"
        exe 'vsplit' self.docroot() . "todo/wintodo.txt"
        1tabn
    endfun

    fun! s:obj.notesApp() dict
        exe "edit" self.docroot() . "todo/araxia.tst"
        exe "vsplit" self.docroot() . "todo/weechat.txt"
        wincmd t | wincmd =
    endfun

    fun! s:obj.scratchApp() dict
        exe 'edit' self.personalroot() . "scratch.scratch"
        exe 'vsplit' "todo/weechat.txt"
        wincmd h
        exe 'tabnew' "projects/guitar.txt"
        1tabn
    endfun

    fun! s:obj.qrithApp() dict
        exe 'cd' self.personalroot() . "qrith-player-notes/season3"
        exe 'edit' "ongoing.txt"
        exe 'vsplit' "inventory.txt"
        exe 'split' "unanswered_questions.txt"
        wincmd h
        exe 'tabnew' "."
        " open last few session notes in vsplits
        normal GGkkkgskgskgskgs
        1tabn
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

    return s:obj.New()
endfunction

" }}}
" Host RETCONSOLE " {{{
function! startup#RETCONSOLE()
    let s:obj = startup#defaults()

    fun! s:obj.class() dict
        return "retconsole"
    endfun

    fun! s:obj.wmApp() dict
        exe 'edit' "$HOME/.hammerspoon/init.lua"
        vsplit $HOME/.hammerspoon/bindings.lua
        windo set noro
        wincmd t | wincmd =
    endfun

    return s:obj.New()
endfunction

" }}}

" vim: set ft=vim fdm=marker fdl=0 cms=\ \"\ %s  :
