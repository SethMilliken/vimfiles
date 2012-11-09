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
" TS#<####>, PF#<####>, BUG:, FIXME:, etc.
syntax match bug /\%(mt\|MT\|jr\|JR\|TS\|PF\|BUG\|FIXME\|STORY\|[A-Z]\{2,}\)[:# -]\+[0-9]\+[ :.]/
" `quote`
syntax match quotation /`.*`/
" SECTION
syntax match section /^\([A-Z]\+ \)\{1,\}/
" @context
syntax match context /\s\+\zs@\([0-9a-z.]\+\)\{1,\}/
" @context header
syntax match contextheader /^@\([0-9a-z.]\+ \)\{1,\}/me=e-1
" = statement
syntax region declaration start="\%(^\|^\s\+\)= " end="\n" contains=bug,date,quotation,context,url,eoltimestamp oneline
" ? question about item
syntax region undetermined start="\%(^\|^\s\+\)? " end="\n" contains=bug,date,quotation,context,url,eoltimestamp oneline
" o completed todo item
" x abandoned todo item
syntax region done start="\%(^\|^\s\+\)[o] " end="\n" contains=bug,date,quotation,context,url oneline
syntax region abandoned start="\%(^\|^\s\+\)[x] " end="\n" contains=bug,date,quotation,context,url oneline
" $ costs money
syntax match expense /\%(^\|^\s\+\)\$\s\+/
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
highlight default link undetermined Question
highlight default link expense MoreMsg
highlight default link url Underlined
highlight default link duration WarningMsg
highlight default link date SpecialKey
highlight default link eoltimestamp Ignore
highlight! default link quotation Special
" }}}
