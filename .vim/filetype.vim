if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect
  autocmd BufNewFile,BufRead *.sft     setfiletype sft
  autocmd BufNewFile,BufRead *.sfd     setfiletype sfd
  autocmd BufNewFile,BufRead *.trs     setfiletype trs
  autocmd BufNewFile,BufRead *.pdfmeta setfiletype pdfmeta
augroup END
