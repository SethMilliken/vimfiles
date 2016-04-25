" vim-airline theme based on ubaryd

" Normal mode
let s:N1 = [ '#242424' , '#F4F4F4' , 232 , 252 ]
let s:N2 = [ '#FA0000' , '#242424' , 252, 238 ]
let s:N3 = [ '#FACA33' , '#242321' , 242, 235 ]
let s:N4 = [ '#A4A4A4' , 243 ]

" Insert mode
let s:I1 = [ '#242424' , '#FACA33' , 232 , 221 ]
let s:I2 = [ '#c7b386' , '#45413b' , 252 , 238 ]
let s:I3 = [ '#f4cf86' , '#020202' , 242 , 235 ]
let s:I4 = [ '#FA0000' , '#020202' , 222 , 235 ]

" Visual mode
let s:V1 = [ '#1c1b1a' , '#9a4820' , 220 , 88 ]
let s:V2 = [ '#FA0000' , '#242424' , 252, 238 ]
let s:V3 = [ '#f4cf86' , '#020202' , 242 , 235 ]
let s:V4 = [ '#c14c3d' , 160 ]

" Replace mode
let s:RE = [ '#c7915b' , 173 ]

" Paste mode
let s:PA = [ '#fade3e' , 154 ]

let s:IA = [ s:N2[1], s:N3[1], s:N2[3], s:N3[3], '' ]

let g:airline#themes#araxia#palette = {}

let g:airline#themes#araxia#palette.accents = {
      \ 'red': [ '#ff7400' , '' , 196 , '' , '' ],
      \ }

let g:airline#themes#araxia#palette.inactive = {
      \ 'airline_a' : [ s:N2[1] , s:N3[1] , s:N2[3] , s:N3[3] , '' ] }


let g:airline#themes#araxia#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#araxia#palette.normal_modified = {
      \ 'airline_c' : [ s:I4[0] , s:I4[1] , s:I4[2] , s:I4[3] , '' ]
      \ }
"

let g:airline#themes#araxia#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#araxia#palette.insert_modified = {
      \ 'airline_c' : [ s:I4[0] , s:I4[1] , s:I4[2] , s:I4[3] , '' ]
      \ }
let g:airline#themes#araxia#palette.insert_paste = {
      \ 'airline_a' : [ s:I1[0] , s:PA[0] , s:I1[2] , s:PA[1] , '' ] }


let g:airline#themes#araxia#palette.replace = copy(airline#themes#araxia#palette.insert)
let g:airline#themes#araxia#palette.replace.airline_a = [ s:I1[0] , s:RE[0] , s:I1[2] , s:RE[1] , '' ]
let g:airline#themes#araxia#palette.replace_modified = g:airline#themes#araxia#palette.insert_modified


let g:airline#themes#araxia#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#araxia#palette.visual_modified = g:airline#themes#araxia#palette.insert_modified

let g:airline#themes#araxia#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
let g:airline#themes#araxia#palette.inactive_modified = {
      \ 'airline_c' : [ s:V1[1] , ''      , s:V1[3] , ''      , '' ] }

