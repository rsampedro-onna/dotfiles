" The plugin vim-sensible activates filetype indentation (filetype indent on),
" but there are some annoying bugs and glitches in the vim-markdown's implementation
" of filetype indentation for .mkd files (~/.vim/bundle/vim-markdown/indent/mkd.vim).
" The line below deactivates it.

let b:did_indent = 1
