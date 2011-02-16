" INFO: " {{{
let g:session_autoload = 1
let g:session_autosave = 1

" Maintainer:
"   Seth Milliken <seth_vim@araxia.net>
"   Araxia on #vim irc.freenode.net

" Version:
" 1.0 " 2010-12-21 17:24:29 PST

" Notes:
"   - I'm deliberately overloading <C-e> and <C-y> for more useful purposes.
"   - In this file (as in most of my editing), I try to group distinct features in such a way that I can easily use a simple text-object operation on them (vap, yap, etc.).
"   - Folds can be quickly selected simply by closing the fold (za) and yanking
"   the folded line (yy).
"   - /^""/ indicate intentionally disabled options

" Todo:
"   - clean up SETTINGS; provide better descriptions
"   - for clarity, replace abbreviated forms of options in all settings
"   - annotate all line noise, especially statusline
"   - make .vimrc re-source-able without sideeffects (guards around au, maps, etc.)
"   - create keybindings for new location list fold header navigation mechanism
"   - consider: is keeping example .vimrc useful
"   - consider: add tw setting to .vimrc modeline
"   - consider: move ft-specific settings to individual files
"   - consider: :: shortcut worth the : pause? (remember that the pause is essentially only percieved; immediately continuing to type the : command works fine)

"}}}
" Pathogen: " {{{
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
" }}}
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
set history=50      " keep 50 lines of command line history
set ruler           " show the cursor position all the time
set showcmd         " display incomplete commands
set incsearch       " do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

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
" au! VimEnter * source ~/.vim/after/plugin/foo.vim " Way to set the latest
" file that will always be sourced for any file opened.
set winfixheight
set shortmess+=I                    " don't show intro on start
set shortmess+=A                    " don't show message on existing swapfile
set nospell                         " spelling off by default
set spellcapcheck=off               " ignore case in spellcheck
set encoding=UTF-8                  " use UTF-8 encoding
set fileencoding=UTF-8              " use UTF-8 encoding as default
set nolist                          " don't show invisibles
set listchars=tab:>-,trail:-        " ...but make them look nice when they do show
set iskeyword+=-                    " usually want - to not divide words
set lbr                             " wrap lines at word breaks
set noautoindent                    " don't like autoindent
set number                          " always show line numbers
set autowrite                       " auto write changes when switching buffers
set tabstop=8                       " default tab stop width
set softtabstop=4                   " set a narrow tab width
set shiftwidth=4                    " and keep sw & sts in sync
set expandtab                       " expand tabs to spaces
set list                            " and consequently, reveal tabs by default now
set hlsearch                        " highlight searches
set nobackup                        " don't like ~ files littered about; don't need
set laststatus=2                    " always show the status line
set diffopt+=vertical               " use vertical splits for diff
set splitright                      " open vertical splits to the right
set splitbelow                      " open horizonal splits below
set winminheight=0                  " minimized horizontal splits show only statusline
set switchbuf=useopen               " when switching to a buffer, go to where it's already open
set history=10000                   " keep craploads of command history
set undolevels=500                  " keep lots of undo history
" set foldlevelstart=999              " don't use a default fold level; all folds open by default
set fdm=marker                      " make the default foldmethod markers
set display+=lastline               " always show as much of the last line as possible
set guioptions+=c                   " always use console dialogs (faster)
set noerrorbells                    " don't need to hear if i hit esc twice
set visualbell | set t_vb=          " nor see it
"set foldcolumn=4                    " trying out fold indicator column
"set display+=uhex                   " show unprintable hex characters as <xx>

"let mapleader=" "                  " experiment with using <Space> as <Leader>.
let mapleader="\\"                     " experiment with using <Space> as <Leader>. Nah. Stick with \

if version > 702 | set rnu | au BufReadPost * set rnu
end " use relative line numbers
if version > 702 | set clipboard=unnamed | end " use system clipboard; FIXME: what version is actually required?
set wildignore+=*.o,*.sw?,*.git,*.svn,*.hg,**/build,*.?ib,*.png,*.jpg,*.jpeg,*.mov,*.gif,*.bom,*.azw,*.lpr,*.mbp,*.mode1v3,*.gz,*.vmwarevm,*.rtf,*.pkg,*.developerprofile,*.xcodeproj,*.pdf,*.dmg,*.db,*.otf,*.bz2,*.tiff,*.iso,*.jar,*.dat,**/Cache,*.cache,*.sqlite*,*.collection,*.qsindex,*.qsplugin,*.growlTicket,*.part,*.ics,*.ico,**/iPhone\ Simulator,*.lock*,*.webbookmark

" Tags: universal location
set tags+=$HOME/sandbox/personal/tags

" Swap: centralized with unique names via //
set directory=$HOME/.vim/swap//,~/vimfiles/swap//

" Sessionopts: defaults are blank,buffers,curdir,folds,help,options,tabpages,winsize
set ssop=folds,help,options,tabpages,winsize
set ssop+=globals,sesdir,resize,winpos,unix

" Statusline: TODO: annotate this status line
set statusline=%<\(%n\)\ %m%y%r\ %f\ %=%-14.(%l,%c%V%)\ %P

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

" sane-itize Y
map Y y$

" Undoable deletes in insert
inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-w>

" lcd to file's container
nmap <C-e>c :exec ":lcd " . expand("%:p:h")<CR>

" tmux copy/paste issue in mac os x workaround
nmap <C-x>p :call system("ssh localhost pbcopy", getreg('"'))<CR>

" }}}
" Reset: restore some default settings and redraw " {{{
nnoremap <silent> <C-L> :call Reset() \| nohls<CR>
imap <silent> <C-L> <Esc>:call Reset() \| nohls<CR>a

" }}}
" Custom: <C-y> prefixed custom commands " {{{
" Reload .vimrc
imap <C-y>v <Esc> :call ReloadVimrc()<CR> \| :echo "Resourced .vimrc."<CR>
nmap <C-y>v :call ReloadVimrc()<CR> \| :echo "Resourced .vimrc."<CR>
" Reload snippets
nmap <C-y>s :SnipUp<CR>
" Execute current line as ex command
map <C-e>x :call feedkeys("yyq:p\r", "n")<CR>

" }}}
" Utility: word count of current file " {{{
nmap <silent> <Leader>w :!wc -w %<CR>

" }}}
" Clipboard: Copy buffer to clipboard " {{{
" trying 'set clipboard=unnamed' instead; see .gvimrc
"" map <something>  :%y*<CR>

" }}}
" Tail: reload buffer from disk and go to end " {{{
" - FIXME: find a non-conflicting binding
" - TODO: restrict to certain filetypes, e.g. only .log?
" nmap <silent> <S-k> :e<CR><Esc>:$<CR>

" }}}
" Save Session: " {{{
nmap <Leader>\ :call CommitSession()<CR>

" }}}
" Journal: " {{{
nmap \j :call JournalEntry()<CR>
command! Journal :call JournalEntry()

" }}}
" Misc: " {{{
nmap <silent> <Leader>] :NERDTreeToggle<CR>
" nmap <silent> <Leader>[ :TMiniBufExplorer<CR>

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
nmap <silent> <Leader>t :call HandleTS()<CR>
nmap <silent> <Leader>j :call HandleMantis()<CR>

" }}}
" SQL: grab and format sql statement from current line " {{{
nmap <silent> <Leader>q :call FormatSqlStatement()<CR>

" }}}
" Formatting: Wrap current or immediately preceding word in in <em> tag " {{{
nmap <Leader>_ Bi<em><Esc>ea</em>

" }}}
" Completion: show completion preview, without actually completing " {{{
inoremap <C-p> <Esc>:set completeopt+=menuone<CR>a<C-n><C-p>

" }}}
" Help: help help help " {{{
nmap <Leader>hw     :help<CR>:silent call AdjustFont(-4)<CR>:set columns=115 lines=999<CR>:winc _<CR>:winc \|<CR>:help<Space>
nmap <Leader>pp     :help<CR><Esc>:winc _<CR><Esc>:winc \|<CR><Esc>:help<Space>
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
    au CmdwinEnter * nnoremap <buffer> <CR> 0y$<C-c><C-c>:<C-r>"<CR>
    au CmdwinEnter * inoremap <buffer> <CR> <Esc>0y$<C-c><C-c>:<C-r>"<CR>
    " Quickly close cmdline-window
    au CmdwinEnter * map <buffer> ZZ <C-c><C-c>
    au CmdwinEnter * inoremap <buffer> ZZ <Esc>ZZ
augroup END

" }}}
" Learn: hjkl " {{{
" nmap <Left>   :echo "You should have typed h instead."<CR>
" nmap <Right>  :echo "You should have typed l instead."<CR>
" nmap <Up>         :echo "You should have typed k instead."<CR>
" nmap <Down>   :echo "You should have typed j instead."<CR>
nmap <Left>     :<Up>
nmap <Right>    :<Down>
nmap <Up>       :<Up>
nmap <Down>     :<Down>

" }}}
" Accordion Mode: accordion style horizontal split navigation mode " {{{
" yes, kids, I know WTF I'm doing WRT <C-e>
nmap <silent> <C-e>j <C-w>j:call AccordionMode()<CR><C-l>
nmap <silent> <C-e>k <C-w>k:call AccordionMode()<CR><C-l>
nmap <silent> <C-e>h <C-w>h:call AccordionMode()<CR><C-l>
nmap <silent> <C-e>l <C-w>l:call AccordionMode()<CR><C-l>
nmap <silent> <C-e>- :call AccordionMode()<CR><C-l>
nnoremap <silent> <C-e><C-e> <C-e>
function! AccordionMode()
    set winminheight=0 winheight=9999
    set winheight=10 winminheight=10
endfunction

" }}}
" Timestamps: " {{{
let g:timestamp_default_annotation = ""
let g:timestamp_matchstring = '[0-9]\{4}-[0-9]\{2}-[0-9]\{2} [0-9:]\{8} [A-Z]\{3}'
let g:timestamp_annotated_matchstring = escape(g:timestamp_matchstring . '\s*\({\(\w\+\s*\)*}\)*', '\')
" Note: setting g:auto_timestamp_bypass will deactivate autotimestamp in contexts they would normally be active
" yes, kids, I know WTF I'm doing WRT <C-y>
nmap <silent> <C-y><C-u> :call TimestampAutoUpdateToggle()<CR>
nmap <silent> <C-y>Y :call AddOrUpdateTimestamp("", "force")<CR>
nmap <silent> <C-y><C-y> :call AddOrUpdateTimestamp("")<CR>
nmap <silent> <C-y><C-t> :call AddOrUpdateTimestampSolicitingAnnotation()<CR>
nmap <silent> <C-y><C-x> :call RemoveTimestamp()<CR>
nmap <silent> <Leader>sd :call Timestamp("date")<CR>
nmap <silent> <Leader>sl :call Timestamp("long")<CR>
nmap <silent> <Leader>fw :call FoldWrap()<CR>
nmap <silent> <Leader>fi :call FoldInsert()<CR>
nmap <silent> <Leader>ll o<Esc>:call Timestamp("short") \| call FoldWrap()<CR>
" }}}
" Tabs: switching " {{{
" set Cmd-# and Alt-# to switch tabs
for n in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let k = n == "0" ? "10" : n
    for m in ["A", "D"]
        exec printf("imap <silent> <%s-%s> <Esc>:tabn %s<CR>", m, n, k)
        exec printf("nmap <silent> <%s-%s> %sgt<CR>", m, n, k)
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
    let l:rawcommentstring = escape((StripFront(CommentStringOpen() . CommentStringClose())), "\"")
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

" Text: tools
function! AppendText(text) "{{{
    let l:originalline = getline(".")
    if LineIsWhiteSpace(getline("."))
        call InsertLine(a:text)
    else
        call append(line("."),[a:text])
        normal J$
    endif
endfunction

"}}}
function! InsertLine(text) "{{{
    if LineIsWhiteSpace(getline("."))
        call setline(line("."),[a:text])
    else
        call append(line(".") - 1,[a:text])
    end
endfunction

"}}}
function! LineIsWhiteSpace(line) "{{{
    return a:line =~ '^\s*$'
endfunction

"}}}
function! Strip(string) "{{{
    return StripFront(StripEnd(a:string))
endfunction

"}}}
function! StripEnd(string) "{{{
    return substitute(a:string, "[[:space:]]*$", "", "")
endfunction

"}}}
function! StripFront(string) "{{{
    return substitute(a:string, "^[[:space:]]*", "", "")
endfunction

"}}}

" Folds: manipulation
function! FindNode(label) "{{{
        if a:label == ""
                return 0
        end
        let l:openmarker = CommentedFoldMarkerOpen()
        let l:expression = a:label . "\\s*" . l:openmarker
        let l:matchline = search(l:expression, 'csw')
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
    return StripFront(rawclosemarker)
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
    return StripFront(substitute(CommentStringFull(), "%s", "", ""))
endfunction

"}}}
function! CommentStringFull() "{{{
    return len(&commentstring) > 0 ? &commentstring : " %s"
endfunction

"}}}

" Timestamps:
function! Timestamp(style) "{{{
    call AppendText(TimestampText(a:style) . " ")
endfunction

" }}}
function! TimestampText(style) "{{{
    let l:iswindows = has("win16") || has("win32") || has("win64")
    if l:iswindows
        if a:style == "long"
            let l:dateformat = strftime("%#x %H:%M:%S ")
        elseif a:style == "short"
            let l:dateformat = strftime("%Y-%m-%d %H:%M:%S ") 
        endif
        let l:dateformat .= substitute(strftime("%#z"), '[a-z]\+\($\| \)', '', 'g')
    else
        if a:style == "long"
            let l:dateformat = strftime("%Y %b %d %a %X %Z")
        elseif a:style == "journal"
            let l:dateformat = strftime("%A, %B %d, %Y %H:%M:%S %Z")
        elseif a:style == "short"
            let l:dateformat = strftime("%Y-%m-%d %H:%M:%S %Z")
        elseif a:style == "time"
            let l:dateformat = strftime("%H:%M:%S %Z")
        endif
    endif
    if a:style == "date"
        let l:dateformat = strftime("%Y-%m-%d")
    endif
    return l:dateformat
endfunction

" }}}
function! TimestampAutoUpdateToggle() "{{{
    if !exists("g:auto_timestamp_bypass")
        call AutoTimestampBypass()
        echo "Timestamps: auto add/update DISABLED."
    else
        call AutoTimestampEnable()
        echo "Timestamps: auto add/update ENABLED."
    end
endfunction

"}}}
function! AddOrUpdateTimestampSolicitingAnnotation() "{{{
    if !exists("g:auto_timestamp_bypass")
        let l:default_prompt = g:timestamp_default_annotation
        let l:matchstring = g:timestamp_matchstring . '\zs\ze\s*\({\zs\(\w\+\s*\)*\ze}\)*$'
        let l:originalannotations = matchstr(getline("."), l:matchstring)
        if len(l:originalannotations) > 0
            let l:default_prompt = l:originalannotations
        end
        let l:annotation = input("Annotation: ", Strip(l:default_prompt))
        if len(l:annotation) > 0
            call AddOrUpdateTimestamp(Strip(l:annotation), "force")
        else
            if len(l:originalannotations) > 0
                silent! call RemoveTimestamp()
                silent! call AddOrUpdateTimestamp("", "force")
                echo "Annotations removed."
            else
                echo "Annotation aborted."
            end
        end
    end
endfunction

"}}}
function! AddOrUpdateTimestamp(annotation,...) "{{{
    if exists("a:1") && len(a:1) > 0
        let forceupdate = 1
    else
        let forceupdate = 0
    endif
    if forceupdate || !exists("g:auto_timestamp_bypass")
        if forceupdate || IsTimestampUpdateOkay(getline(".")) > 0
            let l:bufferdirty = &modified
            let l:origpos = getpos(".")
            let l:hasbasictimestamp = match(getline("."), TimestampPattern())
            let l:annotation = len(a:annotation) > 0 ? '{' . a:annotation . '}' : ""
            let l:newtimestamp = StripEnd(substitute(CommentStringFull(), "%s", TimestampText("short") . " " . l:annotation, ""))
            silent! undojoin
            if l:hasbasictimestamp > 0
                call setline(".", substitute(getline("."), TimestampAnnotatedPattern(), l:newtimestamp, ""))
            else
                call AppendText(l:newtimestamp)
            end
            call setpos('.', l:origpos)
            if !l:bufferdirty | write | end
        end
    end
endfunction

"}}}
function! IsTimestampUpdateOkay(line) "{{{
    let l:characters = 20
    if len(a:line) < l:characters
        echo "No autotimestamp: line shorter than ". l:characters . " characters."
        return 0
    elseif match(a:line, FoldMarkerOpen()) > 0
        echo "No autotimestamp: line already has open foldmarker."
        return 0
    elseif match(a:line, "^@") > -1
        echo "No autotimestamp: project fold"
        return 0
    elseif match(a:line, FoldMarkerClose()) > 0
        echo "No autotimestamp: line already has close foldmarker."
        return 0
    elseif match(a:line, "^x\\s\\|^o\\s\\|\\sx\\s\\|\\so\\s") > -1
        echo "No autotimestamp: line contains completed marker."
        return 
    elseif len(Strip(CommentStringOpen())) > 0 && match(a:line, "^" . CommentStringOpen()) > -1
        echo "No autotimestamp: commented line"
        return 0
    else
        return 1
    end
endfunction

"}}}
function! TimestampAnnotatedPattern() "{{{
    return substitute(CommentStringFull(), "%s", g:timestamp_annotated_matchstring, "") . '\s*$'
endfunction

"}}}
function! TimestampPattern() "{{{
    return substitute(CommentStringFull(), "%s", escape(g:timestamp_matchstring, '\'), "")
endfunction

"}}}
function! AutoTimestampBypass() " {{{
    let g:auto_timestamp_bypass = ""
endfunction

" }}}
function! AutoTimestampEnable() " {{{
    if exists("g:auto_timestamp_bypass")
        unlet g:auto_timestamp_bypass
    end
endfunction

" }}}
function! RemoveTimestamp() "{{{
    let l:bufferdirty = &modified
    call setline(".", substitute(getline("."), '\s*' . TimestampAnnotatedPattern(), "", ""))
    if !l:bufferdirty | write | end
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
    function! ReloadVimrc()
        write
        source ~/.vimrc
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
    let l:currentdate = TimestampText('date')
    let l:entry = l:journaldir . l:currentdate . ".txt"
    let l:entryexists = filereadable(l:entry)
    exec "edit " . l:entry
    exec "lcd " . l:journaldir
    if l:entryexists
        normal Go
        normal o
        exec "call setline(\".\", \"" . TimestampText('time') . "\")" 
    else
        exec "call setline(\".\", \"" . TimestampText('journal') . "\")" 
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
    echo "Reset"
endfunction

" }}}
function! HandleMantis() " {{{
  let l:ticket = matchstr(getline("."), 'JR#[0-9]\+')
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
    let l:currentdate = TimestampText('date')
    let l:entry = l:formfielddir . l:currentdate . ".txt"
    let l:entryexists = filereadable(l:entry)
    exec "split " . l:entry
    if l:entryexists
        normal Go
        normal o
        exec "call setline(\".\", \"" . TimestampText('time') . "\")" 
    else
        exec "call setline(\".\", \"" . TimestampText('journal') . "\")" 
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

au BufNewFile,BufRead *.applescript   setf applescript
au BufNewFile,BufRead *.tst.* set ft=_.txt.tst
au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/syntax/yaml.vim
au FileType ruby set fdm=syntax

" Java: " {{{
augroup java
    au BufReadPre *.java setlocal foldmethod=syntax
    au BufReadPre *.java setlocal foldlevelstart=-1
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
augroup TaskStack
    au! BufRead *.tst.* set filetype=tst syntax=txt
    au! FileType *tst* set indentkeys-=o indentkeys-=0 showbreak=\ \  noai fdm=marker cms= ts=2
    au FileType *tst* nmap <buffer> XX :call TaskstackCompleteItem(g:aborted_prefix)<CR>
    au FileType *tst* imap <buffer> XX <C-c>:call TaskstackCompleteItem(g:aborted_prefix)<CR>
    au FileType *tst* nmap <buffer> QQ :call TaskstackCompleteItem(g:completed_prefix)<CR>
    au FileType *tst* imap <buffer> QQ <C-c>:call TaskstackCompleteItem(g:completed_prefix)<CR>
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
    au FileType *tst* nmap <buffer> <C-e>/ :call TaskstackNavigateToProjectPrompted()<CR>
    au FileType *tst* nmap <buffer> <C-y>k :echo TaskstackMoveToProjectAutoDetect()<CR>
    au FileType *tst* nmap <buffer> <silent> <Tab> :call search("@.*\\\\|^[A-Z]\\+")<CR>
    au FileType *tst* nmap <buffer> <silent> <S-Tab> :call search("@.*\\\\|^[A-Z]\\+", 'b')<CR>
    au FileType *tst* if !mapcheck('<CR>', 'n') == "" | nmap <unique> <buffer> <silent> <CR> yiW/<C-r>"<CR>zzzv<C-l> | end
    " Use <C-c> to avoid adding or updating a timestamp after editing.
    au! InsertLeave *.tst.* :call AddOrUpdateTimestamp("") " FIXME: External Dependency
    au! FocusLost *.tst.* nested write
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
    setlocal guifont=Inconsolata:h11
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
    exec ":0,$y"
endfunction

function! ScratchPaste()
    if &modified == 1
        silent write
    endif
    normal ggVGpG$
endfunction

command! -nargs=* -complete=custom,EmailAddressList To call EmitEmailAddress("To: ", <f-args>)
command! -nargs=* -complete=custom,EmailAddressList Cc call EmitEmailAddress("Cc: ", <f-args>)
command! -nargs=* Sub call InsertLine("Subject: " . <q-args>)

augroup VolatileScratch
    " au! BufRead *.scratch call SmallWindow()
    au! BufRead *.scratch nmap <buffer> <silent> <C-m> :call SmallWindow()<CR>ZZ
    au BufRead *.scratch nmap <buffer> <silent> <C-y>g :exec "set lines=999 columns=" . (g:gundo_width + &columns) \| :GundoToggle<CR>
    au BufRead *.scratch nmap <buffer> <silent> ZZ :wa \| :call ScratchCopy()<CR> \| :macaction hide:<CR>
    au BufRead *.scratch nmap <buffer> <silent> ZZ :call ScratchCopy()<CR> \| :macaction hide:<CR>
    au BufRead *.scratch nmap <buffer> <silent> :w<CR> :write \| :silent call ScratchCopy()<CR>
    au BufRead *.scratch imap <buffer> <silent> ZZ <Esc>ZZ
    au BufRead *.scratch vmap <buffer> <silent> ZZ <Esc>ZZ
    " au! FocusGained *.scratch normal ggVGpG$
    au! FocusLost *.scratch call ScratchCopy()
    au! FocusGained *.scratch call ScratchPaste()
    au! VimResized *.scratch call SetColorColumnBorder() | :normal zz
augroup END

"}}}
" VCS Commit: " {{{
augroup VCSCommit
    au! BufRead hg-editor-* nmap <buffer> <silent> <C-e>d :set filetype=diff \| :r !hg diff<CR>gg
augroup END

" }}}
" Vimperator Y Pentadactyl: " {{{
augroup VimperatorYPentadactyl
    au! BufRead vimperator-*\|pentadactyl-* nmap <buffer> <silent> ZZ :call FormFieldArchive() \| :silent write \| :bd \| :macaction hide:<CR>
    au BufRead vimperator-*\|pentadactyl-* imap <buffer> <silent> ZZ <Esc>ZZ
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
augroup END

" }}}
" Gundo: " {{{
nnoremap <C-y>g :GundoToggle<CR>

" }}}
" Git Commit: " {{{
augroup helpfiles 
    au! FileType gitcommit nnoremap <buffer> <silent> <C-n> :DiffGitCached<CR>\|:wincmd L<CR>|:au FileType git nnoremap <buffer> <silent> <C-n> :hide<CR>
augroup END

" }}}
" Python Syntax: " {{{
let python_highlight_all = 1

" }}}
" PickAColor: " {{{
let g:pickacolor_use_web_colors = 1
" }}}
" HTML: " {{{
let g:no_html_tab_mapping=1
let g:no_html_toolbar=1

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
augroup BufExplorerAdd
    if !exists("g:BufExploreAdd")
        let g:BufExploreAdd = 1
        au BufWinEnter \[BufExplorer\] map <buffer> <Tab> <CR>
        " FIXME: Subsequent invocations fail with this autoselect for some reason.
        " Navigate to the file under the cursor when you let go of Tab
        "au BufWinEnter \[BufExplorer\] set updatetime=1000
        " o is the BufExplorer command to select a file
        "au! CursorHold \[BufExplorer\] normal o
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
" Todo Lists: " {{{
augroup todolist
    au! BufReadPost,FileReadPost *todo*,*list* doau FileType tst
    au BufReadPost,FileReadPost *todo*,*list* set syntax+=.txt
    au BufReadPost,FileReadPost *todo*,*list* map <buffer> <silent> <C-p> ?=\{1,} \(.*\) =\{1,}<CR>zt:nohlsearch<CR>
    au BufReadPost,FileReadPost *todo*,*list* map <buffer> <silent> <C-n> /=\{1,} \(.*\) =\{1,}<CR>zt:nohlsearch<CR>
augroup END

" }}}
" Vimwiki: " {{{
" Autocmds: " {{{
augroup vimwiki
    "au! BufReadPre *.wiki doau FileType txt
    au! BufReadPost,FileReadPost *.wiki doau FileType tst
    au FileType vimwiki set syntax=vimwiki.txt
    au FileType vimwiki map <buffer> <silent> <C-p> ?=\{1,} \(.*\) =\{1,}<CR>zt:nohlsearch<CR>
    au FileType vimwiki map <buffer> <silent> <C-n> /=\{1,} \(.*\) =\{1,}<CR>zt:nohlsearch<CR>
    au FileType *vimwiki* nmap <buffer> <silent> <CR> :call VimwikiFollowLinkMod()<CR>
    au FileType vimwiki nested map <buffer> <silent> <Leader>w2 <Esc>:w<CR>:VimwikiAll2HTML<CR><Esc>:echo "Saved wiki to HTML."<CR>
augroup END

" }}}
" Configuration: " {{{
"" let wiki.nested_syntaxes = {'python': 'python'}
let g:vimwiki_hl_headers = 1                " hilight header colors
let g:vimwiki_hl_cb_checked = 1             " hilight todo item colors
let g:vimwiki_list_ignore_newline = 0       " convert newlines to <br /> in list
let g:vimwiki_folding = 1                   " outline folding
let g:vimwiki_table_auto_fmt = 0            " don't use and conflicts with snipMate
let g:vimwiki_fold_lists = 1                " folding of list subitems
let g:vimwiki_file_exts = 'pdf,txt,doc,rtf,xls,php,zip,rar,7z,html,gz,vim,screen'
let g:vimwiki_valid_html_tags='b,i,s,u,sub,sup,kbd,br,hr,font,a,div,span'
let g:vimwiki_list = [
             \{'path': '~/sandbox/personal/vimwiki/',
                \'index': 'PersonalWiki',
                \'html_header': '~/sandbox/personal/vimwiki/header.tpl',
                \},
            \{'path': '~/sandbox/public/wiki',
                \'index': 'SethMilliken',
                \'auto_export': 1,
                \},
            \{'path': '~/sandbox/work/wiki/',
                \'index': 'SethMilliken',
                \'html_header': '~/sandbox/work/wiki/header.tpl',
                \'auto_export': 1,
                \},
                \]
" }}}
function! VimwikiExpandedPageName() " {{{
    return substitute(substitute(expand('%:t'), "[a-z]\\zs\\([A-Z]\\)", " \\1", "g"), "\\..*", "", "")
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

" }}}
" VimSheet: " {{{
augroup VimSheet
    au! BufRead /tmp/*.vim nmap <buffer> <CR> yyq:p<CR>
augroup END

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
    " save all sessions
    " hg addremove and ci ~/.vim/sessions/*
endfunction

" }}}
" Janrain:  " {{{
map <D-j>w <Esc>:cd ~/sandbox/work/vm/rpx/ruby/rails/<CR>
map <D-j>p <Esc>:cd ~/sandbox/personal/<CR>
map <D-j>e <Esc>:GrepEngage 
command! -nargs=1 GrepEngage call GrepEngage(<f-args>)
function! GrepEngage(string)
    echo "Searching Engage codebase for \"" . a:string . "\"...."
    let l:engage_path = "~/sandbox/work/vm/rpx/ruby/rails/**/*.rb"
    exec ":vimgrep /" . a:string . "/ " . l:engage_path
    copen
endfunction

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
map <Leader>sv :call OpenRelatedSnippetFileInVsplit()<CR>
function! OpenRelatedSnippetFileInVsplit() " {{{
    let snippetfile = input("Edit which related sunippet file? ", "", "custom,SnippetFilesForCurrentBuffer")
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

" Raimondi's stagnant mailapp plugin " {{{
let g:MailApp_bundle = '~/.vim/bundle/MailApp/MailApp.bundle/'
let g:MailAppl_from = 'Seth Milliken <seth@araxia.net>'

" }}}

map <Leader><CR> 0"ty$:<C-r>t<CR>:echo "Executed: " . @t<CR>

" Toggle number column: " {{{
" <A-1> to toggle between nu and rnu
if exists('+relativenumber')
  nnoremap <expr> ¡ ToggleNumberDisplay()
  xnoremap <expr> ¡ ToggleNumberDisplay()
  onoremap <expr> ¡ ToggleNumberDisplay()

  function! ToggleNumberDisplay()
      if &l:nu | setlocal rnu | else | setlocal nu | endif | redraw
  endfunction

endif

" }}}
" Diff of changes since opening file " {{{
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
endif

" }}}

" type number then : to get relative range prepopulated in cmdline
" new vocab word "idem" to get relative range prepopulated in cmdline
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
