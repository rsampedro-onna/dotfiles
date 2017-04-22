" For the new commands that I created
syn match  texRefZone		'\\cite\%(alt\|gen\|author\|year\|field\)' nextgroup=texRefOption,texCite
syn match  texRefZone		'\\fullcite' nextgroup=texRefOption,texCite

set iskeyword+=-,:     " To stop the spell checker from considering dashes as part of a word
" set iskeyword+=32    " to allow spaces in the thesaurus file (~/.vim/mthes10.zip)
                       " (the one in vimrc got overwritten all the time)
                       " I've commented this out because it blocks me from being
                       " able to use ^x(^n|^p) after (^n|^p) in order to get the
                       " next word separated by a space

                       " TIP: if you write your \label's as
                       " \label{fig:something}, then if you type in \ref{fig:
                       " and press <C-n> you will automatically cycle through
                       " all the figure labels. Very useful!

" I should activate the lines below if I find problems with spell checking.
" [reference](http://stackoverflow.com/questions/23353009/vim-spellcheck-not-always-working-in-tex-file-check-region-in-vim)
" syn sync maxlines=200
" syn sync minlines=50
