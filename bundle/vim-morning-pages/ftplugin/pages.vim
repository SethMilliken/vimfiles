augroup MorningPages | au!
   if pages#isPagesEntry(bufname("%"))
    au BufRead * call pages#writingMappings()
   end
   au FocusLost * nested call WriteBufferIfWritable()
augroup END
