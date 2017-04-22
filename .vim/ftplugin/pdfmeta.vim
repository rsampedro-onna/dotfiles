" Carrega as definições de cores dos arquivos de metadata de PDF
setlocal foldmethod=syntax
setlocal foldtext=PDFMetaFoldText()

function! PDFMetaFoldText()
  return getline(v:foldstart + 1)
endfunction
