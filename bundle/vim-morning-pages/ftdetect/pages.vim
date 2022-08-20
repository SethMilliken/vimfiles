au BufNewFile,BufRead */zlog/[0123456789]\\\{4\}-[0123456789]\\\{2\}-[0123456789]\\\{2\}.txt set filetype=pages.txt | call pages#writingMappings()
au BufNewFile,BufRead */zlog/[0123456789]\\\{4\}-[0123456789]\\\{2\}-index.txt set filetype=pages.txt | call pages#writingMappings()
