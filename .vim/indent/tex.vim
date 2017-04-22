" The plugin vim-sensible activates filetype indentation (filetype indent on),
" but there are some annoying bugs and glitches in the default implementation
" of filetype indentation for .tex files (/usr/share/vim/vim74/indent/tex.vim).
" The line below deactivates it.

" The following line completely deactivates the indentation plugin
let b:did_indent = 1

" The following was supposed to solve the problem while keeping the
" indentation plugin active, but it didn't work
" let g:tex_indent_brace = 0
