" syntax {{{
" expanded fold
syntax match foldtitle /.*{\{3\}{/me=e-3
syntax match foldmarkbegin /{\{3\}/
syntax match foldmarkend /}\{3\}/
" YYYY-MM-DD
syntax match date /[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} /
" end of line timestamp
syntax match eoltimestamp /[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\} [A-Z]\{3\}\s*\({\(\w*,*\s*\)*}\)*$/
" <protocol://url>
syntax match url /[a-z]*:\/\/[^ >]*/
" + ongoing todo item
" ( ) ongoing with range
syntax region duration start="^\s*(.)\|\%(^\|^\s\+\)+" end="\s\|$" oneline
" Ticket: JIRAPROJECT-<#####> TS#<####>, PF#<####>, BUG:, FIXME:, etc.
syntax match bug /[A-Z]\{3,}[:# -]\+[0-9]\+[ :.]/
" `quote`
syntax region quotation start="`" end="`" keepend

" SECTION
syntax match section /^\([A-Z]\{2,}\([[:space:]]\|$\)\)\{1,\}/
" @context
syntax match context /\s\+\zs@\([-_+.0-9a-z]\+\)\{1,\}\ze\(\s\+\|$\)/
" @context header
syntax match contextheader /^@\([-_+.0-9a-z]\+ \)\{1,\}/me=e-1
" = statement
syntax region declaration start="\%(^\|^\s\+\)= " end="\n" contains=bug,date,quotation,context,url,eoltimestamp oneline
" ! caution
"syntax region caution start="\%(^\|^\s\+\)! " end="\n" contains=bug,date,quotation,context,url,eoltimestamp oneline
syntax region caution start="\%(^\|^\s\+\zs\)!" end="\ze\s\|$" oneline
" ? question about item
syntax region undetermined start="\%(^\|^\s\+\)? " end="\n" contains=bug,date,quotation,context,url,eoltimestamp oneline
" o completed todo item
" x abandoned todo item
syntax region done start="\%(^\|^\s\+\)[o] " end="\n" contains=bug,date,quotation,context,url oneline
syntax region abandoned start="\%(^\|^\s\+\)[x] " end="\n" contains=bug,date,quotation,context,url oneline
" $ costs money
syntax match expense /\%(^\|^\s\+\)\$\s\+/
" divider
syntax match divider /^[^/[:space:]]\{30,}$/
" modeline
syntax region modeline start="^vim:" end="$" oneline
" }}}
" highlights {{{
highlight default link modeline Ignore
highlight default link foldtitle Special
highlight default link foldmarkbegin Ignore
highlight default link foldmarkend Ignore
highlight default link bug SpecialKey
highlight default link done NonText
highlight default link abandoned Ignore
highlight default link contextheader DiffText
highlight default link context Statement
highlight default link section Directory
highlight default link declaration Constant
highlight default link caution Error
highlight default link undetermined Question
highlight default link expense MoreMsg
highlight default link divider PreProc
highlight default link url Underlined
highlight default link duration WarningMsg
highlight default link date SpecialKey
highlight default link eoltimestamp Ignore
highlight! default link quotation Special
" }}}
