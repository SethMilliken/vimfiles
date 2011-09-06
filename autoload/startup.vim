" INFO: " {{{

" Maintainer:
"   Seth Milliken <seth_vim@araxia.net>
"   Araxia on #vim irc.freenode.net

" Version:
" 1.0 " 2011-05-09 18:31:25 PDT

" Notes:
"   - Using OO prototyping; see :help self

" Todo:
"   - Make snippet for creating new host.

"}}}
"
" Create proper object based on hostname. " {{{
function! startup#handler()
    if has('win32')
        let host = substitute(text#strip($USERDOMAIN), "-", "", "")
    else
        let host = text#strip(system('echo $SHORTHOST'))
    end
    if host == ""
        return startup#base()
    else
        exe "return startup#" . host . "()"
    endif
endfunction

"}}}

" Host prototype " {{{
function! startup#base()
    let s:obj = {}

    fun s:obj.class() dict
        return "base.class"
    endfun

    fun s:obj.swapchoice() dict
        if self.app() == "Vimwiki"
            return "let v:swapchoice='e'"
        else
            return "let v:swapchoice='a'"
        endif
    endfun

    fun s:obj.VimHelp() dict
        help help
    endfun

    fun s:obj.TwitVim() dict
        edit ~/.vim/twitcommands.vim
        so %
        let twitvim_count = 100
        VimSearch
        wincmd H
        wincmd t
        40wincmd  |
    endfun

    fun s:obj.Todo() dict
        call AdjustFont(-2)
        edit ~/sandbox/personal/todo/todo.txt
        vsplit | vsplit
        tabnew ~/sandbox/personal/todo/techtodo.txt
        vsplit | vsplit
        tabnew ~/sandbox/personal/lists/readinglist.txt
        vsplit ~/sandbox/personal/lists/videolist.txt
        wincmd =
    endfun

    fun s:obj.ColloquyVim() dict
        call AdjustFont(-2)
        edit ~/.vim/swap/transcript.colloquy
    endfun

    fun s:obj.AdiumVim() dict
        call AdjustFont(-4)
        edit ~/.vim/swap/transcript.adium
    endfun

    fun s:obj.MacVim() dict
        call AdjustFont(-2)
        edit ~/.vim/.vimrc
        vsplit ~/.vim/.gvimrc | wincmd t | wincmd =
    endfun

    fun s:obj.Scratch() dict
        edit ~/.vim/swap/scratch.scratch
        call SmallWindow()
    endfun

    fun s:obj.Tasks() dict
        call AdjustFont(-2)
        winsize 120 100
        exe "edit " . self['TasksFile']()
        normal ggzo
    endfun

    fun s:obj.TasksFile() dict
        return "~/sandbox/personal/todo/personal.tst.txt"
    endfun

    fun s:obj.app() dict
        return split(split($VIMRUNTIME, ".app")[0], '/')[1]
    endfun

    fun s:obj.handle() dict
        echo self.app()
        silent! call self[self.app()]()
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

    fun! s:obj.Vimwiki() dict
        VimwikiIndex
        set nolist
    endfun

    fun! s:obj.SourceCode() dict
        edit ~/sandbox/code/
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

    fun! s:obj.Vimwiki() dict
        normal 3\ww
        set nolist
        call JanrainAbbreviations()
    endfun

    fun! s:obj.SourceCode() dict
        exe 'cd' g:engage_dir
        exe 'edit' g:engage_dir
        call JanrainAbbreviations()
    endfun

    fun! s:obj.TasksFile() dict
        return "~/sandbox/work/janrain.tst.txt"
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
        return "~/sandbox/personal/todo/laboratory.tst"
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

    fun! s:obj.TasksFile() dict
        return "~/sandbox/personal/todo/wintodo.txt"
    endfun

    fun! s:obj.Default() dict
        echo "default gvim instance"
    endfun

    fun! s:obj.app() dict
        if !exists('g:vim_app_name')
            let g:vim_app_name = "Default"
        endif
        return g:vim_app_name
    endfun

    return s:obj.New()
endfunction

" }}}

" vim: set ft=vim fdm=marker fdl=0 cms=\ \"\ %s  :
