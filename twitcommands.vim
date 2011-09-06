" Commands " {{{
python << END
"""
" }}}
" Settings " {{{
let twitvim_api_root = "https://api.twitter.com/1"
let twitvim_enable_python = 1
let twitvim_count = 25
let twitvim_count = 200
let twitvim_count = 100
40wincmd  |
" }}}

FriendsTwitter
VimSearch
SearchTwitter dotvimrc
SearchTwitter #MacVim
SearchTwitter #Lion
SearchTwitter stevelosh
SearchTwitter b4winckler
SearchTwitter #rails
SearchTwitter jemmons
SearchTwitter james_herdman
SearchTwitter evanrkeller
SearchTwitter mikelikesbikes
SearchTwitter cleverdevil
SearchTwitter JonRowe
SearchTwitter tungd
UserTwitter SethMilliken
SearchTwitter SethMilliken
ListTwitter ruby
SearchTwitter #Xcode
SearchTwitter #pentadactyl
SearchTwitter jerojasro
SearchTwitter @despo
SearchTwitter blzysh
SearchTwitter morticed
SearchTwitter bavarious
NextSearchPage

ProfileTwitter SethMilliken
ProfileTwitter stevelosh

FollowTwitter b4winckler
FollowingTwitter
FollowersTwitter

" url shortners
Trim
BitLy

" <D-j>t New Tweet Buffer

" Keybindings " {{{
" \e  long version of url
" \p  profile info
" \g timeline of user
" \X delete tweet
" \f add tweet to favorites
" \<C-f>  remove tweet from favorites
" \<C-o>  previous timeline
" \ <C-i>  next timeline
" \\  refresh timeline
" }}}
" Command Listing " {{{
RateLimitTwitter
SendDMTwitter
UserTwitter
twitvim_count
FriendsTwitter
MentionsTwitter
RepliesTwitter
PublicTwitter
DMTwitter
DMSentTwitter
ListTwitter
RetweetedToMeTwitter
RetweetedByMeTwitter
FavTwitter
FollowingTwitter
FollowersTwitter
MembersOfListTwitter
SubsOfListTwitter
OwnedListsTwitter
MemberListsTwitter
SubsListsTwitter
FollowListTwitter
UnfollowListTwitter
BackTwitter
BackInfoTwitter
ForwardTwitter
ForwardInfoTwitter
RefreshTwitter
RefreshInfoTwitter
NextTwitter
NextInfoTwitter
PreviousTwitter
PreviousInfoTwitter
SetLoginTwitter
ResetLoginTwitter
FollowTwitter
UnfollowTwitter
BlockTwitter
UnblockTwitter
ReportSpamTwitter
AddToListTwitter
RemoveFromListTwitter
" }}}
" End Commands " {{{
"""
END
" }}}
" TwitVim Commands " {{{
map <buffer> <silent> <CR> yyq:p<CR> \| :wincmd h<CR>
map <buffer> <silent> <D-j>n :wincmd h \| :call NextSearchPage() \| :wincmd h<CR>
map <buffer> <silent> <D-j>v :wincmd h \| :call TwitVimVimSearch() \| :wincmd h<CR>
map <buffer> <silent> <D-j>t <Plug>NewTweet
map <buffer> <silent> <D-j>j :40wincmd <bar><CR>
noremap <script> <Plug>NewTweet :call <SID>NewTweet()<CR>
command! NextSearchPage :call s:NextSearchPage()
command! VimSearch :call s:TwitVimVimSearch()
function! s:NewTweet()
    new | set bt=nofile | wincmd J | 1wincmd _ | set colorcolumn=140 | map <buffer> <CR> :BPosttoTwitter
endfunction
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
    if match(expand("%:p:t"), "Twitter_") > -1
        silent exec "2,$g/" . s:BlackList() . "/d"
        " silent %s/^\(.\{-}:\)\([^|]*\)|\(.\{-}\)/\=printf("%20s %s\r%125s", submatch(1), submatch(2), "|" . submatch(3))/e
        normal gg
    endif
endfunction
function! s:BlackList()
   let l =     [
               \ "#JMG",
               \ "vimradio",
               \ "#TFB",
               \ "#teamfollowback",
               \ "★",
               \ "☆",
               \ "#follow",
               \ "#Follow",
               \ "#FOLLOW",
               \ "followers",
               \ "NERDYCHiiCK",
               \ "NeRdYChiiCk",
               \ "#TeamFollowBack",
               \ "#TEAMFOLLOWBACK",
               \ "#TeamFOLLOWBACK",
               \ "NiCCiisNeechee",
               \ "VERSATHEISSUE",
               \ "#ff",
               \ "#FF",
               \ "CouchMoneySweet",
               \ "BlakMuzick",
               \ "#VIM",
               \ ]
   return join(l, "\\\|")
endfunction

" vim: nowrap fdl=0
" }}}
" vim: set cms=\ \"\ %s:
