" Description:  modification of kami stachowski's 'kellys' colorscheme
"  Maintainer:  Seth Milliken <seth_vim@araxia.net>
"     License:  gpl 3+
"     Version:  .2 (2011.04.10)

" changelog:
"         0.2:  2011.04.10
"               added support for rails keyword highlighting
"         0.1:  2011.01.14
"               initial release of modifications into the wild
" note:
"       If you're editing colors files hexhilight.vim is great for showing you
"       the hex values in the colors they define.
"       <http://www.vim.org/scripts/script.php?script_id=2937>

set background=dark

if version > 580
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif

let colors_name = "araxia"

" black         #000000
" blue          #62acce  81
" blue slight   #9ab2c8  74
" brown slight  #d1c79e  144
" green yellowy #d1d435  184
" grey dark     #67686b  240
" grey light    #e1e0e5  254
" orange        #e6ac32  178
" red           #9d0e15  124

" tabline

if has("gui_running")
    hi Comment      guifg=#67686b   guibg=#000000   gui=none
    hi Cursor       guifg=#708090   guibg=#f0e68c   gui=none
    hi Conceal      guifg=#e1e0e5   guibg=#67686b   gui=none
    hi Constant     guifg=#d1c79e   guibg=#000000   gui=none
    if has("gui_macvim")
        hi CursorLine               guibg=#022222   gui=none
    else
        hi CursorLine               guibg=#303132   gui=none
    endif
    hi DiffAdd      guifg=#000000   guibg=#9ab2c8   gui=none
    hi DiffChange   guifg=#000000   guibg=#d1c79e   gui=none
    hi DiffDelete   guifg=#67686b   guibg=#000000   gui=none
    hi DiffText     guifg=#9d0e15   guibg=#d1c79e   gui=none
    hi Folded       guifg=#ffd700   guibg=#222222   gui=none
    hi MatchParen   guifg=#d1d435   guibg=#000000   gui=bold,underline
    hi ModeMsg      guifg=#e1e0e5   guibg=#000000   gui=bold
    hi Normal       guifg=#e1e0e5   guibg=#000000   gui=none
    hi Pmenu        guifg=#000000   guibg=#9ab2c8   gui=none
    hi PmenuSel     guifg=#000000   guibg=#62acce   gui=bold
    hi PmenuSbar    guifg=#000000   guibg=#000000   gui=none
    hi PmenuThumb   guifg=#000000   guibg=#62acce   gui=none
    hi PreProc      guifg=#d1d435   guibg=#000000   gui=none
    "" hi Search    guifg=#000000   guibg=#e1e0e5   gui=none
    hi Special      guifg=#9ab2c8   guibg=#000000   gui=none
    hi Statement    guifg=#62acce   guibg=#000000   gui=bold
    hi StatusLine   guifg=#000000   guibg=#62acce   gui=bold
    hi StatusLineNC guifg=#000000   guibg=#e1e0e5   gui=none
    "" hi Todo      guifg=#e1e0e5   guibg=#9d0e15   gui=bold
    hi Type         guifg=#e6ac32   guibg=#000000   gui=none
    "" hi Underlined guifg=#e1e0e5   guibg=#000000   gui=underline
    hi Underlined   guifg=#80a0ff   gui=underline term=underline cterm=underline ctermfg=81
    "" hi Visual    guifg=#000000   guibg=#e1e0e5   gui=none
    hi Wildmenu     guifg=#62acce   guibg=#000000   gui=bold

    hi Todo        term=standout    ctermfg=196     ctermbg=226 guifg=#ff4500   guibg=#eeee00
    hi Error       term=reverse     ctermfg=15      ctermbg=9   guifg=White     guibg=Red


    hi WarningMsg  term=standout    ctermfg=209                 guifg=#fa8072
    hi Visual      term=reverse     cterm=reverse ctermfg=64 ctermbg=222 gui=reverse guifg=#6b8e23 guibg=#f0e68c
    "hi Pmenu           cterm=reverse ctermfg=52 ctermbg=222 gui=reverse guifg=#544444 guibg=#f0e68c
    hi PmenuSel        ctermfg=52 ctermbg=222 guifg=#544444 guibg=#f0e68c
    "hi PmenuSbar   ctermbg=235 guibg=#333333
    "hi PmenuThumb  cterm=reverse ctermbg=222 gui=reverse guibg=#f0e68c
    hi Ignore       guifg=#323232   guibg=#000000   gui=none
    hi NonText      guifg=#555555   guibg=#000000   gui=none
    hi SpecialKey   term=bold       ctermfg=112 guifg=#9acd32
    hi Search       term=reverse    ctermfg=223 ctermbg=172 guifg=#f5deb3 guibg=#cd853f
    hi IncSearch    term=reverse    ctermfg=223 ctermbg=172 guibg=#000000 guifg=#cd85f5
    hi MoreMsg      term=bold       ctermfg=29  gui=bold    guifg=#2e8b57
    hi Question     term=bold       ctermfg=29  gui=bold    guifg=#0c6a35
    " hi Question   term=standout   ctermfg=48  gui=bold    guifg=#00ff7f
    hi SpellBad     term=reverse    ctermbg=9   gui=undercurl   guisp=Red
    hi SpellCap     term=reverse    ctermbg=12  gui=undercurl   guisp=Blue
    hi SpellRare    term=reverse    ctermbg=13  gui=undercurl   guisp=Magenta
    hi SpellLocal   term=underline  ctermbg=14  gui=undercurl   guisp=Cyan
    hi LineNr       term=underline  ctermfg=11  guifg=Yellow
    hi rubyMethod   term=bold       ctermfg=11  guifg=Yellow
    hi Regexp       term=reverse    ctermfg=Red guifg=Red

else
    if &t_Co == 256
        hi Comment      ctermfg=239 ctermbg=235 cterm=none
        hi Cursor       ctermfg=235 ctermbg=254 cterm=none
        hi Constant     ctermfg=144 ctermbg=235 cterm=none
        hi CursorLine               ctermbg=236 cterm=none
        hi DiffAdd      ctermfg=235 ctermbg=74  cterm=none
        hi DiffChange   ctermfg=235 ctermbg=144 cterm=none
        hi DiffDelete   ctermfg=239 ctermbg=235 cterm=none
        hi DiffText     ctermfg=124 ctermbg=144 cterm=none
        hi Folded       ctermfg=239 ctermbg=235 cterm=none
        hi MatchParen   ctermfg=184 ctermbg=235 cterm=bold,underline
        hi ModeMsg      ctermfg=254 ctermbg=235 cterm=bold
        hi Normal       ctermfg=254 ctermbg=235 cterm=none
        hi Pmenu        ctermfg=235 ctermbg=74  cterm=none
        hi PmenuSel     ctermfg=235 ctermbg=81  cterm=bold
        hi PmenuSbar    ctermfg=235 ctermbg=235 cterm=none
        hi PmenuThumb   ctermfg=235 ctermbg=81  cterm=none
        hi PreProc      ctermfg=184 ctermbg=235 cterm=none
        hi Search       ctermfg=235 ctermbg=254 cterm=none
        hi Special      ctermfg=74  ctermbg=235 cterm=none
        hi Statement    ctermfg=81  ctermbg=235 cterm=none
        hi StatusLine   ctermfg=235 ctermbg=81  cterm=bold
        hi StatusLineNC ctermfg=235 ctermbg=254 cterm=none
        hi Todo         ctermfg=254 ctermbg=124 cterm=bold
        hi Type         ctermfg=178 ctermbg=234 cterm=none
        hi Underlined   ctermfg=254 ctermbg=234 cterm=underline
        hi Visual       ctermfg=235 ctermbg=254 cterm=none
        hi Wildmenu     ctermfg=81  ctermbg=234 cterm=bold
    endif
endif

hi! link Boolean        Constant
hi! link Character      Constant
hi! link Conditional    Statement
hi! link CursorColumn   CursorLine
hi! link Debug          Special
hi! link Define         PreProc
hi! link Delimiter      Special
hi! link Directory      Type
"" hi! link Error           Todo
hi! link ErrorMsg       Error
hi! link Exception      Statement
hi! link Float          Constant
hi! link FoldColumn     Folded
hi! link Function       Normal
hi! link Identifier     Special
"" hi! link Ignore          Comment
"" hi! link IncSearch       Search
hi! link Include        PreProc
hi! link Keyword        Statement
hi! link Label          Statement
"" hi! link LineNr          Comment
hi! link Macro          PreProc
"" hi! link MoreMsg     ModeMsg
"" hi! link NonText     Comment
hi! link Number         Constant
hi! link Operator       Special
hi! link PreCondit      PreProc
"" hi! link Question        MoreMsg
hi! link Repeat         Statement
hi! link SignColumn     FoldColumn
hi! link SpecialChar    Special
hi! link SpecialComment Special
"" hi! link SpecialKey      Special
"" hi! link SpellBad        Error
"" hi! link SpellCap        Error
"" hi! link SpellLocal      Error
"" hi! link SpellRare       Error
hi! link StorageClass   Type
hi! link String         Constant
hi! link Structure      Type
hi! link Tag            Special
hi! link Title          ModeMsg
hi! link Typedef        Type
hi! link VertSplit      StatusLineNC
"" hi! link WarningMsg      Error

" ada
hi! link adaBegin           Type
hi! link adaEnd             Type
hi! link adaKeyword         Special
" c++
hi! link cppAccess          Type
hi! link cppStatement       Special
" hs
hi! link ConId              Type
hi! link hsPragma           PreProc
hi! link hsConSym           Operator
" html
hi! link htmlArg			Statement
hi! link htmlEndTag			Special
hi! link htmlItalic			Underlined
hi! link htmlLink			Underlined
hi! link htmlSpecialTagName	PreProc
hi! link htmlTag			Special
hi! link htmlTagName		Type
" java
hi! link javaTypeDef        Special
" lisp
hi! link lispAtom			Constant
hi! link lispAtomMark		Constant
hi! link lispConcat			Special
hi! link lispDecl			Type
hi! link lispFunc			Special
hi! link lispKey			PreProc
" netrw
hi! link netrwDir			Special
hi! link netrwExe			Wildmenu
hi! link netrwSymLink		Statement
" pas
hi! link pascalAsmKey       Statement
hi! link pascalDirective    PreProc
hi! link pascalModifier     PreProc
hi! link pascalPredefined   Special
hi! link pascalStatement    Type
hi! link pascalStruct       Type
" php
hi! link phpComparison      Special
hi! link phpDefine          Normal
hi! link phpIdentifier      Normal
hi! link phpMemberSelector  Special
hi! link phpRegion          Special
hi! link phpVarSelector     Special
" py
hi! link pythonStatement    Type
" rails
hi link railsMethod         PreProc
hi link rubyDefine          Type
hi link rubySymbol          Constant
hi link rubyAccess          rubyMethod
hi link rubyAttribute       rubyMethod
hi link rubyEval            rubyMethod
hi link rubyException       rubyMethod
hi link rubyInclude         rubyMethod
hi link rubyStringDelimiter rubyString
hi link rubyRegexp          Regexp
hi link rubyRegexpDelimiter rubyRegexp
" rb
hi! link rubyConstant       Special
" scm
hi! link schemeSyntax       Special
" sh
hi! link shArithRegion      Normal
hi! link shDerefSimple      Normal
hi! link shDerefVar         Normal
hi! link shFunction         Type
hi! link shLoop             Statement
hi! link shStatement        Special
hi! link shVariable         Normal
" sql
hi! link sqlKeyword			Statement
" tex
hi! link texDocType			PreProc
hi! link texLigature		Constant
hi! link texMatcher			Normal
hi! link texNewCmd			PreProc
hi! link texOnlyMath		Constant
hi! link texRefZone			Constant
hi! link texSection			Type
hi! link texSectionMarker	Type
hi! link texSectionModifier	Constant
hi! link texTypeSize		Special
hi! link texTypeStyle		Special
" vim
hi! link vimCommand         Statement
hi! link vimCommentTitle    Normal
hi! link vimEnvVar          Special
hi! link vimFuncKey         Type
hi! link vimGroup           Special
hi! link vimHiAttrib        Constant
hi! link vimHiCTerm         Special
hi! link vimHiCtermFgBg     Special
hi! link vimHighlight       Special
hi! link vimHiGui           Special
hi! link vimHiGuiFgBg       Special
hi! link vimOption          Special
hi! link vimSyntax          Special
hi! link vimSynType         Special
hi! link vimUserAttrb       Special
" xml
hi! link xmlAttrib			Special
hi! link xmlCdata			Normal
hi! link xmlCdataCdata		Statement
hi! link xmlCdataEnd		PreProc
hi! link xmlCdataStart		PreProc
hi! link xmlDocType			PreProc
hi! link xmlDocTypeDecl		PreProc
hi! link xmlDocTypeKeyword	PreProc
hi! link xmlEndTag			Statement
hi! link xmlProcessingDelim	PreProc
hi! link xmlNamespace		PreProc
hi! link xmlTagName			Statement

" hi! link TexTypeStyle		Comment
" hi! link TexStatement		Comment
" hi! link TexRefZone			Normal
" hi! link TexSectionName		Comment
" hi! link TexSectionMarker	Comment
" hi! link Delimiter			Comment
" hi! link TexMatcher			Comment
