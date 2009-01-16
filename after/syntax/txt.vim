syntax match foldtitle /.*{{{/me=e-3
syntax match foldmarkbegin /{{{/
syntax match foldmarkend /}}}/
syntax region vimopts start="vim:" end="$"
highlight default link vimopts Ignore
highlight default link foldtitle Comment
highlight default link foldmarkbegin Ignore
highlight default link foldmarkend Ignore
