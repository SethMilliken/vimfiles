if did_filetype()
	finish
endif
" Detect filetype from file contents if can't get it from name.
if getline(1) =~ '^DOING' " TODO: main node name should not be hardcoded
	set filetype=_.txt.tst foldmethod=marker commentstring=
	doau BufRead,InsertLeave,FocusLost *.tst.*
endif

" Default if filetype still was not recognized
if &filetype == ""
	set filetype=txt foldmethod=marker commentstring=
endif
