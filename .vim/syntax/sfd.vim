if exists("b:current_syntax")
  finish
endif

highlight link Vernacular Statement 
highlight link National   Identifier
highlight link Nota       Comment

" Sintaxe para dobras
syntax region Lexeme      matchgroup=Vernacular start='\\lx.*' end='\n\\lx' fold contains=ALL

" Sintaxe para arquivos do Toolbox de banca de dados de texto
syntax match Nota         /\\nt.*$/ fold
syntax match Vernacular   /\\\(lc\|a\|u\|xv\).*$/ fold
syntax match National     /\\\(gn\|xn\).*$/ fold

let b:current_syntax = "sfd"
