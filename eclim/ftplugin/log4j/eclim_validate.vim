" Author:  Eric Van Dewoestine
" Version: $Revision: 1677 $
"
" Description: {{{
"   see http://eclim.sourceforge.net/vim/java/log4j/validate.html
"
" License:
"
" Copyright (c) 2005 - 2008
"
" Licensed under the Apache License, Version 2.0 (the "License");
" you may not use this file except in compliance with the License.
" You may obtain a copy of the License at
"
"      http://www.apache.org/licenses/LICENSE-2.0
"
" Unless required by applicable law or agreed to in writing, software
" distributed under the License is distributed on an "AS IS" BASIS,
" WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
" See the License for the specific language governing permissions and
" limitations under the License.
"
" }}}

" Global Variables {{{
if !exists("g:EclimLog4jValidate")
  let g:EclimLog4jValidate = 1
endif
" }}}

if g:EclimLog4jValidate
  augroup eclim_log4j_validate
    autocmd! BufWritePost <buffer>
    autocmd BufWritePost <buffer> call eclim#common#validate#Validate('log4j', 1)
  augroup END
endif

" disable plain xml validation.
augroup eclim_xml
  autocmd!
augroup END

" Command Declarations {{{
command! -nargs=0 -buffer Validate :call eclim#common#validate#Validate('log4j', 0)
" }}}

" vim:ft=vim:fdm=marker
