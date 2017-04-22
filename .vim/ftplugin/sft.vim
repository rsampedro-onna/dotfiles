" Carrega as definições de cores dos arquivos Toolbox
setlocal foldmethod=syntax

" Apaga colunas de análise interlinear
nnoremap <Plug>DeleteColumn dWjdWjdW2k
\:call repeat#set("\<Plug>DeleteColumn")<CR>
nmap dc <Plug>DeleteColumn

" faz a análise interlinear
" TODO add any other characters I need to escape to line 16 (systemlist...)
function! s:interlinearize()
  let l:current_line_nr = line('.')
  let l:current_line = getline(l:current_line_nr) 
  if match(l:current_line , '^\\tx') != -1
    let l:current_line = substitute(l:current_line , '^\\...' , '' , '')
    let l:interlinearized = systemlist("interlinear-tool.pl " . escape(l:current_line, '*') )
    let l:interlinearized[0] = '\mb ' . l:interlinearized[0]
    let l:interlinearized[1] = '\gn ' . l:interlinearized[1]
    let l:interlinearized[2] = '\ps ' . l:interlinearized[2]
    call append(l:current_line_nr , l:interlinearized)
  elseif match(l:current_line , '^\\mb') != -1
    let l:current_line_cl = col('.')
    let l:word = matchstr(l:current_line , '\S\+', l:current_line_cl - 1 )
    let l:interlinearized = systemlist("interlinear-tool.pl " . l:word)
    normal dWjdWjdW2k
    execute "normal i" . l:interlinearized[0] . "\<esc>`[j"
    execute "normal i" . l:interlinearized[1] . "\<esc>`[j"
    execute "normal i" . l:interlinearized[2] . "\<esc>`[j"
    normal `[kk
  endif
endfunction

nnoremap gi :call <SID>interlinearize()<CR>
