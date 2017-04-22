if exists("b:current_syntax")
  finish
endif

" highlight link Beginning Delimiter
highlight link Value     String
highlight link Name      Identifier

" Sintaxe para dobras
syntax region Region start='^\(Info\|Bookmark\|PageMedia\)Begin'
                   \ end='\n^\(Info\|Bookmark\|PageMedia\)Begin'
                   \ fold contains=ALL

" Sintaxe
" syntax match Beginning /^\(Info\|Bookmark\|PageMedia\)Begin/ fold
syntax match Value     /^[^:]\+: \zs.*$/                     fold
syntax match Name      /^[^:]\+\ze:/                         fold

let b:current_syntax = "pdfmeta"
