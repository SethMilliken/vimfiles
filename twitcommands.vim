" Commands {{{
python << END
"""
" }}}
" Settings {{{
let twitvim_api_root = "https://api.twitter.com/1"
let twitvim_enable_python = 1
let twitvim_count = 25
let twitvim_count = 200
40wincmd  |
" }}}

FriendsTwitter
SearchTwitter stevelosh
SearchTwitter b4winckler
UserTwitter SethMilliken
ListTwitter barista
VimSearch
SearchTwitter #pentadactyl
SearchTwitter #MacVim
SearchTwitter #aspergers
NextSearchPage

ProfileTwitter SethMilliken
ProfileTwitter stevelosh

FollowTwitter b4winckler
FollowingTwitter
FollowersTwitter


" url shortners
Trim
BitLy

" New Tweet Buffer
new | set bt=nofile | wincmd J | 2wincmd _ | set colorcolumn=140 | map <buffer> <CR> :BPosttoTwitter

PosttoTwitter
" CPosttoTwitter
" BPosttoTwitter

" Keybindings {{{
" long version of url
" \e
" profile info
" \p
" timeline of user
" \g
" delete tweet
" \X
" add tweet to favorites
" \f
" remove tweet from favorites
" \<C-f>
" previous timeline
" <C-o>
" next timeline
" <C-i>
" refresh timeline
" \\
" }}}
" Command Listing {{{
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
" End Commands {{{
"""
END
" }}}
" TwitVim Commands {{{
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
               \ "#Follow",
               \ "#FOLLOW",
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
