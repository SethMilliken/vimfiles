" GUI Setup: "{{{

" Load Check: " {{{
if version < 700 || exists("g:loaded_gvimrc")
    finish
end
" let g:loaded_gvimrc = 1

" }}}

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
        set tabpagemax=10
        " yank to system clipboard
        set clipboard=unnamed
    endfunction
    function! this.setMenus()
    endfunction
    function! this.setMappings()
    endfunction
    function! this.finished()
        " echo self.os . " configured."
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

" Basic: shared config " {{{
if has("gui_running")
    "set t_Co=256
    "set t_AB=[48;5;%dm                    " document this
    "set t_AF=[38;5;%dm                    " document this
    color araxia                             " hey, those are my colors!
    " no toolbar, no scrollbars
    for value in ['T','r','R','l','L']
        exec "set guioptions -=" . value
    endfor
    "" Simple, informative gui tabs (dirty, number, name without path)
    set tabpagemax=10                       " don't get ridiculous
else
    if (&t_Co > 8)
        color desert256                     " decent fallback if necessary
    else
        color araxia
    end
end

" }}}
" Mac: " {{{
if has("gui_macvim")
    " max vertical and horizontal columns on resize to full screen
    set fuopt=maxhorz,maxvert
    " set transparency=5
    set antialias
    " set guifont=Inconsolata:h15
    set guifont=Inconsolata\ for\ Powerline:h13
    winsize 345 500                         " set a reasonable window size
    " NOTE: Have to unset menu commands in gvimrc
    " Free Command Key Bindings " {{{
    "macm File.Close                            key=<D-w> action=performClose:
    macm File.Close                             key=<nop>
    "macm File.New\ Window                      key=<D-n> action=newWindow:
    "macm File.Save                             key=<D-s>
    "macm File.Save\ All                        key=<D-M-s> alt=YES
    "macm File.Save\ As\.\.\.                   key=<D-S>
    "macm File.Print                            key=<nop>
    " frees <D-b>
    "macm Tools.List\ Errors                    key=<nop>
    " frees <D-l>
    "macm Tools.Make                            key=<nop>
    " frees <D-m>
    "macm Window.Zoom                           key=<nop>
    " frees <D-t>
    macm File.New\ Tab                          key=<nop>
    " frees <D-T>
    macm File.Open\ Tab\.\.\.                   key=<D-M-t>  action=addNewTab:
    " frees <D-f>
    macm Edit.Find.Find\.\.\.                   key=<nop>
    " }}}

    "" Map Cmd-w to close buffer
    "nmap <silent> <D-w> <Esc>:bd<CR>
    nmap <silent> <D-w> <Esc>:tabclose<CR>

    "" Location list and quickfix navigation
    map  <silent> <D-p> :lne <CR>
    map  <silent> <D-P> :lp  <CR>
    map  <silent> <D-e> :cn  <CR>
    map  <silent> <D-E> :cp  <CR>

    "" Window resize
    map  <silent> <D-i> :winsize 999 999 \| wincmd =<CR>

    "" CommandT
    " TODO: map conditionally
    map <D-f>  :call RecursiveFileSearch(":CommandT")<CR>

    " Tab-page ewly created with <D-t> shouldn't be in insert mode
    " just because we happen to be in it on invocation.
    "inoreme 10.295 &File.New\ Tab                          <Esc>:tabnew<CR>
    "" Map Cmd-t to new tab, soliciting name
    exec "nmap <silent> <D-t>     <Esc>:" . &tabpagemax . " tabnew \\| :SolicitTabName<CR>"
    "" Map Cmd-Shift-t to rename tab
    exec "nmap <silent> <D-T>   <Esc>:SolicitTabName<CR>"
end

" }}}
" Windows: " {{{
if has("win32")
    "set guifont=Terminal:h6
    set guifont=Inconsolata:h12
    winsize 150 200                         " set a reasonable window size
end

" }}}

" }}}
" MAPPINGS: "{{{
" Ctrl-Left to previous tab
nnoremap <silent> <C-Left>      <Esc>gT<CR>
" Ctrl-Right to next tab
nnoremap <silent> <C-Right>     <Esc>gt<CR>

" Ctrl-Up Increase font size
nnoremap <C-Up> :silent! call AdjustFont(1)<CR>
" Ctrl-Down Decrease font size
nnoremap <C-Down> :silent! call AdjustFont(-1)<CR>

function! AdjustFont(increment) " {{{
    " TODO: work out better resizing heuristic here
    let columns = &columns
    let lines = &lines
    let replacement = 'submatch(0) + ' . a:increment
    let &guifont = substitute( &guifont, ':h\zs\d\+', '\=eval(' .  replacement . ')', '')
    "exe "set columns=" . (columns - (a:increment * 10))
    "exe "set lines=" . (lines - (a:increment * 7))
endfunction

"}}}

set guitablabel=%!MyGuiTabLabel()

"}}}
" vim:ft=vim:fdm=marker:nospell:cms=\ \"\ %s
