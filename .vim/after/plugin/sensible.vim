if exists("g:loaded_sensible") && g:loaded_sensible == 1
  " So that in nvim pressing <esc>b don't give me 'â'
  set ttimeoutlen=1
  set timeoutlen=500
endif
