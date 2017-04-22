if exists("b:current_syntax")
  finish
endif

highlight link Vernacular Statement 
highlight link National   Identifier
highlight link Nota       Comment
highlight link Fonte      Function
highlight link Outros     Normal

" Sintaxe para dobras
syntax region Session     start='\\id' end='\n\\id' fold contains=ALL

" esse próxima era pra dobrar as análises interlineares, mas aí ficam me incomodando os espaços brancos entre as palavras que ficam. uma hora descubro como é que faz pra alterar automaticamente a aparência das que ficam (e olha que tem que ser só quando a glosa interlinear esteja fechada

"syntax region Interlinear  matchgroup=Vernacular start='\\mb.*' matchgroup=Default end='\\ps.*' fold contains=ALL

" Sintaxe para arquivos do Toolbox de banca de dados de texto
syntax match Vernacular   /^\\\(tx\|mb\).*$/ fold
syntax match National     /^\\\(tn\|gn\).*$/ fold
syntax match Nota         /^\\nt.*$/ fold
syntax match Fonte        /^\\so.*$/ fold
syntax match Outros       /^\\\(id\|tx\|mb\|tn\|gn\|nt\|so\)\@!.*$/ fold

let b:current_syntax = "sft"
