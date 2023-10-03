au BufNewFile,BufRead *.tst,*.scratch nested doau FileType tst | set syntax=txt
au FileType tst set filetype=txt.tst syntax=txt
au FileType tst TaskStack
