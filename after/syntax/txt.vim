syntax match foldtitle /.*{{{/me=e-3
syntax match foldmarkbegin /{{{/
syntax match foldmarkend /}}}/
syntax region vimopts start="vim:" end="$"
highlight default link vimopts Ignore
highlight default link foldtitle Comment
highlight default link foldmarkbegin Ignore
highlight default link foldmarkend Ignore
function! MyFoldText()
		let indentation = 35
		let fullline = getline(v:foldstart)
		let line = substitute(fullline, '{{{', '', 'g')
		let linecount = v:foldend - v:foldstart - 2
		let linewidth = indentation - v:foldlevel - strlen(line)
		let folddash = '+-----------'
		let decoratedline = printf("%.*s %s %*s", v:foldlevel, folddash, line, linewidth, linecount.' lines')
		let decoratedline = substitute(decoratedline, '^+\(.*\)done', 'o\1DONE', 'g')
		return decoratedline
endfunction
set foldtext=MyFoldText()
