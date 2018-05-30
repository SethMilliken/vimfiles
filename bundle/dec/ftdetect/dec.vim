au BufNewFile,BufRead *.dec set filetype=dec | doau DecList FileType
au BufNewFile,BufRead *.txt if <SID>IsDraftLog(expand("<afile>")) | set filetype=dec | doau DecList FileType | endif

function! s:IsDraftLog(filename)
    return a:filename =~ '[a-Z]\+-\d\{4}\.\d\{1,2}\.\d\{1,2}-\d\{4}-\d\{7}-[A-Z0-9]\{9}\.txt'
endfunction
