" INFO: " {{{

" Maintainer:
"   Seth Milliken <seth_vim@araxia.net>
"   Araxia on #vim irc.freenode.net

" Version:
" 1.2 " 2011-05-04 16:34:09 PDT

" Notes:
"   - I'm deliberately overloading <C-e> and <C-y> for what i consider to be
"     more useful purposes.
"   - In this file (as in most of my editing), I try to create distinct groupings
"     in such a way that I can easily use simple text-object operations
"     on them (vap, yap, etc.).
"   - Folds can be quickly selected simply by closing the fold (za) and yanking
"     the folded line (yy).
"   - /^""/ indicate intentionally disabled options

" Todo:
"   - make .vimrc re-source-able without sideeffects (guards around au, maps, etc.)
"   - Fix <D- conflicts
"   - clean up SETTINGS; provide better descriptions
"   - for clarity, replace abbreviated forms of options in all settings
"   - annotate all line noise, especially statusline
"   - create keybindings for new location list fold header navigation mechanism
"   - consider: is keeping example .vimrc useful
"   - consider: add tw setting to .vimrc modeline
"   - consider: move ft-specific settings to individual files

" Pathogen: " {{{
set rtp+=~/.vim/bundle/pathogen/
set rtp+=~/vimfiles
set rtp+=~/vimfiles/bundle/pathogen/
call pathogen#infect()
"let g:did_install_default_menus = 1 " disable default macvim menus
let g:did_install_syntax_menu = 1
let g:vimwiki_menu = ''

" }}}
" Powerline: " {{{
let g:Powerline_symbols = 'fancy'

" }}}

"}}}
" DEFAULTS: from example .vimrc " {{{
" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
    finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
    set nobackup        " do not keep a backup file, use versions instead
else
    set backup      " keep a backup file
endif
set ruler           " show the cursor position all the time
set showcmd         " display incomplete commands
set incsearch       " do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
    au!

    " For all text files set 'textwidth' to 78 characters.
    " autocmd FileType text setlocal textwidth=78
    " Ummmmm...no! --Seth

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

    augroup END
    set autoindent      " always set autoindenting on
endif " has("autocmd")
"}}}
" Seth Milliken additions
" SETTINGS: " {{{
set shell=bash                      " some issues with zsh
set encoding=UTF-8                  " use UTF-8 encoding
set fileencoding=UTF-8              " use UTF-8 encoding as default
set shortmess+=I                    " don't show intro on start
""set shortmess+=A                  " don't show message on existing swapfile (set in an autocmd below)
set nospell                         " spelling off by default
set spellcapcheck=off               " ignore case in spellcheck
set nolist                          " don't show invisibles
set listchars=tab:>-,trail:-        " ...but make them look nice when they do show
set iskeyword+=-                    " usually do not want - to divide words
set lbr                             " wrap lines at word breaks
set noautoindent                    " don't like autoindent
set autowrite                       " auto write changes when switching buffers
set tabstop=8                       " default tab stop width
set softtabstop=4                   " set a narrow tab width
set shiftwidth=4                    " and keep sw & sts in sync
set expandtab                       " expand tabs to spaces
set list                            " and consequently, reveal tabs by default now
set nobackup                        " don't like ~ files littered about; don't need
set laststatus=2                    " always show the status line
set diffopt+=vertical               " use vertical splits for diff
set splitright                      " open vertical splits to the right
set splitbelow                      " open horizonal splits below
" set winfixheight                    " keep existing window height when possible
set winminheight=0                  " minimized horizontal splits show only statusline
set switchbuf=useopen               " when switching to a buffer, go to where it's already open
set history=10000                   " keep craploads of command history
set undolevels=500                  " keep lots of undo history
set foldlevelstart=9                " first level of folds open by default
set foldmethod=marker               " use markers for the default foldmethod
set foldopen+=jump                  " jumps open folds, too
set display+=lastline               " always show as much of the last line as possible
set guioptions+=c                   " always use console dialogs (faster)
set guioptions-=m                   " no menu
set noerrorbells                    " don't need to hear if i hit esc twice
set visualbell | set t_vb=          " ...nor see it
set ignorecase                      " case ignored for searches
set smartcase                       " override ignorecase for searches with uppercase
set clipboard=unnamed               " share os pasteboard
set cursorline                      " highlight current line
set wildmenu                        " show completion options
set autoread                        " automatically reread fs changed files *autoread*
set shellslash                      " always use /
set undofile                        " experimental: will i actually use this?

colorscheme araxia

let mapleader="\\"                  " <Leader>
"let mapleader="\<CR>"                  " <Leader>

"set foldcolumn=4                   " trying out fold indicator column
"set display+=uhex                  " show unprintable hex characters as <xx>
"let mapleader="\<Space>"                  " experiment with using <Space> as <Leader>.

" use relative line numbers if available, otherwise just use line numbers
exec "au BufReadPost * setl" (version > 702 ? 'rnu' : 'nu')

set wildignore+=*.o,*.sw?,*.git,*.svn,*.hg,**/build,*.?ib,*.png,*.jpg,*.jpeg,
            \*.mov,*.gif,*.bom,*.azw,*.lpr,*.mbp,*.mode1v3,*.gz,*.vmwarevm,
            \*.rtf,*.pkg,*.developerprofile,*.xcodeproj,*.pdf,*.dmg,
            \*.db,*.otf,*.bz2,*.tiff,*.iso,*.jar,*.dat,**/Cache,*.cache,
            \*.sqlite*,*.collection,*.qsindex,*.qsplugin,*.growlTicket,
            \*.part,*.ics,*.ico,**/iPhone\ Simulator,*.lock*,*.webbookmark

" Tags: universal location
set tags+=$HOME/sandbox/personal/tags
set tags+=$HOME/.vim/tags

" Swap: centralized with unique names via //
set directory=$HOME/.vim/swap//,$HOME/vimfiles/swap//

" Undo: centralized with unique names via //
set undodir=$HOME/.vim/undo//,~/vimfiles/undo//

" Sessionopts: defaults are blank,buffers,curdir,folds,help,options,tabpages,winsize
set ssop=blank,buffers,curdir,folds,help,resize,slash,tabpages,unix,winpos,winsize

" Statusline: TODO: annotate this status line
set statusline=%<\(%n\)\ %m%y%r\ %f\ %=%-14.(%l,%c%V%)\ %P
" wc:%{WordCount()}

"}}}
" MAPPINGS: " {{{

" Zaurus: <C-Space> (<C-k><C-Space>) to invoke command mode in both insert and normal mode " {{{
imap <Nul> <Esc>:
nnoremap <Nul> :

" }}}
" Annoyances: " {{{
" Use my own help function for F1
map <F1> :Help<CR>
imap <F1> <Esc>:Help<CR>
" I frequently hold shift too long...
command! W :w
" Handy but doesn't work in terminal
nmap <S-Space> <C-f>

" c & p normalization
nmap dD :normal! _y$"_dd<CR>
vmap dD :normal! gvygv"_x<CR>
vmap <BS> :normal! gv"_x<CR>
vmap dC :normal gv"_xP<CR>
"nnoremap <Leader>p :call text#append_line(getreg("*"), "below")<CR>
"nnoremap <Leader>P :call text#append_line(getreg("*"), "above")<CR>
nnoremap <expr> <Leader>p ':put ' . v:register . '<CR>'
nnoremap <expr> <Leader>P ':put! ' . v:register . '<CR>'

" sane-itize Y
map Y y$

" Undoable deletes in insert
inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-u>

" Extended Navigation
nmap <C-e>h :bnext<CR>
nmap <C-e>l :bprev<CR>
nmap <C-e>j :Herenow<CR>
nmap <C-e>k :exec ":lcd .." \| echo "cwd now: " . getcwd()<CR>

map g$ :tablast<CR>

" tmux copy/paste issue in mac os x workaround
nmap <C-x>p :call system("ssh localhost pbcopy", getreg('*')) \| echo "Copied default register to pasteboard."<CR>

" }}}
" Reset: restore some default settings and redraw " {{{
nnoremap <silent> <C-l> :call Reset() \| nohls<CR>
imap <silent> <C-l> <Esc><C-l>

" }}}
" Custom: <C-y> prefixed custom commands " {{{
" Reload .vimrc
imap <C-y>v <Esc><C-y>v
nmap <C-y>v :call ReloadVimrc()<CR>
" Reload snippets
nmap <C-y>s :SnipUp<CR>
nmap <C-y>S :call feedkeys(":call OpenRelatedSnippetFileInVsplit()\r\<Tab>\<Tab>", 't')<CR>
nmap <C-y>a :AbbUp<CR>
nmap <C-y>A :vsplit ~/.vim/plugin/iabbs.vim<CR>
nmap <C-y>w :%s/\s\+$//e<CR>:echo "Whitespace-b-gone."<CR>

" File path to pasteboard
map <Leader>f :call text#file_to_pasteboard()<CR>
map <Leader>F :call text#file_to_pasteboard(line("."))<CR>

" Commit file
map <Leader>o :call CheckinCheckup("show_prompt")<CR>

" }}}
" Utility: word count of current file " {{{
nmap <silent> <Leader>w :!wc -w %<CR>

" }}}
" Manual Tail: reload buffer from disk and go to end " {{{
nmap <silent> <C-e>0 :e<CR>G

" }}}
" Save Session: " {{{
nmap <Leader>\ :call CommitSession()<CR>

" }}}
" Journal: " {{{
nmap <Leader>j :call JournalEntry()<CR>
command! Journal :call JournalEntry()

" }}}
" Misc: " {{{
nmap <silent> <Leader>] :NERDTreeToggle<CR>
nmap <silent> <Leader>[ :TagbarToggle<CR>
nmap <silent> <Leader>- :GundoToggle<CR>
nmap <silent> <Leader>s :TBrowseScriptnames<CR>
nmap <silent> <Leader>b :call feedkeys(":TBrowseOutput\<Space>", "t")<CR>

" }}}
" Folds: " {{{
nmap <silent> <Leader>= :call FoldDefaultNodes()<CR>:normal zv]z[zzt<CR><C-l>
nmap <silent> <Leader>0 :silent normal zvzt<CR><C-l>

" }}}
" Scratch Buffer: close with ZZ " {{{
nmap <silent> <Leader>c :call ScratchBuffer("scratch")<CR>

" }}}
" Open URIs: " {{{
nmap <silent> <Leader>/ :call HandleURI()<CR>
nmap <silent> <Leader>t :call HandleMantis()<CR>

" }}}
" SQL: grab and format sql statement from current line " {{{
nmap <silent> <Leader>q :call FormatSqlStatement()<CR>

" }}}
" Formatting: Wrap current or immediately preceding word in in <em> tag " {{{
" Use surround.vim: csw<em>?
" nmap <Leader>_ Bi<em><Esc>ea</em>

" }}}
" Completion: show completion preview, without actually completing " {{{
inoremap <C-p> <C-r>=pumvisible() ? "\<lt>Up>" : "\<lt>C-o>:set completeopt+=menuone\<lt>CR>a\<lt>C-n>\<lt>C-p>"<CR>
"inoremap <C-n> <C-r>=pumvisible() ? "\<lt>Down>" : "\<lt>C-o>:set completeopt+=menuone\<lt>CR>a\<lt>C-p>\<lt>C-n>"<CR>

" }}}
" Help: help help help " {{{
nmap <Leader>hw     :help<CR>:silent call AdjustFont(-4)<CR>:set columns=115 lines=999<CR>:winc _<CR>:winc \|<CR>:help<Space>
nmap <Leader>hg     :HelpGrep<CR>
command! Help :call HelpSmart()
command! HelpGrep :call HelpSmart("grep")
function! HelpSmart(...)" {{{
    if a:0 > 0
        let l:commandname = "helpgrep "
    else
        let l:commandname = "help "
    end
    let l:additional = ""
    let l:setup = ""
    let l:topic = input("Requested " . l:commandname . "topic: ", "", "help")
    if len(l:topic) > 0
        tabfirst
        if expand("%") == ""
            let l:additional = " | only | normal zt"
        elseif &buftype != "help"
            let l:setup = "0tab "
        endif
        exec ":" . l:setup . l:commandname . l:topic . l:additional
    endif
endfunction

" }}}
" }}}
" Navigation: shortcuts " {{{
nmap <C-e>/ :call HeaderLocationIndex()<CR>
nmap <C-e>? :call FunctionLocationIndex()<CR>
nmap <C-e>d :silent! lclose<CR>
nmap <C-e>n :call SectionHeadNav(1, 0)<CR>
nmap <C-e>N :call SectionHeadNav(1, 1)<CR>
nmap <C-e>p :call SectionHeadNav(-1, 0)<CR>
nmap <C-e>P :call SectionHeadNav(-1, 1)<CR>
function! SectionHeadNav(count, mode) " {{{
    " TODO: mb preserve hls value and restore it?
    if a:count > 0
        let a:searchdirection = "/"
    else
        let a:searchdirection = "?"
    end
    if a:mode > 0
        " Matches ^MAJORHEADER:
        let a:modematch = "[[:upper:][:space:]]\\{1,}:*.*" . FoldMarkerOpen()
    else
        " Matches ^Minorheader:
        let a:modematch = "[[:upper:]]\\{1,}[^:]*:*"
    end
    set nohls
    exec a:searchdirection . "^" .  ExpandedCommentString() . a:modematch
    normal zz
    set hls
endfunction

" }}}
" }}}
" Cmdline Window: shortcuts " {{{
nnoremap :: q:
nnoremap // q/
nnoremap ?? q?

" }}}
" Cmdline Window: " {{{
augroup cmdline-window
    au! CmdwinEnter *
    " Execute the current line in cmndline-window and then reopen it.
    " n.b. Deliberately overloading <C-y> here.
    au CmdwinEnter * map <buffer> <C-y> <C-c><CR>q:
    au CmdwinEnter * inoremap <buffer> <C-y> <Esc><C-y>
    " Allow commands that echo to work.
    au CmdwinEnter * nnoremap <buffer> <CR> 0"ty$<C-c><C-c>:<C-r>t<CR>
    au CmdwinEnter * inoremap <buffer> <CR> <Esc>0"ty$<C-c><C-c>:<C-r>t<CR>
    " Quickly close cmdline-window
    au CmdwinEnter * map <buffer> ZZ <C-c><C-c>
    au CmdwinEnter * inoremap <buffer> ZZ <Esc>ZZ
augroup END

" }}}
" Learn: hjkl " {{{
" nmap <Left>   :echo "You should have typed h instead."<CR>
" nmap <Right>  :echo "You should have typed l instead."<CR>
" nmap <Up>     :echo "You should have typed k instead."<CR>
" nmap <Down>   :echo "You should have typed j instead."<CR>

" }}}
" Cmdline Convenience: " {{{
map <Left>     /<Up>
map <Right>    /<Down>
nmap <Up>      :<Up>
nmap <Down>    :<Down>

" }}}
" Accordion Mode: accordion style horizontal split navigation mode " {{{
" yes, kids, I know WTF I'm doing WRT <C-e>
 "nmap <silent> <C-e>j <C-w>j:call AccordionMode()<CR><C-l>
 "nmap <silent> <C-e>k <C-w>k:call AccordionMode()<CR><C-l>
 "nmap <silent> <C-e>h <C-w>h:call AccordionMode()<CR><C-l>
 "nmap <silent> <C-e>l <C-w>l:call AccordionMode()<CR><C-l>
 "nmap <silent> <C-e>- :call AccordionMode()<CR><C-l>
 "noremap <silent> <C-e><C-e> <C-e>
 "function! AccordionMode()
     "set winminheight=0 winheight=9999
     "set winheight=10 winminheight=10
 "endfunction

" }}}
" Timestamps: " {{{
let g:timestamp_default_annotation = ""
let g:timestamp_matchstring = '[0-9]\{4}-[0-9]\{2}-[0-9]\{2} [0-9:]\{8} [A-Z]\{3}'
let g:timestamp_annotated_matchstring = escape(g:timestamp_matchstring . '\s*\({\(\w\+\s*\)*}\)*', '\')
" Note: setting g:auto_timestamp_bypass will deactivate autotimestamp in contexts they would normally be active
" yes, kids, I know WTF I'm doing WRT <C-y>
nmap <silent> <C-y><C-u> :call timestamp#autoUpdateToggle()<CR>
nmap <silent> <C-y>Y :call timestamp#addOrUpdate("", "force")<CR>
nmap <silent> <C-y><C-y> :call timestamp#addOrUpdate("")<CR>
nmap <silent> <C-y><C-t> :call timestamp#addOrUpdateSolicitingAnnotation()<CR>
nmap <silent> <C-y><C-x> :call timestamp#remove()<CR>
nmap <silent> <Leader>sd :call timestamp#insert("date")<CR>
nmap <silent> <Leader>sl :call timestamp#insert("long")<CR>
nmap <silent> <Leader>fw :call FoldWrap()<CR>
nmap <silent> <Leader>fi :call FoldInsert()<CR>
nmap <silent> <Leader>ts :call InsertAnnotation("Started typing", "0")<CR>
nmap <silent> <Leader>tf :call InsertAnnotation("Finished typing", "$")<CR>
nmap <silent> <Leader>ll o<Esc>:call timestamp#insert("short") \| call FoldWrap()<CR>
" }}}
" Tabs: switching " {{{
" set Cmd-# on Mac and Alt-# elsewhere to switch tabs
for n in range(10)
     let k = n == "0" ? "10" : n
     for m in ["D", "A"]
         exec printf("imap <silent> <%s-%s> <Esc>%s", m, n, k)
         exec printf("map <silent> <%s-%s> %sgt", m, n, k)
     endfor
endfor

" }}}
" Windows: switching " {{{
" Set <C-w># to switch between windows (use [count]<C-w> instead of
" <C-w>[count] for other wincmds).
for n in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let k = n == "0" ? "10" : n
    for m in ["<C-w>"]
        exec printf("nmap <silent> %s%s :%swincmd w<CR>", m, n, k)
    endfor
endfor

" }}}

"}}}
" FUNCTIONS: " {{{

" Navigation:
function! EscapeShiftUp(incoming) " {{{
    return substitute(a:incoming, "\\", "\\\\\\\\", "g")
endfunction

" }}}
function! HeaderLocationIndex() "{{{
    let l:incoming = input("Go To Header: ")
    lgetexpr "" " Clear the location list
    exe "set errorformat=%l:%f:%m"
    let l:rawcommentstring = escape((text#strip_front(CommentStringOpen() . CommentStringClose())), "\"")
    exe "let l:commentstring = " .  EscapeShiftUp("l:rawcommentstring")
    let l:rawexpression = '\\(.*' . l:incoming . '\\c.*\\) ' . FoldMarkerOpen()
    " let l:rawexpression = '\\([ [:upper:]]*\\) ' . FoldMarkerOpen() " MAJOR header
    " let l:rawexpression = '\\([ [:alpha:]]*\\) ' . FoldMarkerOpen() " Minor header
    let l:expression = l:commentstring . l:rawexpression
    let l:searchexpression = substitute(l:expression, "\\\\\\{1,}", "\\", "g")
    let l:matchstring = "substitute(getline(\".\")" . ", \"" . l:expression . "\", \"\\\\1\"" . ", \"\")"
    let l:line = "line(\".\")"
    let l:filename = "expand(\"%:f\")"
    let l:commandword = "laddexpr"
    " let l:commandword = "echo"
    let l:gmatch = "g/^" . l:searchexpression . "/" . l:commandword . " " . l:line . " . \":\" . " .  l:filename . " . \":\" ." . l:matchstring
    " echo "Match string: " . l:gmatch
    exec l:gmatch
    nohls
    let l:locresults = getloclist("0")
    if len(l:locresults) > 1
        vert lop | wincmd =
    end
endfunction

"}}}
function! CompletionFunctionList(A,L,P) " {{{
    return "foo\nbar\nbaz"
endfunction
" }}}
function! FunctionLocationIndex() "{{{
    let l:incoming = input("Go to function: ", "", "custom,CompletionFunctionList")
    lgetexpr "" " Clear the location list
    exec "silent! lvimgrep /^\\s*function.*" . l:incoming . "\\c.*/ %"
    let l:locresults = getloclist("0")
    if len(l:locresults) > 1
        vert lop | wincmd =
    end
    if len(l:locresults) < 1
        echo "No match for: " . l:incoming
    end
endfunction
"}}}
command! UnlinewiseMovement :call UnlinewiseMovement()
function! UnlinewiseMovement() " {{{
    if maparg("j") == "gj"
        unmap <buffer> j
        unmap <buffer> k
    else
        nnoremap <buffer> j gj
        nnoremap <buffer> k gk
    end
endfunction

" }}}


" Folds: manipulation
function! FindNode(label) "{{{
    let l:location = NodeLocation(a:label)
    if l:location > 0
        call setpos(".", [0, l:location, 0, 0])
    end
    return line(".")
endfunction

" }}}
function! NodeLocation(label,...) "{{{
    if a:label == ""
        return 0
    end
    if len(a:000) > 0
        let l:options = 'n'
    else
        let l:options = 'cwn'
    end
    let l:openmarker = CommentedFoldMarkerOpen()
    let l:expression = a:label . "\\s*" . l:openmarker
    let l:matchline = search(l:expression, l:options)
    " echo printf("line: %2s had expression: %s", l:matchline, l:expression)
    return l:matchline
endfunction

" }}}
function! OpenNode(label) "{{{
    let l:nodefound = FindNode(a:label)
    if l:nodefound
        normal zv
        return 1
    endif
    return 0
endfunction

"}}}
function! CloseNode(label) "{{{
    let l:nodefound = FindNode(a:label)
    if l:nodefound
        normal zc
        return 1
    endif
    return 0
endfunction

"}}}
function! InsertNode(label) "{{{
    let l:origview = winsaveview()
    call append(line(".") - 1, [""])
    normal k
    call AppendText(a:label)
    call FoldWrap()
    call OpenNode(a:label)
    call winrestview(l:origview)
endfunction

"}}}
function! FoldWrap() "{{{
    " appending closemarker first to prevent ruining current folds
    call append(line("."), CommentedFoldMarkerClose())
    call append(line("."), [CommentedFoldMarkerOpen(), ""])
    " BUG: J on a line above an open comment line destroys subsequent fold states in the document unless there is a closed fold immediately above.
    " normal Jj
    normal 0"td$"_dd0"tPj
endfunction

"}}}
function! FoldMarkerOpen() "{{{
    return substitute(&foldmarker, ",.*", "", "")
endfunction

"}}}
function! FoldMarkerClose() "{{{
    return substitute(&foldmarker, ".*,", "", "")
endfunction

"}}}
function! FoldInsert() "{{{
    normal O
    call FoldWrap()
endfunction

"}}}
function! FoldUnfolded() " {{{
        silent! normal zc
endfunction

" }}}
function! FoldDefaultNodes() "{{{
    " Save position
    let l:origview = winsaveview()
    " Do work
    normal gg
    normal zR
    let l:hasnext = 1
    while (l:hasnext)
        let l:currentline = line(".")
        call FoldNodeIfDefault()
        silent! normal zj
        let l:hasnext = l:currentline != line(".")
    endwhile
    " Restore position
    call winrestview(l:origview)
endfunction

"}}}
function! FoldNodeIfDefault() "{{{
    let l:isdone = match(getline("."), '^done.* {{') > -1
    let l:hasat = match(getline("."), '^@.* {{') > -1
    let l:allcaps = match(getline("."), '^[A-Z]* {{') > -1
    let l:isrecurring = match(getline("."), '^(.).* {{') > -1
    " echo printf("isdone: %s, hasat: %s, allcap: %s", l:isdone, l:hasat, l:allcaps)
    if (l:hasat)
        return
    endif
    if (l:isrecurring)
        return
    endif
    if (l:allcaps)
        return
    endif
    if (l:isdone)
    endif
    normal zc
endfunction

"}}}
function! CommentedFoldMarkerOpen() "{{{
    let fcms = CommentStringFull()
    return substitute(fcms, '%s', FoldMarkerOpen(), 'g')
endfunction

"}}}
function! CommentedFoldMarkerClose() "{{{
    let fcms = CommentStringFull()
    let rawclosemarker = substitute(fcms, '%s', FoldMarkerClose(), 'g')
    return text#strip_front(rawclosemarker)
endfunction

"}}}

" Commentmarkers:
function! CommentStringOpen() "{{{
    return substitute(CommentStringFull(), "%s.*", "", "")
endfunction

"}}}
function! CommentStringClose() "{{{
    return substitute(CommentStringFull(), ".*%s", "", "")
endfunction

"}}}
function! ExpandedCommentString() "{{{
    return text#strip_front(substitute(CommentStringFull(), "%s", "", ""))
endfunction

"}}}
function! CommentStringFull() "{{{
    return len(&commentstring) > 0 ? &commentstring : " %s"
endfunction

"}}}

" Sessions:
function! FixSession() " {{{
  exe "vsplit " . v:this_session
  exe "%s/^edit /buffer /ge"
  write
  close
endfunction

" }}}
function! CommitSession() " {{{
    try
        silent write
        if exists('g:LAST_SESSION')
            silent SessionSave
            silent call FixSession()
            redraw
            echo "Saved repaired session: " . v:this_session
        else
            echo "No active session."
        end
    catch
        redraw
        echo "Error committing session: " . v:this_session
    endtry
endfunction

" }}}

" Specialized:
if !exists("g:reloadvim_function_loaded") " {{{
    " unlet g:reloadvim_function_loaded
    function! ReloadVimrc()
        silent update
        silent source ~/.vimrc
        silent edit
        redraw
        echo "Resourced .vimrc."
    endfunction
    let g:reloadvim_function_loaded = ""
end

" }}}
function! AutoTagComplete() " {{{
    normal aa
    normal! r>
    let l:save_position = getpos(".")
    exe "normal i\<C-g>u"
    let [l:ignore, l:close_tag_pos] = searchpos("</\\zs\\S\\+", "bnW", line("."))
    let [l:ignore, l:open_tag_pos] = searchpos("<[^/]\\zs[^[:space:]>]\\+", "bcW", line("."))
    if l:open_tag_pos == 0 || l:open_tag_pos < l:close_tag_pos
        call setpos('.', l:save_position)
    else
        normal yiw
        call setpos('.', l:save_position)
        normal a</
        normal p
        normal aa
        normal! r>
        call search("<", "bW", line("."))
    endif
    if l:save_position[2] == len(getline("."))
        startinsert!
    else
        startinsert
    endif
endfunction

" }}}
function! JournalEntry() " {{{
    let l:journaldir = $HOME . "/sandbox/personal/zaurus/zlog/"
    let l:currentdate = timestamp#text('date')
    let l:entry = l:journaldir . l:currentdate . ".txt"
    let l:entryexists = filereadable(l:entry)
    exec "edit " . l:entry
    exec "lcd " . l:journaldir
    if l:entryexists
        normal Go
        normal o
        exec "call setline(\".\", \"" . timestamp#text('time') . "\")"
    else
        exec "call setline(\".\", \"" . timestamp#text('journal') . "\")"
        exec "silent !svn add " . l:entry
    endif
    normal o
endfunction

" }}}
function! ScratchBuffer(title) " {{{
      exec "tabe " . a:title . " | setlocal buftype=nofile | setlocal bufhidden=hide | setlocal noswapfile"
endfunction

" }}}
function! Reset() " {{{
    silent pclose
    set completeopt-=menuone
    set nolist
    redraw
    echo "Reset [ Tip: " . RandomHint() . " ]"
endfunction

" }}}
function! RandomHint() " {{{
    let comment_character = "#"
    try
        if !exists("g:random_hint_list")
            if !exists("g:hint_filename")
                let g:hint_filename = $HOME . "/.vim/vimtips.txt"
            endif
            let g:random_hint_list = readfile(g:hint_filename, '')
            call filter(g:random_hint_list, 'strpart(v:val, 0, 1) != comment_character')
        endif
        let hint_count = len(g:random_hint_list)
        exec "ruby random_line = rand(" . hint_count . ")"
        ruby VIM::command("let hint = #{random_line}")
    catch
        return "Random hints not available."
    endtry
    return g:random_hint_list[hint]
endfunction

" }}}
function! HandleMantis() " {{{
  " Keep in sync with ~/.vim/after/syntax/txt.vim
  let l:expression = '\%(mt\|MT\|jr\|JR\|TS\|PF\|BUG\|FIXME\|STORY\)[:# ]\+[0-9]\+'
  let l:ticket = matchstr(getline("."), l:expression)
  let l:number = matchstr(l:ticket, '[0-9]\+')
  if l:ticket != "<Esc>:"
    let l:uri = 'https://mantis.janrain.com/view.php?id=' . l:number
    if has("win32")
      exec "silent !start rundll32.exe url.dll,FileProtocolHandler " . l:uri
    else
      exec "silent !open \"" . l:uri . "\""
    endif
    echo "Opened Ticket: " . l:number
  else
      echo "No ticket found in line."
  endif
endfunction

" }}}
function! HandleTS() " {{{
  let l:ticket = matchstr(getline("."), 'TS#[0-9]\+')
  let l:number = matchstr(l:ticket, '[0-9]\+')
  if l:ticket != "<Esc>:"
    let l:tsuri = 'http://trackstudio.nimblefish.com/task/' . l:number . '?thisframe=true'
    exec "silent !start rundll32.exe url.dll,FileProtocolHandler " . l:tsuri
    echo "Opened Ticket: " . l:number
  else
      echo "No TS ticket found in line."
  endif
endfunction

" }}}
function! HandleURI() " {{{
  let l:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;]*')
  if l:uri != ""
      if has("win32")
          exec "silent !start rundll32.exe url.dll,FileProtocolHandler " . l:uri
      else
          exec "silent !open \"" . l:uri . "\""
      endif
      echo "Opened URI: " . l:uri
  else
      echo "No URI found in line."
  endif
endfunction

" }}}
function! FormatSqlStatement() " {{{
  3match Todo /select .*/
  let l:uri = matchstr(getline("."), '\cselect .*')
  if l:uri != ""
      let @a = l:uri
      call ScratchBuffer("sql statement")
      setlocal bufhidden=delete
      normal "ap
      set ft=sql
      for keyword in ["select", "from", "and", "inner", "where", "left", "right", "union", "group by", "order by"]
          exec "silent! %s/" . keyword . "/\r&/gi"
      endfor
  else
      echo "No SQL statement found."
  endif
endfunction

" }}}

" Vimperator Y Pentadactyl:
function! FormFieldArchive() " {{{
    let l:contents = getbufline("%", 1, "$")
    let l:filepath = expand("%")
    let l:filename = expand("%:t:r")
    let l:formfielddir = $HOME . "/sandbox/personal/forms/"
    let l:currentdate = timestamp#text('date')
    let l:entry = l:formfielddir . l:currentdate . ".txt"
    let l:entryexists = filereadable(l:entry)
    exec "split " . l:entry
    if l:entryexists
        normal Go
        normal o
        exec "call setline(\".\", \"" . timestamp#text('time') . "\")"
    else
        exec "call setline(\".\", \"" . timestamp#text('journal') . "\")"
        exec "silent !svn add " . l:entry
    endif
    normal o
    exec "call setline(\".\", \"" . l:filename . "\")"
    normal o
    exec "call setline(\".\", " . string(l:contents) . ")"
    write
    bd
endfunction

" }}}

"}}}
" FILETYPES: " {{{

au BufNewFile,BufRead *.scala setf scala
au BufNewFile,BufRead *.zsh-theme setf zsh
au BufNewFile,BufRead *.applescript   setf applescript
au BufNewFile,BufRead *.json setf javascript
" au BufNewFile,BufRead *.tst.* set ft=_.txt.tst
au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/syntax/yaml.vim
au FileType ruby set fdm=syntax sts=2 sw=2 expandtab
au BufNewFile,BufRead *vimperatorrc*,*.vimp set filetype=vimperator
au BufNewFile,BufRead *pentadactylrc*,*.penta set filetype=pentadactyl
au BufNewFile,BufRead *.adium set filetype=adium
au BufNewFile,BufRead *.colloquy set filetype=colloquy

" Java: " {{{
augroup java
    au BufReadPre *.java setlocal foldmethod=syntax
    au BufReadPre *.java setlocal foldlevelstart=-1
augroup END

" }}}
" Extradite: " {{{
augroup Extradite
    au! FileType extradite set showbreak=⇒\ \ \ \ \  wrap cpo+=n
augroup END

" }}}

"}}}
" PLUGINS: " {{{

" Debug:  " {{{
if &verbose > 0
    echo "Using Debug Mode..."
    let augroups = [
                \ "vimwiki",
                \ "TaskStack",
                \]
    for each in augroups
        let symbol = "#" . each
        if exists(symbol)
            exec "au! " . each
        endif
    endfor
endif

" }}}
" TaskStack: " {{{
let g:aborted_prefix = "x"
let g:completed_prefix = "o"
augroup TaskStack | au!
    au BufRead *.tst* set filetype=tst syntax=txt
    au FileType *tst* set indentkeys-=o indentkeys-=0 showbreak=↳\ \ \ \ \   noai fdm=marker cms= sts=2 sw=2 isk+=# cpo+=n
    "au FileType *tst* nmap <buffer> XX :call TaskstackCompleteItem(g:aborted_prefix)<CR>
    "au FileType *tst* imap <buffer> XX <C-c>:call TaskstackCompleteItem(g:aborted_prefix)<CR>
    "au FileType *tst* nmap <buffer> QQ :call TaskstackCompleteItem(g:completed_prefix)<CR>
    "au FileType *tst* imap <buffer> QQ <C-c>:call TaskstackCompleteItem(g:completed_prefix)<CR>
    au FileType *tst* nmap <buffer> Nn :call TaskstackNewItemFromPaste()<CR>
    au FileType *tst* nmap <buffer> NN :call TaskstackNewItem()<CR>
    au FileType *tst* imap <buffer> NN <C-c>:call TaskstackNewItem()<CR>
    au FileType *tst* nmap <buffer> ZZ :call TaskstackHide()<CR>
    au FileType *tst* imap <buffer> ZZ <C-c>:call TaskstackHide()<CR>
    au FileType *tst* nmap <buffer> LL :call TaskstackScratch()<CR>
    au FileType *tst* nmap <buffer> <silent> $ :call TaskstackEOL()<CR>
    au FileType *tst* nmap <buffer> <silent> <C-j> :call TaskstackMoveItemDown()<CR>
    au FileType *tst* nmap <buffer> <silent> <C-k> :call TaskstackMoveItemUp()<CR>
    au FileType *tst* nmap <buffer> <silent> <C-p> ?^@.* {\{3\}<CR>:nohls<CR>
    au FileType *tst* nmap <buffer> <silent> <C-n> /^@.* {\{3\}<CR>:nohls<CR>
    au FileType *tst* nmap <buffer> <silent> <Tab> /^\([A-Z]\+ \)\{1,\}<CR>:nohls<CR>
    au FileType *tst* nmap <buffer> <silent> <S-Tab> ?^\([A-Z]\+ \)\{1,\}<CR>:nohls<CR>
    au FileType *tst* nmap <buffer> :w<CR> :call TaskstackSave()<CR>
    au FileType *tst* nmap <buffer> <silent> <C-x>x :call TaskstackGroups()<CR>
    au FileType *tst* nmap <buffer> K :echo TaskstackMoveToProjectPrompt()<CR>
    au FileType *tst* nmap <buffer> <C-y>k :echo TaskstackMoveToProjectAutoDetect()<CR>
    au FileType *tst* nmap <buffer> <Leader>k :call TaskstackMoveItemToProject("@categorize")<CR>
    au FileType *tst* nmap <buffer> <C-e>/ :call TaskstackNavigateToProjectPrompted()<CR>
    au FileType *tst* nmap <buffer> <silent> <Tab> :call TaskstackNextProject()<CR>
    au FileType *tst* nmap <buffer> <silent> <S-Tab> :call TaskstackNextProject('b')<CR>
    au FileType *tst* if mapcheck('<CR>', 'n') == "" | nmap <unique> <buffer> <silent> <CR> "tyiW/<C-r>t<CR>ztzv<C-l> | end
    " Use <C-c> to avoid adding or updating a timestamp after editing.
    au InsertLeave *.tst.* :call timestamp#addOrUpdate("") " FIXME: External Dependency
    au FocusLost *.tst.* nested write
augroup END

"}}}
" Scratch: " {{{
let g:volatile_scratch_columns = 100
let g:volatile_scratch_lines = 40

function! EmailAddressList(ArgLead, CmdLine, CursorPos)
        return system("~/bin/addresses")
endfunction

function! EmitEmailAddress(Header, First, Last, Address)
    let Result = "\"" . a:First . " " . a:Last . "\" " . a:Address
  call InsertLine(a:Header . l:Result)
endfunction

function! SmallWindow()
    setlocal guioptions+=c
    setlocal guioptions-=L
    setlocal guioptions-=r
    setlocal foldcolumn=0
    setlocal guifont=Inconsolata:h13
    setlocal transparency=15
    exec "set columns=" . g:volatile_scratch_columns . " lines=" . g:volatile_scratch_lines
    call SetColorColumnBorder()
    if exists('g:gundo_target_n')
        if exists("GundoClose") | exec "GundoClose" | endif
    endif
endfunction

function! SetColorColumnBorder()
    let l:admin_columns = &numberwidth + &foldcolumn
    exec "setlocal colorcolumn=" . (&columns - l:admin_columns)
endfunction

function! ScratchCopy()
    if &modified == 1
        silent write
    endif
    "exec ":0,$y"
endfunction

function! ScratchPaste()
    "normal ggVGo
    return
    if &modified == 1
        silent write
    endif
    normal ggVGpG$
endfunction

command! -nargs=* -complete=custom,EmailAddressList To call EmitEmailAddress("To: ", <f-args>)
command! -nargs=* -complete=custom,EmailAddressList Cc call EmitEmailAddress("Cc: ", <f-args>)
command! -nargs=* Sub call InsertLine("Subject: " . <q-args>)

augroup VolatileScratch
    au! BufRead *.scratch call SmallWindow()
    au! BufRead *.scratch nmap <buffer> <silent> <C-m> :call SmallWindow()<CR>
    au BufRead *.scratch nmap <buffer> <silent> <C-y>g :exec "set lines=999 columns=" . (g:gundo_width + &columns) \| :GundoToggle<CR>
    au BufRead *.scratch nmap <buffer> <silent> ZZ :wa \| :call ScratchCopy()<CR> \| :macaction hide:<CR>
    au BufRead *.scratch nmap <buffer> <silent> ZZ :call ScratchCopy()<CR> \| :macaction hide:<CR>
    au BufRead *.scratch nmap <buffer> <silent> :w<CR> :write \| :silent call ScratchCopy()<CR>
    au BufRead *.scratch imap <buffer> <silent> ZZ <Esc>ZZ
    au BufRead *.scratch vmap <buffer> <silent> ZZ <Esc>ZZ
    au! FocusLost *.scratch call ScratchCopy()
    au! FocusGained *.scratch call ScratchPaste()
    au! VimResized *.scratch call SetColorColumnBorder() | :normal zz
augroup END

"}}}
" Fuf: " {{{
augroup FuzzyFinder | au!
    au FileType fuf imap <buffer> <silent> <Tab> <Down>
    au FileType fuf imap <buffer> <silent> <S-Tab> <Up>
augroup END

" }}}
" Fuf: " {{{
augroup FuzzyFinder
    au! FileType tLibInputList set nolist nornu nonu
augroup END

" }}}
" Twitvim: " {{{
augroup Twitvim
    au! FileType twitvim set nonu | :wincmd L | set rnu
augroup END

" }}}
" Quickfix: " {{{
augroup Quickfix
    au! FileType qf set nu | :wincmd L
    au! FileType qf :wincmd L
augroup END

" }}}
" Vimscript: " {{{
augroup Vimscript
    au! FileType vim nmap <buffer> <silent> <C-y>t :echo "Generating vimscript tags..." \| exe ":silent !ctags -f ~/.vim/tags -R --languages=vim ~/.vim/autoload/*.vim ~/.vim/.vimrc ~/.vim/.gvimrc ~/.vim/bundle/*.vim" \| :echo "Generated vimscript tags."<CR>
augroup END

" }}}
" VCS Commit: " {{{
augroup VCSCommit
    au! BufRead hg-editor-* nmap <buffer> <silent> <C-e>d :set filetype=diff \| :r !hg diff<CR>gg
augroup END

" }}}
" Vimperator Y Pentadactyl: " {{{
augroup VimperatorYPentadactyl | au!
    au BufRead vimperator-*,pentadactyl-* set ft=form
    au BufRead vimperator-*,pentadactyl-* nmap <buffer> <silent> ZZ :call FormFieldArchive() \| :silent write \| :bd \| :macaction hide:<CR>
    au BufRead vimperator-*,pentadactyl-* imap <buffer> <silent> ZZ <Esc>ZZ
    au BufRead vimperator-*,pentadactyl-* :macaction unhide:
augroup END

" }}}
" Gundo: " {{{
let g:gundo_width = 55
let g:gundo_preview_height = 25
let g:gundo_help = 0

" }}}
" Crontab: " {{{
augroup crontab
    au! BufRead crontab.* set nowritebackup
    au BufRead crontab.* set filetype=crontab
augroup END

" }}}
" Cocoa: " {{{
augroup Cocoa
    au BufRead *.[mh] nmap <buffer> <d-1> :ListMethods<CR>
augroup END

" }}}
" CSApprox: " {{{
if &t_Co < 88
    let g:CSApprox_loaded = 1
endif

" }}}
" Tlib: " {{{
augroup Tlib | au!
    au FileType tlibInputList map <buffer> <Tab> <Down>
    au FileType tlibInputList map <buffer> <S-Tab> <Up>
    au FileType tlibInputList set ft=vim
augroup END

" }}}
" Html: autocomplete tags " {{{
au! FileType xhtml inoremap <buffer> > <Esc>:call AutoTagComplete()<CR>

" }}}
" Help Files: " {{{
augroup helpfiles
    au! FileType help nnoremap <buffer> <silent> <C-p> ?^[=-]\{1,}$<CR>zt:nohlsearch<CR>
    au FileType help nnoremap <buffer> <silent> <C-n> /^[=-]\{1,}$<CR>zt:nohlsearch<CR>
    au FileType help nnoremap <buffer> <silent> <S-Tab> ?\|[^\[:space:]]*\|<CR>zz:nohlsearch<CR>
    au FileType help nnoremap <buffer> <silent> <Tab> /\|[^\[:space:]]*\|<CR>zz:nohlsearch<CR>
    au FileType help nnoremap <buffer> <silent> <CR> <C-]>
    au FileType help nnoremap <buffer> <silent> <BS> <C-o>
    au FileType help wincmd L
augroup END

" }}}
" Gundo: " {{{
nnoremap <C-y>g :GundoToggle<CR>

" }}}
" Git Commit: " {{{
augroup Git | au!
    au BufNewFile,BufRead *.gitcommit setf gitcommit
    au FileType gitcommit nnoremap <buffer> <silent> <C-n> :DiffGitCached<CR>
    au FileType gitcommit\|gitconfig set nolist ts=4 sts=4 sw=4 | wincmd L
    au FileType gitconfig set noet | wincmd L
    au FileType gitrebase iab <buffer> na exec git commit --amend --author "Seth Milliken <seth@araxia.net>"<Left><Left><C-r>=getchar(0)?'':''<CR>
augroup END

" }}}
" Shell Scripts: " {{{
augroup Shell | au!
    au BufNewFile,BufRead *.functions setf zsh
    au FileType zsh nnoremap <buffer> <silent> <C-n> :DiffGitCached<CR>
augroup END

" }}}
" Python Syntax: " {{{
let python_highlight_all = 1

" }}}
" PickAColor: " {{{
let g:pickacolor_use_web_colors = 1
" }}}
" HTML: " {{{dd
let g:no_html_tab_mapping=1
let g:no_html_toolbar=1
"let g:html_map_leader=':'

" }}}
" Minbufexplorer: " {{{
let g:miniBufExplVSplit=30
let g:miniBufExplMaxSize = 50
let g:miniBufExplMapCTabSwitchBufs = 1

" }}}
" Sessionman: " {{{
let g:sessionman_save_on_exit = 0

" }}}
" BufExplorer: " {{{
map <silent> <C-Tab> :BufExplorer<CR>j
map <silent> <C-S-Tab> :BufExplorer<CR>k
" Unmap default bindings.
if maparg("<Leader>be") =~ 'BufExplorer' | exe "nunmap <Leader>be" | endif
if maparg("<Leader>bs") =~ 'BufExplorerHorizontalSplit' | exe "nunmap <Leader>bs" | endif
if maparg("<Leader>bv") =~ 'BufExplorerVerticalSplit' | exe "nunmap <Leader>bv" | endif
augroup BufExplorerAdd | au!
    if !exists("g:BufExploreAdd")
        let g:BufExploreAdd = 1
        au BufWinEnter \[BufExplorer\] map <buffer> <Tab> <CR>
        " Navigate to the file under the cursor when you let go of Tab
        " au BufWinEnter \[BufExplorer\] set updatetime=600
        " o is the BufExplorer command to select a file
        "au CursorHold \[BufExplorer\] call feedkeys("o", "m")
    endif
augroup END

" }}}
" Pydiction: " {{{
let g:pydiction_location = '~/.vim/complete-dict'

" }}}
" Paster: " {{{
let g:PASTER_BROWSER_COMMAND = 'open'

" }}}
" Rope: " {{{
"" let $PYTHONPATH .= ":/Library/Python/2.5/site-packages/ropemode:/Library/Python/2.5/site-packages:/Users/seth/sandbox/code/python/"
"" source ~/sandbox/code/python/ropevim/ropevim.vim
let $PATH .= ';C:\Python24\'
let $PYTHONPATH = 'C:\Python24\'

" }}}
" SnipMate: " {{{
let g:snips_author = 'Seth Milliken'
command! SnipUp call UpdateSnippetsForBuffer()
function! UpdateSnippetsForBuffer()
    call ResetAllSnippets()
    call GetSnippets(g:snippets_dir, "_")
    call GetSnippets(g:snippets_dir, &ft)
    echo "Snippets for format \"" . &ft . "\" updated."
endfunction

" }}}
" AbbUp: " {{{
command! -nargs=0 AbbUp call AbbUp()
function! AbbUp()
    so ~/.vim/plugin/iabbs.vim
    echo "Abbreviations updated."
endfunction

" }}}
" Todo Lists: " {{{
augroup todolist | au!
    au BufReadPost,FileReadPost *todo*,*list* doau FileType tst
    au BufReadPost,FileReadPost *todo*,*list* set syntax+=.txt
    au BufReadPost,FileReadPost *todo*,*list* map <buffer> <silent> <C-p> ?=\{1,} \(.*\) =\{1,}<CR>zt:nohlsearch<CR>
    au BufReadPost,FileReadPost *todo*,*list* map <buffer> <silent> <C-n> /=\{1,} \(.*\) =\{1,}<CR>zt:nohlsearch<CR>
augroup END

" }}}
" Vimwiki: " {{{
" Vimwiki Autocmds: " {{{
augroup Vimwiki | au!
    au BufReadPost,BufNewFile *.wiki doau FileType txt
    au BufReadPost,BufNewFile *.wiki doau FileType tst
    au FileType vimwiki set foldlevel=99
    au FileType vimwiki set syntax=txt.vimwiki
    au FileType vimwiki map <buffer> <silent> <C-p> ?=\{1,} \(.*\) =\{1,}<CR>zt:nohlsearch<CR>
    au FileType vimwiki map <buffer> <silent> <C-n> /=\{1,} \(.*\) =\{1,}<CR>zt:nohlsearch<CR>
    au FileType *vimwiki* nmap <buffer> <silent> <CR> :call VimwikiFollowLinkMod()<CR>
    au FileType vimwiki nested map <buffer> <silent> <Leader>w2 <Esc>:w<CR>:VimwikiAll2HTML<CR><Esc>:echo "Saved wiki to HTML."<CR>
augroup END

" }}}
" Vimwiki Configuration: " {{{
"" let wiki.nested_syntaxes = {'python': 'python'}
let g:vimwiki_hl_headers = 1                " hilight header colors
let g:vimwiki_hl_cb_checked = 1             " hilight todo item colors
let g:vimwiki_list_ignore_newline = 0       " convert newlines to <br /> in list
let g:vimwiki_folding = 1                   " outline folding
let g:vimwiki_table_auto_fmt = 0            " don't use and conflicts with snipMate
let g:vimwiki_fold_lists = 1                " folding of list subitems
let g:vimwiki_file_exts = 'pdf,txt,doc,rtf,xls,php,zip,rar,7z,html,gz,vim,screen,tst'
let g:vimwiki_valid_html_tags='b,i,s,u,sub,sup,kbd,br,hr,font,a,div,span'
let g:vimwiki_list = [
             \{'path': '~/sandbox/personal/vimwiki/',
                \'index': 'PersonalWiki',
                \'html_header': '~/sandbox/personal/vimwiki/header.tpl',
                \'html_footer': '~/sandbox/personal/vimwiki/footer.tpl',
                \},
            \{'path': '~/sandbox/public/wiki/',
                \'index': 'SethMilliken',
                \'auto_export': 1,
                \},
            \{'path': '~/sandbox/work/wiki/',
                \'index': 'SethMilliken',
                \'html_header': '~/sandbox/work/wiki/header.tpl',
                \'html_footer': '~/sandbox/personal/vimwiki/footer.tpl',
                \'maxhi': 0,
                \'auto_export': 1,
                \},
            \{'path': '~/sandbox/vimscriptdev.info/admin/',
                \'path_html': '~/sandbox/vimscriptdev.info/html/',
                \'index': 'index',
                \'html_header': '~/sandbox/vimscriptdev.info/admin/header.tpl',
                \'html_footer': '~/sandbox/vimscriptdev.info/admin/footer.tpl',
                \'maxhi': 0,
                \'auto_export': 1,
                \},
                \]
" }}}
function! VimwikiExpandedPageName() " {{{
    return substitute(substitute(expand('%:t'), "\\C\\([A-Z]\\)", " \\1", "g"), "\\..*", "", "")
endfunction

" }}}
function! VimwikiFollowLinkMod() " {{{
    if GetLetterAtCurrentPosition() == " "
        normal B
    end
    normal "tyiW
    if GetLetterAtCurrentPosition() == "@"
        exe "normal /\<C-r>\t\<CR>"
    else
        exe ":VimwikiFollowLink"
    endif
endfunction

" }}}
function! GetLetterAtCurrentPosition() " {{{
    let l:position = getpos(".")
    let l:column = get(l:position, 2)
    let l:letter = strpart(getline("."), l:column - 1, 1)
    return l:letter
endfunction

" }}}

" }}}
" Xptemplate: " {{{
let g:xptemplate_brace_complete = 0
let g:xptemplate_vars="$author=Seth Milliken"
let g:xptemplate_vars="$email=Seth Milliken <seth_vim@araxia.net>"
"command! Xup call g:XPTaddBundle('vimwiki', 'snippets')
" Set personal snippet folder location:
let g:xptemplate_snippet_folders=['/Users/seth/.vim/xptemplates/']

" Turn off automatic closing of quotes and braces:
let g:xptemplate_brace_complete = 0

" Snippet triggering key:
"let g:xptemplate_key = '<F1>'

" Open the pop-up menu:
let g:xptemplate_key_pum_only = '<Leader><Tab>'

" Clear current placeholder and jump to the next:
" imap <C-d> <Tab>
let g:xptemplate_nav_cancel = '<C-d>'

" Move to the next placeholder in a snippet:
let g:xptemplate_nav_next = '<Tab>'

" Go to the end of the current placeholder and in to insert mode:
let g:xptemplate_to_right = '<C-/>'
"
" Move cursor back to last placeholder:
let g:xptemplate_goback = '<S-Tab>'
"
" Use TAB/S-TAB to navigate through the pop-up menu:
let g:xptemplate_pum_tab_nav = 1
"
" Reload xptemplate snippets without quitting vim.
nmap <Leader>x :XPTreload<CR>

" }}}
" VimSheet: " {{{
augroup VimSheet
    au! BufRead /tmp/*.vim nmap <buffer> <CR> yyq:p<CR>
augroup END

" }}}
" Refresh Bundles: " {{{
augroup RefreshBundles
    au! BufRead *refresh_bundles.sh vmap <buffer> <Leader><CR> :sort \| echo "Sorted selection."<CR>
    au BufRead *refresh_bundles.sh map <buffer> K :call AddNewRefreshBundleEntry()<CR>
augroup END

function! AddNewRefreshBundleEntry() " {{{
    let repo = text#strip(@*)
    if match(repo, ".git$") == -1
        echo "Is there a git repo URL on the pasteboard?"
        return 0
    end
    let parsed_name = substitute(split(repo, '/')[-1], '\.vim\|\.git', '', 'g')
    let new_entry = printf("%-10s %-20s %s", "refresh", parsed_name, repo)
    let exists = search(repo, 'nw') ? "possible duplicate" : "new"
    call setline(line("$"), [getline("$"), new_entry])
    normal Gzb
    redraw
    echo printf("Added %s entry for '%s'", exists, parsed_name)
endfunction

" }}}
" }}}
" TOhtml: " {{{
let html_dynamic_folds = 1
let html_use_css = 1
let html_number_lines = 1
let use_xhtml = 1
"" unlet html_no_foldcolumn
"" unlet html_hover_unfold
let html_no_pre = 1

" }}}
" CommandT: " {{{
" See .gvimrc for map
let g:CommandTMatchWindowAtTop=1
" let g:CommandTSelectNextMap = ['<C-n>', '<C-j>', 'j']

" }}}
" Maintenance: " {{{
" Put any calls to occasional housekeeping scripts in here.
command! DoMaintenance call DoMaintenance()
function! DoMaintenance()
    " ~/.vim/bundle/refresh_bundles.sh
    call pathogen#helptags()
    silent! FufRenewCache
    silent! CommandTFlush
    " save all sessions
    " hg addremove and ci ~/.vim/sessions/*
endfunction

" }}}
" Janrain:  " {{{

let g:engage_dir = "~/sandbox/work/vm/rpx/ruby/rails/"
map <D-j>w <Esc>:exe 'cd' g:engage_dir \| pwd<CR>
map <D-j>p <Esc>:cd ~/sandbox/personal/<CR>
map <D-j>e <Esc>:GrepEngage<Space>
command! -nargs=1 GrepEngage call GrepEngage(<f-args>)
function! GrepEngage(string)
    echo "Searching Engage codebase for \"" . a:string . "\"...."
    let l:engage_path = "~/sandbox/work/vm/rpx/ruby/rails/**/*.rb"
    exec ":Ack \"" . a:string . "\" " . l:engage_path
    copen
endfunction
command! JanrainAbbreviations call JanrainAbbreviations()
function! JanrainAbbreviations() " {{{
    iabb pr provider
    iabb sp social publishing
    iabb apis APIs
    iabb im implementation
endfunction

" }}}

" }}}
" Folding: " {{{
function! CleanFoldText() "{{{
    let indentation = winwidth(0) - (winwidth(0) / 4)
    let fullline = getline(v:foldstart)
    let commentmatch = "\\s*" . substitute(CommentStringOpen(), "\\s\\+", "\\\\s*", "g")
    let g:replacestring = commentmatch . FoldMarkerOpen() . '.*'
    let line = substitute(fullline, g:replacestring, '', 'g')
    let linecount = v:foldend - v:foldstart - 2
    let linewidth = indentation - v:foldlevel - strlen(line)
    let decoratedline = printf("%s %*s <%s>", line, linewidth, linecount.' lines', v:foldlevel)
    let decoratedline = substitute(decoratedline, '^+\(.*\)done', 'o\1DONE', 'g')
    return decoratedline
endfunction "}}}
set foldtext=CleanFoldText()
" }}}
" FuzzyFinder: " {{{
" To transform wildignore into fuf_exclude...
" s/\*\./\\\./g | s/,/|/g
let g:fuf_file_exclude='\v\~$|\.(o|exe|dll|bak|orig|swp)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|.gitignore|.DS_Store|.htaccess'
let g:fuf_coveragefile_exclude = g:fuf_file_exclude
let g:fuf_dataDir = '~/.vim/swap/.vim-fuf-data'
let g:fuf_maxMenuWidth = 150
map <C-e>e  :FufBuffer<CR>
map <C-e><C-e>  :FufBuffer<CR>
map <C-e>f  :call RecursiveFileSearch(":FufCoverageFile")<CR>
map <C-e>t  :FufTag<CR>
map <C-e>v  :VimFiles<CR>
map <C-e>s  :Scriptnames<CR>
map <C-e>w  :WikiPages<CR>

function! RecursiveFileSearch(callback) " {{{
    let bad_paths = '^\(' . expand('~') . '\|' . expand('/') .'\)$'
    if match(getcwd(), bad_paths) > -1
        echo printf("Are you kidding? You want to recursively search in '%s'?", getcwd())
    else
       exe a:callback
    end
endf

command! DotFiles call DotFiles()
command! VimFiles call VimFiles()
command! Scriptnames call Scriptnames()
command! WikiPages call WikiPages()

function! DotFiles() " {{{
    call fuf#givenfile#launch('', '0', 'DotFiles>', split(glob('~/.**/*'), "\n"))
endfunction

" }}}
function! VimFiles() " {{{
    call fuf#givenfile#launch('', '0', 'VimFiles>', split(glob('~/.vim/**/*.vim'), "\n"))
endfunction

" }}}
function! Scriptnames() " {{{
    let output = '' | redir => output | silent! scriptnames | redir END
    let output = substitute(output, '\s*[0-9]\+:\s\+', '', 'g')
    call fuf#givenfile#launch('', '0', 'Scriptnames>', split(output, "\n"))
endfunction

" }}}
function! WikiPages() " {{{
    call fuf#givenfile#launch('', '0', 'WikiPages>', split(glob('~/sandbox/personal/vimwiki/*'), "\n"))
endfunction

" }}}

" }}}
" }}}
" }}}
" EXPERIMENTAL: " {{{

function! SnippetFilesForCurrentBuffer(A,L,P) " {{{
   let snipfiles = []
   for current_dir in split(g:snippets_dir, ',')
       for current_ft in split(&ft . "._", '\.')
           call add(snipfiles, glob(current_dir . current_ft ."/*.snippet"))
           call add(snipfiles, glob(current_dir . current_ft . "*.snippets"))
       endfor
   endfor
   return join(snipfiles, "\n")
endfunction

" }}}
function! OpenRelatedSnippetFileInVsplit() " {{{
    let snippetfile = input("Edit which related snippet file? ", "", "custom,SnippetFilesForCurrentBuffer")
    if filereadable(snippetfile) == 1
        exe ":vsplit " . snippetfile
    endif
endfunction

" }}}

" Shift Completed Items:
function! SweepComplete() range " {{{
    let filterrange = range(a:lastline, a:firstline, -1)
    let movelines = []
    for line in filterrange
        if FilterCompletedItem(line) == 0
            call insert(movelines, line)
        end
    endfor
    let i = 0
    for line in movelines
        exec "silent " . (line - i) . "m" . a:lastline | let i += 1
    endfor
endfunction

" }}}
function! FilterCompletedItem(line) " {{{
    return match(getline(a:line), "^o \\|^x \\|.*\\[X] ")
endfunction

" }}}

" Vim-addon-manager: " {{{
command! -nargs=1 PluginInstall call PluginInstall(<q-args>)
function! PluginInstall(plugin)
    " TODO: check for vam
    exec printf("call vam#install#Install(['github:vim-scripts/%s'])", a:plugin)
endfunction

" }}}
" Hexhighlight: " {{{
nmap <Leader>ht <Plug>HexHighlightToggle
nmap <Leader>hr <Plug>HexHighlightRefresh
nmap <Leader>hc <Plug>RefreshColorScheme

" }}}
" Vimple: " {{{
let g:loaded_vimpreviewtag = 1

" }}}

" Execute current line as an ex command.
map <Leader><CR> 0"ty$:<C-r>t<CR>:echo "Executed: " . @t<CR>
"vmap <Leader><CR> "ty \| exec ":call feedkeys(q:" . getreg("t") . ")"<CR>
" Execute current line as an ex command (no status to allow echo).
map <Leader><S-CR> :call feedkeys("\"tyyq:\"tp\r", "n")<CR>

" Automatic Behavior Per MacVim Instance: " {{{
augroup Startup | au!
    au GuiEnter * au! SwapExists * exe startup#handler().swapchoice() | set shortmess+=A
    au GuiEnter * nested silent! call startup#handler().handle()
    "au VimEnter * augroup! Startup
augroup END
" }}}

function! EscapedLine()
    return escape(getline("."), '%"')
endfunction

" Vim Interface to Adium: " {{{
augroup Adium | au!
    au FileType adium noremap <silent> <buffer> <CR> :let adium_message = printf(":Adium \"%s\"", EscapedLine()) \| exe adium_message \| call feedkeys('o', 't')<CR>
    au FileType adium imap <buffer> <CR> <Esc><CR>
    au FileType adium winsize 60 8
    au FocusLost *.adium write
augroup END

nmap <Leader>a :call feedkeys(":Adium \"", 't')<CR>
command! -nargs=* Adium :call SendTextToFrontmostAdiumChat(<q-args>)
function! SendTextToFrontmostAdiumChat(text)
    let message = escape(shellescape(a:text), '`')
    silent! exe printf("!ssh samsara osascript ~/bin/%s_gateway.scpt %s", "adium", message)
endfunction

" }}}
" Vim Interface to Colloquy: " {{{
augroup Colloquy| au!
    au FileType colloquy noremap <silent> <buffer> <CR> :let colloquy_message = printf(":colloquy \"%s\"", EscapedLine()) \| exe colloquy_message \| call feedkeys('o', 't')<CR>
    au FileType colloquy imap <CR> <Esc><CR>
    au FileType colloquy winsize 120 4
    au FileType colloquy set spell
    au FocusLost *.colloquy write
augroup END

command! -nargs=* Colloquy :call SendTextToFrontmostColloquyChat(<q-args>)
function! SendTextToFrontmostColloquyChat(text)
    let message = escape(shellescape(a:text), '`')
    silent! exe printf("!ssh samsara osascript ~/bin/%s_gateway.scpt %s", "colloquy", message)
endfunction

" }}}

" Binding for entering key-notation " {{{
imap <C-e><C-k> <C-r>=KeyBindingElementSequencePrompted()<CR>
imap kj <Esc>:call keynotation#parse()<CR>a

function! KeyBindingElementSequencePrompted() " {{{
    call inputsave()
    let input = input("Key: ")
    call inputrestore()
    let result = KeyBindingElementSequence(input)
    return result
endfunction

" }}}
function! KeyBindingElementSequence(input) " {{{
    let elements = split(a:input, ",")
    let result = join(map(elements, 'KeyBindingElement(v:val)'), '')
    return result
endfunction

" }}}
function! KeyBindingElement(input) " {{{
    let elements = split(a:input, " ")
    let elements[0] = toupper(elements[0])
    if elements[0] == 'B'  | return "<Bar>"       | endif
    if elements[0] == 'E'  | return "<Esc>"       | endif
    if elements[0] == 'EN' | return "<End>"       | endif
    if elements[0] == 'H'  | return "<Left>"      | endif
    if elements[0] == 'HO' | return "<Home>"      | endif
    if elements[0] == 'J'  | return "<Right>"     | endif
    if elements[0] == 'K'  | return "<Up>"        | endif
    if elements[0] == 'L'  | return "<Down>"      | endif
    if elements[0] == 'LE' | return "<Leader>"    | endif
    if elements[0] == 'LT' | return "<lt>"        | endif
    if elements[0] == 'PD' | return "<PageUp>"    | endif
    if elements[0] == 'PU' | return "<PageDown>"  | endif
    if elements[0] == 'SP' | return "<Space>"     | endif
    if elements[0] == 'T'  | return "<Tab>"       | endif
    if len(elements) == 3
        let elements[1] = toupper(elements[1])
    endif
    if len(elements) > 0
        return "<" . join(elements, "-") . ">"
    else
        return ""
    endif
endfunction

" }}}

" }}}

" Toggle number column: " {{{
" <C-e>1 to toggle between nu and rnu
for mapmode in ["n", "x", "o"]
    exe mapmode . "noremap <expr> <C-e>1 ToggleNumberDisplay()"
endfor

function! ToggleNumberDisplay()
    if exists('+relativenumber')
        exe "setl" &l:nu ? "rnu" : &l:rnu ? "nornu" : "nu"
    else
        setl nu!
    endif
endfunction

" }}}
" Toggle List: " {{{
" <C-e>2 to toggle between list and nolist
for mapmode in ["n", "x", "o"]
    exe mapmode . "noremap <expr> <C-e>2 ToggleListDisplay()"
endfor

function! ToggleListDisplay()
    exe "setl" &l:list? "nolist" : "list"
endfunction

" }}}
" Diff of changes since opening file " {{{
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
endif

" }}}
" StatusLineHighlight: " {{{
augroup StatusLineHighlightExtra | au!
    au Syntax * call StatusHighlightColors()
augroup END

function! StatusHighlightColors() " {{{
  highlight def StatusLineModified       term=bold,reverse cterm=bold,reverse ctermfg=DarkRed   gui=bold,reverse guifg=DarkRed
  highlight def StatusLineModifiedNC     term=reverse      cterm=reverse      ctermfg=LightRed  gui=reverse      guifg=LightRed
  highlight CursorColumn term=reverse      cterm=reverse      ctermfg=LightRed  gui=reverse      guifg=LightRed
  highlight def StatusLinePreview        term=bold,reverse cterm=bold,reverse ctermfg=Blue      gui=bold,reverse guifg=Blue
  highlight def StatusLinePreviewNC      term=reverse      cterm=reverse      ctermfg=Blue      gui=reverse      guifg=Blue
  highlight def StatusLineReadonly       term=bold,reverse cterm=bold,reverse ctermfg=Grey      gui=bold,reverse guifg=DarkGrey
  highlight def StatusLineReadonlyNC     term=reverse      cterm=reverse      ctermfg=Grey      gui=reverse      guifg=DarkGrey
  highlight def StatusLineSpecial        term=bold,reverse cterm=bold,reverse ctermfg=DarkGreen gui=bold,reverse guifg=DarkGreen
  highlight def StatusLineSpecialNC      term=reverse      cterm=reverse      ctermfg=DarkGreen gui=reverse      guifg=DarkGreen
  highlight def StatusLineUnmodifiable   term=bold,reverse cterm=bold,reverse ctermfg=Grey      gui=bold,reverse guifg=Grey
  highlight def StatusLineUnmodifiableNC term=reverse      cterm=reverse      ctermfg=Grey      gui=reverse      guifg=Grey
endfunction

" }}}

augroup MantisEmail
    au FileType email map <silent> <buffer> <Leader>= :call MantisTicketFromEmail()<CR>
augroup END
function! MantisTicketFromEmail() " {{{
    set buftype=nofile
    silent! v/Issue [0-9]\+\|Summary:/d
    silent! %s/Issue \([0-9]\+\).*\nSummary:\s\+\(.*\)/mt#\1: \2/
    normal yy
    winsize 120 4
    echo printf("'%s' added to pasteboard.", text#strip(@*))
endfunction

" }}}
" }}}

" <M-S-t>
nmap ˇ :call SolicitTabName()<CR>

" Execute visual selection as function contents: {{{
function! ExecuteSelection() abort
    normal "ty
    split +enew
    let incoming = getreg("t")
    let contents = ["function! TransientFunction() abort"]
    let contents = extend(contents, split(incoming, '\n'))
    let contents = extend(contents, ["endfunction"])
    call append(0, contents)
    exec "silent w " . tempname() . ".vim"
    so %
    bd
    call TransientFunction()
    function TransientFunction
endfunction

vmap <buffer> K "ty:call ExecuteSelection()<CR>

function! MarkdownToHtml()
    %s/`\([^`]*\)`/<code>\1<\/code>/g
    " <p> in front of each paragraph. how to correctly detect?
endfunction
" }}}

command! Herenow :call Herenow()
function! Herenow() " {{{
    exec ":lcd " . expand("%:p:h")
    echo "cwd now: " . getcwd()
endfunction

" }}}
command! -nargs=* Checkin :call Checkin(<q-args>)
function! Checkin(...) " {{{
    let message =  a:000[0]
    let g:last_commit_message = message
    if CheckinCheckup()
        call Herenow()
        if len(message) > 0
            exe ":Gcommit % -m\'" . message . "\'"
        else
            exe ":Gcommit -v %" | wincmd T
        endif
    endif
endfunction

" }}}
function! CheckinCheckup(...) " {{{
    let show_prompt = len(a:000) > 0
    let currentfile = (len(expand("%:p")) > 0) ? expand("%") : "Unsaved buffer"
    if (currentfile != "Unsaved buffer")
        write
    end
    if exists(":Gcommit")
        if show_prompt
            call feedkeys(":Checkin ")
        else
            return 1
        endif
    else
        echo currentfile . " is not in a recognized vcs work tree."
        return 0
    endif
endfunction

" }}}

" }}}
  fun SBT_JAR()
    return "/usr/local/Cellar/sbt/0.11.2/libexec/sbt-launch.jar"
  endfun

" let g:session_autoload = 1
" let g:session_autosave = 1

" type number then : to get relative range prepopulated in cmdline
" idem to get relative range prepopulated in cmdline
" . as range, e.g. :.w >> foo
" can @ take a range?

" :help local-additions
" :help guioptions

" :options
" :runtime syntax/colortest.vim
" :file
" :diffpatch
" :set ff=unix
" :let string="!echo 'bar' | ls"
" :let mapleader=","
" :let mapleader=" "

" }}}
" vim: set ft=vim fdm=marker cms=\ \"\ %s  :
