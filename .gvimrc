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
    set guifont=Inconsolata:h15
    winsize 345 500                         " set a reasonable window size
    "" Map Cmd-t to new tab
    exec "nmap <silent> <D-t>     <Esc>:" . &tabpagemax . " tabnew \\| :SolicitTabName<CR>"
    "" Map Cmd-w to close buffer
    nmap <silent> <D-w>     <Esc>:bd<CR>
    " NOTE: Have to unset menu commands in gvimrc
    " Free Command Key Bindings " {{{
  macm File.New\ Window				key=<D-n> action=newWindow:
  "macm File.New\ Tab				key=
  macm File.Close				key=<D-w> action=performClose:
  macm File.Save<Tab>:w				key=<D-s>
  macm File.Save\ All				key=<D-M-s> alt=YES
  macm File.Save\ As\.\.\.<Tab>:sav		key=<D-S>
"    macmenu File.Print key=<nop>
"    macmenu Window.Zoom key=<nop>
    map <silent> <D-p> :ln <CR>
    map <silent> <D-P> :lp <CR>
    map <silent> <D-e> :cn <CR>
    map <silent> <D-E> :cp <CR>
    map <silent> <D-i> :winsize 999 999 \| wincmd =<CR>

    " }}}
    " Command-T " {{{
    macmenu Edit.Find.Find\.\.\. key=<nop>
    map <D-f> :CommandT<CR>
    " }}}
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
