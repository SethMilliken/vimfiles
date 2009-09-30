" syntax " {{{
" expanded fold
syntax match foldtitle /.*{{{/me=e-3
syntax match foldmarkbegin /{{{/
syntax match foldmarkend /}}}/
" YYYY-MM-DD
syntax match date /[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} /
" <protocol://url>
syntax match url /[a-z]*:\/\/[^ >]*/
" ( )
" + ongoing todo item
syntax region duration start="^\s*(.)\|\%(^\|^\s\+\)+" end="\s\|$" oneline
" TS#<####>, PF#<####>, BUG:, FIXME: 
syntax region bug start="\%(\%(TS#\|PF#\)[0-9]\+\|BUG:\|FIXME:\|STORY:\)" end="\s\|$" oneline
" = statement
syntax region statement start="\%(^\|^\s\+\)= " end="$" contains=bug,date,url oneline
" o completed todo item
" x abandoned todo item
syntax region done start="\%(^\|^\s\+\)[ox] " end="$" contains=bug,date,url oneline
" ? question about item
syntax region undetermined start="\%(^\|\s\+\)? " end="$" contains=bug,date,url oneline
" modeline
syntax region modeline start="vim:" end="$"
" }}} }}}
" highlights {{{
highlight default link modeline Ignore
highlight default link foldtitle Comment
highlight default link foldmarkbegin Ignore
highlight default link foldmarkend Ignore
highlight default link bug Identifier
highlight default link done Ignore
highlight default link statement Tag
highlight default link undetermined Special
highlight default link url VisualNOS
highlight default link duration Macro
highlight default link date SpecialKey
" }}}
function! MyFoldText() "{{{
	let indentation = 35
	let fullline = getline(v:foldstart)
	let line = substitute(fullline, '{{'. '{', '', 'g')
	let linecount = v:foldend - v:foldstart - 2
	let linewidth = indentation - v:foldlevel - strlen(line)
	let folddash = '+-----------'
	let decoratedline = printf("%.*s %s %*s", v:foldlevel, folddash, line, linewidth, linecount.' lines')
	let decoratedline = substitute(decoratedline, '^+\(.*\)done', 'o\1DONE', 'g')
	return decoratedline
endfunction "}}}
set foldtext=MyFoldText()
