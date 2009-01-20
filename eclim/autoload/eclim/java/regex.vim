" Author:  Eric Van Dewoestine
" Version: $Revision: 1677 $
"
" Description: {{{
"   see http://eclim.sourceforge.net/vim/java/regex.html
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

" Script Variables {{{
  let s:command_regex = '-command java_regex -f "<file>"'
" }}}

" Evaluate(file) {{{
function eclim#java#regex#Evaluate (file)
  let command = s:command_regex
  let command = substitute(command, '<file>', a:file, '')
  if exists('b:eclim_regex_type')
    let command .= ' -t ' . b:eclim_regex_type
  endif
  return eclim#ExecuteEclim(command)
endfunction " }}}

" vim:ft=vim:fdm=marker
