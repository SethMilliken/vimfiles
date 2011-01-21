" Commands {{{
python << END
"""
" }}}
let twitvim_count = 25
FriendsTwitter
UserTwitter stevelosh
VimSearch
NextSearchPage

UserTwitter SethMilliken
BitLy http://pqrs.org/macosx/keyremap4macbook/
" End Commands {{{
"""
END
" }}}
" Twitter Commands {{{
map <buffer> <CR> yyq:p<CR> \| :wincmd h<CR>
map <buffer> <D-j>t :wincmd h \| :call NextSearchPage() \| :wincmd h<CR>
map <buffer> <D-j>v :wincmd h \| :call TwitVimVimSearch() \| :wincmd h<CR>
command! NextSearchPage :call s:NextSearchPage()
command! VimSearch :call s:TwitVimVimSearch()
function! s:TwitterSetup()
    let twitvim_count = 200
endfunction
function! s:TwitVimVimSearch()
    call s:TwitterSetup()
    exe ":SearchTwitter #vim -source:twaitter -Sovereign_VIM -Caesar_Poe -StephtheShocker -Qadar220 -followback -AUMA -MTV -☆• -NiCCiISNeechee"
    call s:VimSearchCleanup()
endfunction
function! s:NextSearchPage()
    call s:TwitterSetup()
    exe ":NextTwitter"
    call s:VimSearchCleanup()
endfunction
function! s:VimSearchCleanup()
    wincmd l | set modifiable
    silent exec "2,$g/" . s:BlackList() . "/d"
    silent %s/^\(.\{-}:\)\([^|]*\)|\(.\{-}\)/\=printf("%20s %s\r%125s", submatch(1), submatch(2), "|" . submatch(3))/e
    normal gg
endfunction
function! s:BlackList()
   let l =     [
               \ "bar",
               \ "baz",
               \ "#teamfollowback",
               \ "☆",
               \ "#follow",
               \ "followers",
               \ "NERDYCHiiCK",
               \ "NeRdYChiiCk",
               \ "#TeamFollowBack",
               \ "NiCCiisNeechee",
               \ "VERSATHEISSUE",
               \ "#ff",
               \ "BlakMuzick",
               \ ]
   return join(l, "\\\|")
endfunction

" vim: nowrap fdl=0
" }}}
