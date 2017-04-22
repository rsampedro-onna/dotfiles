" This creates new delimiters 'l', 'L' and 'q' for vim-surround
let b:surround_108 = "\\\1command: \1{\r}"
let b:surround_76  = "\\begin{\1environment: \1}\r\\end{\1\1}"
let b:surround_113 = "`\r'"

inoremap <buffer> <C-L>  \label{
inoremap <buffer> [[     \begin{
