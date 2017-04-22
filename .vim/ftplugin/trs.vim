" this is for playing files in transcriber format

if exists("b:did_ftplugin") 
  finish 
endif

let b:did_ftplugin = 1

function! PlayTrs()
  execute "silent !playtrs.sh " . bufname("%") . " " . line(".") . " &>/dev/null &"
  redraw!
endfunction

nnoremap <buffer> <leader>r :call PlayTrs()<cr>
