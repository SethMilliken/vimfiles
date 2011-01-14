" GUI Setup "{{{
if version < 700 || exists("g:loaded_gvimrc")
    finish
end
" let g:loaded_gvimrc = 1

" Prototype-based settings Experiment {{{
" this == prototype
" self == runtime instance
let s:DefaultSettings = {}
function! s:DefaultSettings.New()
    let this = {}
    let this.os = "Unknown"
    function! this.setOptions()
        set t_Co=256
        set t_AB=[48;5;%dm
        set t_AF=[38;5;%dm
        set cursorline                                  " highlight current line
        color araxia
        "" No toolbar, please.
        set guioptions-=T
        "" Simple, informative gui tabs (dirty, number, name without path)
        set guitablabel=%m\ %N\ %t\ %r
        set tabpagemax=100
        " yank to system clipboard
        set clipboard=unnamed
    endfunction
    function! this.setMenus()
    endfunction
    function! this.setMappings()
    endfunction
    function! this.finished()
        echo self.os . " configured."
    endfunction
    return copy(this)
endfunction

let s:MacSettings = {}
function! s:MacSettings.New()
    let this = s:DefaultSettings.New()
    let this.os ="Mac OS X"
    function! this.setMappings()
        nmap <silent> <D-t>     <Esc>:101tabnew<CR>
    endfunction
    return copy(this)
endfunction

let s:WindowsSettings = {}
function! s:WindowsSettings.New()
    let this = s:MacSettings.New()
    function! this.setOptions()
        echo "faz"
    endfunction
    return copy(this)
endfunction

let settings = s:MacSettings.New()
call settings.setOptions()
call settings.setMenus()
call settings.setMappings()
call settings.finished()

" }}}

if has("gui_running")
    set t_Co=256
    set t_AB=[48;5;%dm
    set t_AF=[38;5;%dm
    set cursorline                                  " highlight current line
    color kellys
    "" No toolbar, please.
    set guioptions-=T
    "" Simple, informative gui tabs (dirty, number, name without path)
    set guitablabel=%m\ %N\ %t\ %r
    set tabpagemax=100
    " yank to system clipboard
    set clipboard=unnamed
else
    if (&t_Co > 8)
            color desert256
    else
            color elflord
    end
end
let g:os_unknown = "hypothesis"
if has("gui_macvim")
    color kellys
    " max vertical and horizontal columns on resize to full screen
    set fuopt=maxhorz,maxvert
    " set transparency=5
    set antialias
    set gfn=Inconsolata:h15
    " set a reasonable window size
    winsize 345 500
    unlet g:os_unknown
if has("win")
    set gfn=Terminal:h6
    " set a reasonable window size
    winsize 150 200
    unlet g:os_unknown
end
if exists("g:os_unknown")
    " generic defaults if os not detected
    set gfn=DejaVu\ Sans\ Mono\ 8
    set guioptons-=m
    end
end
" }}}
" MAPPINGS "{{{
" Mac vs Windows mappings?
"" Map Cmd-t to new tab
nmap <silent> <D-t>     <Esc>:101tabnew<CR>
"" Map Cmd-w to close buffer
nmap <silent> <D-w>     <Esc>:bd<CR>

""" Figure out correct map directive to prevent commands from having other side effects (like moving the cursor).

" NOTE: Have to unset menu commands in gvimrc
"
" Free Command Key Bindings {{{
macmenu File.Print key=<nop>
map <silent> <D-p> :ln <CR>
map <silent> <D-P> :lp <CR>
map <silent> <D-e> :cn <CR>
map <silent> <D-E> :cp <CR>

" }}}
" Command-T " {{{
macmenu Edit.Find.Find\.\.\. key=<nop>
map <D-f> :CommandT<CR>
" }}}

" Ctrl-Left to previous tab
nnoremap <silent> <C-Left>      <Esc>gT<CR>
" Ctrl-Right to next tab
nnoremap <silent> <C-Right>     <Esc>gt<CR>

" Ctrl-Up Increase font size
nnoremap <C-Up> :silent! :call AdjustFont(1)<CR>
" Ctrl-Down Decrease font size
nnoremap <C-Down> :silent! :call AdjustFont(-1)<CR>

function! AdjustFont(increment) "{{{
    let columns = &columns
    let lines = &lines
    let replacement = 'submatch(0) + ' . a:increment
    let &guifont = substitute( &guifont, ':h\zs\d\+', '\=eval(' .  replacement . ')', '')
    exe "set columns=" . (columns - (a:increment * 10))
    exe "set lines=" . (lines - (a:increment * 7))
endfunction

"}}}

"}}}
" vim:ft=vim:fdm=marker:nospell:cms=\ \"%s
