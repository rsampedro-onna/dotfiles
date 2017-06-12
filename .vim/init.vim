" vim:set foldmethod=marker foldtext=foldtext() :

scriptencoding utf-8
set encoding=utf-8

" Plugin-related stuff {{{1

filetype plugin on

" Pathogen initialization {{{2

runtime bundle/vim-pathogen/autoload/pathogen.vim

" Disabled plugins {{{3
"
" to selectively disable a list of plugins
let g:pathogen_disabled = [] " initializes the variable

" If I use repmo, I can't map 'j' to 'gj', 'k' to 'gk' and so on.
let g:pathogen_disabled += ['repmo.vim']

" There are so many markdown plugins! Which one should I use?
" I'll keep them all, in case I change my mind later.
let g:pathogen_disabled += ['vim-pandoc', 'vim-pandoc-after']
let g:pathogen_disabled += ['vim-pandoc-syntax']
"" these had seemed like they had been abandoned, but then there was some
"" activity on github
let g:pathogen_disabled += ['tpope-markdown']
"" tim pope's variant doesn't understand item continuations
" let g:pathogen_disabled += ['plasticboy-markdown']

" I'm using vimtex as my LaTeX plugin
let g:pathogen_disabled += ['TeX-9']

" Nvim already includes the same defaults as sensible.vim
if has('nvim')
  let g:pathogen_disabled += ['vim-sensible']
endif

" Autocompletion 
if !has('nvim')
  let g:pathogen_disabled += ['deoplete.nvim']
  let g:pathogen_disabled += ['deoplete-jedi']
else
  let g:pathogen_disabled += ['jedi.vim']
endif
let g:pathogen_disabled += ['nvim-completion-manager']
"
" OR
"
" let g:pathogen_disabled += ['deoplete.nvim']
" let g:pathogen_disabled += ['deoplete-jedi']
" if has('nvim') && index(g:pathogen_disabled, 'nvim-completion-manager') == -1
"   let g:pathogen_disabled += ['vim-hug-neovim-rpc']
" endif

" I always forget how this creates problems and end up reenabling it after a
" while. The last thing problem I found out about is that when I yank with a .
" command, it doesn't go into the stack. I thought of reporting a bug on
" github, but was discouraged by the fact that there are unanswered bug
" reports from 2015.
let g:pathogen_disabled += ['vim-yankstack']

" copied from https://github.com/neovim/neovim/pull/6597
if exists('+winhighlight')
  let g:pathogen_disabled += ['vim-diminactive']
  function! s:configure_winhighlights(...)
    let winnr = a:0 ? a:1 : winnr()
    let force = a:0 > 1 ? a:2 : 0
    if !force
      if a:0
        let ft = getbufvar(winbufnr(winnr), '&filetype')
        let bt = getbufvar(winbufnr(winnr), '&buftype')
      else
        let ft = &filetype
        let bt = &buftype
      endif
      " Check white/blacklist.
      if index(['dirvish'], ft) == -1
            \ && (index(['nofile', 'nowrite', 'acwrite', 'quickfix', 'help'], bt) != -1
            \     || index(['startify'], ft) != -1)
        call setwinvar(winnr, '&winhighlight', 'Normal:MyNormalWin,NormalNC:MyNormalWin')
        return
      endif
    endif
    call setwinvar(winnr, '&winhighlight', 'Normal:MyNormalWin,NormalNC:MyInactiveWin')
  endfunction
  augroup inactive_win
    au!
    au ColorScheme * hi MyInactiveWin ctermbg=18 | hi link MyNormalWin Normal
    au FileType,WinNew * call s:configure_winhighlights()
    au FocusGained * hi link MyNormalWin Normal
    au FocusLost * hi link MyNormalWin MyInactiveWin
  augroup END
endif
"}}}3

" to load the plugins in the 'bundles' folder
execute pathogen#infect()

" I think I only need to run the line below after I install new plugins
" But instead of directly running the line below I can run :Helptags
" execute pathogen#helptags()

"}}}2
" Gitgutter {{{2
if index(g:pathogen_disabled, 'vim-gitgutter') == -1
  let g:gitgutter_enabled = 0 "disable it by default
  nnoremap <silent> cog :GitGutterToggle<CR>
endif

"}}}2
" vimtex {{{2

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
let g:tex_flavor='latex'

" This variable makes vim's builtin syntax checking for tex files faster, by
" being lazy.
let g:tex_fast="bcmpr"

let g:tex_comment_nospell=1

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

if index(g:pathogen_disabled, 'vimtex') == -1
  let g:vimtex_view_method = 'zathura'
  " let g:vimtex_view_zathura_options = '-s'
  let g:vimtex_imaps_enabled = 0
  let g:vimtex_quickfix_open_on_warning = 0
  let g:vimtex_fold_enabled = 1
  let g:vimtex_fold_manual = 1
  if has('nvim')
    let g:vimtex_compiler_progname = 'nvr'
  endif
endif

"}}}2
" Fugitive {{{2

" delete buffers instead of hiding them
augroup DeleteInFugitive
  autocmd!
  autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END

"}}}2
" Netrw {{{2

"let g:netrw_liststyle=3   " Use tree-mode as default view
let g:netrw_preview=1      " preview window shown in a vertically split
let g:netrw_winsize=20     " To only use 20% of the screen when previewing a file
let g:netrw_altfile = 1    " <Ctrl-^> should go to the last file, not to netrw.

"}}}2
" Mundo {{{2

nmap <silent> <F4> :MundoToggle<CR>

"}}}2
" Goyo {{{2

if index(g:pathogen_disabled, 'goyo.vim') == -1
  nnoremap <Leader><Space> :Goyo<CR>
  let g:goyo_margin_top=0
  let g:goyo_margin_bottom=0

  function! s:goyo_before()
    if !has('gui_running')
      silent !tmux-next set status off
      " silent !tmux-next resize-pane -Z
      silent !tmux-next list-panes -F '\#F' | grep -q Z || tmux-next resize-pane -Z
    endif
    " set noshowcmd
    set noshowmode
    set showbreak=
  endfunction

  function! s:goyo_after()
    if !has('gui_running')
      silent !tmux-next set status on
      " silent !tmux-next resize-pane -Z
      silent !tmux-next list-panes -F '\#F' | grep -q Z && tmux-next resize-pane -Z
    endif
    " set showcmd
    set showmode
    set showbreak=··
  endfunction

  let g:goyo_callbacks = [function('s:goyo_before'), function('s:goyo_after')]

  if index(g:pathogen_disabled, 'limelight.vim') == -1
    augroup UserLimelight
      autocmd!
      autocmd User GoyoEnter Limelight
      autocmd User GoyoLeave Limelight!
    augroup END
  endif
endif

"}}}2
" vim-easy-align {{{2

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
nmap <Leader>a <Plug>(EasyAlign)

" Disable foldmethod during alignment
let g:easy_align_bypass_fold = 1

let g:easy_align_delimiters = {
\ 'x': {
\     'pattern': '\\\@<! \+\(\\nogloss\({[^}]\+}\|\S\+\) \+\|@ \+\|+ \+\)* *',
\     'left_margin': 0,
\     'right_margin': 0
\   },
\ '"': {
\     'pattern': '",',
\     'left_margin': 0,
\     'right_margin': 1,
\     'stick_to_left': 1
\   },
\ '-': {
\     'pattern': '[ =-]',
\     'left_margin': 0,
\     'right_margin': 0
\   }
\ }

"}}}2
" vim-yankstack {{{2

if index(g:pathogen_disabled, 'vim-yankstack') == -1
  let g:yankstack_map_keys = 0
  nmap <c-p> <Plug>yankstack_substitute_older_paste
  nmap <c-n> <Plug>yankstack_substitute_newer_paste
  call yankstack#setup()
endif

" creates more generic behavior for Y
nmap Y y$

"}}}2
" vim-pandoc-syntax {{{2

if index(g:pathogen_disabled, 'vim-pandoc-syntax') == -1
  let g:pandoc#syntax#conceal#blacklist = ['ellipses']
  let g:pandoc#syntax#conceal#backslash = 1
  let g:pandoc#syntax#codeblocks#embeds#langs = ['bash=sh']
  let g:pandoc#syntax#roman_lists = 1
  """ não funciona com sft, a não ser com um vim limpo. não entendi porque, mas
  """ agora preciso fazer outras coisas
endif

"}}}2
" vim-pandoc {{{2

if index(g:pathogen_disabled, 'vim-pandoc') == -1
  let g:pandoc#spell#enabled = 0
  " let g:pandoc#folding#fdc = 0
  let g:pandoc#biblio#bibs = ['/home/rafael/Dropbox/linguistica/references/lingbib.bib']
  let g:pandoc#keyboard#display_motions = 0
endif

"}}}2
" vim-pandoc-after {{{2
if index(g:pathogen_disabled, 'vim-pandoc-after') == -1
  let g:pandoc#after#modules#enabled = ['ultisnips', 'tablemode']
endif

"}}}2
" plasticboy-markdown {{{2
if index(g:pathogen_disabled, 'plasticboy-markdown') == -1
  let g:vim_markdown_folding_style_pythonic = 1
  let g:vim_markdown_conceal = 1
  augroup UserMarkdown
    autocmd!
    autocmd FileType markdown setlocal commentstring=<!--%s-->
    autocmd FileType markdown setlocal conceallevel=2
    autocmd FileType markdown setlocal concealcursor=
  augroup END
  " The mapping plasticboy-markdown gives me doesn't allow me to open pdfs
  map <Plug>Dont_OpenUrlUnderCursor <Plug>Markdown_OpenUrlUnderCursor
  " And the default mapping for the function below overwrites `ge`
  map <Plug>Dont_EditUrlUnderCursor <Plug>Markdown_EditUrlUnderCursor

  if index(g:pathogen_disabled, 'vim-pandoc') != -1
    let g:pandoc#filetypes#pandoc_markdown = 0
    " If both 'plasticboy-markdown' and 'vim-pandoc' are enabled, separate 'pandoc'
    " and 'markdown' filetypes
  endif
endif

"}}}2
" repmo.vim {{{2

if index(g:pathogen_disabled, 'repmo.vim') == -1
  """ This is the default
  " let g:repmo_mapmotions = "j|k h|l <C-E>|<C-Y> zh|zl"
  let g:repmo_mapmotions = "j|k h|l \{|\} zj|zk"
endif

"}}}2
" open-pdf {{{2

if index(g:pathogen_disabled, 'open-pdf.vim') == -1
  " activate plugin
  let g:pdf_convert_on_edit = 1
  let g:pdf_convert_on_read = 1
endif

"}}}2
" vim-speak {{{2

if index(g:pathogen_disabled, 'vim-speak') == -1
  let g:speech_speed = 200
endif

"}}}2
" vim-flagship {{{2

if index(g:pathogen_disabled, 'vim-flagship') == -1
 set laststatus=2
 set showtabline=2
 set guioptions-=e
endif

"}}}2
" unicode.vim {{{2
if index(g:pathogen_disabled, 'unicode.vim') == -1
  nmap <f3> <Plug>(MakeDigraph)
endif

"}}}2
" vim-orgmode {{{2
if index(g:pathogen_disabled, 'vim-orgmode') == -1
  let g:org_agenda_files = ['~/Dropbox/Notas/*.org']
endif

"}}}2
" fzf.vim {{{2
set rtp+=~/.fzf

if index(g:pathogen_disabled, 'fzf.vim') == -1
  imap <c-x><c-f> <plug>(fzf-complete-path)
  nnoremap <BS>o :FHistory<CR>
  nnoremap <BS>u :FBuffers<CR>
  nnoremap <BS>/ :FBLines<CR>
  nnoremap <BS>f :FFiles<CR>
  let g:fzf_command_prefix='F'
endif
"}}}2
" vim-table-mode {{{2
if index(g:pathogen_disabled, 'vim-table-mode') == -1
  let g:table_mode_corner_corner = '|'
endif
"}}}2
" TeX-9 {{{2
if index(g:pathogen_disabled, 'TeX-9') == -1
endif
"}}}2
" vim-textobj-quote {{{2
if index(g:pathogen_disabled, 'vim-textobj-quote') == -1
  augroup TextobjQuote
    autocmd!
    autocmd FileType markdown call textobj#quote#init({'educate': 0})
    autocmd FileType text call textobj#quote#init({'educate': 0})
  augroup END
endif
"}}}2
" vim-slash {{{2
if index(g:pathogen_disabled, 'vim-slash') == -1
  " function! s:flash()
  "   set cursorline!
  "   redraw
  "   sleep 20m
  "   set cursorline!
  "   return ''
  " endfunction

  " noremap <expr> <plug>(slash-after) <sid>flash()
endif
"}}}2
" jedi-vim {{{2
if index(g:pathogen_disabled, 'jedi-vim') == -1
  let g:jedi#completions_command = ''
  " Use <c-x><c-o> whenever you need omnicompletion
endif
"}}}2
" deoplete.nvim {{{2
if index(g:pathogen_disabled, 'deoplete.nvim') == -1
  let g:deoplete#enable_at_startup = 1
  " With auto-complete enabled, I can't do continuation completion with <c-x><c-n>
  let g:deoplete#disable_auto_complete = 1
  inoremap <expr> <c-o> deoplete#mappings#manual_complete()
endif
"}}}2
" vim-highlightedyank {{{2
if index(g:pathogen_disabled, 'vim-highlightedyank') == -1
  let g:highlightedyank_highlight_duration = 100
  if !has('nvim')
    map y <Plug>(highlightedyank)
  endif
endif
"}}}2
" vim-sneak {{{2
if index(g:pathogen_disabled, 'vim-sneak') == -1
  
  " 2-character Sneak (default)
  nmap s <Plug>Sneak_s
  nmap S <Plug>Sneak_S
  " visual-mode
  xmap s <Plug>Sneak_s
  xmap S <Plug>Sneak_S
  " operator-pending-mode
  omap z <Plug>Sneak_s
  omap Z <Plug>Sneak_S

  " 1-character enhanced 'f'
  nmap f <Plug>Sneak_f
  nmap F <Plug>Sneak_F
  " visual-mode
  xmap f <Plug>Sneak_f
  xmap F <Plug>Sneak_F
  " operator-pending-mode
  omap f <Plug>Sneak_f
  omap F <Plug>Sneak_F

  " 1-character enhanced 't'
  nmap t <Plug>Sneak_t
  nmap T <Plug>Sneak_T
  " visual-mode
  xmap t <Plug>Sneak_t
  xmap T <Plug>Sneak_T
  " operator-pending-mode
  omap t <Plug>Sneak_t
  omap T <Plug>Sneak_T
endif
"}}}2
" vim-diminactive {{{2
if index(g:pathogen_disabled, 'vim-diminactive') == -1
  let g:diminactive_enable_focus = 1
  " let g:diminactive_use_syntax = 1
endif
"}}}2
" comfortable-motion {{{2
if index(g:pathogen_disabled, 'comfortable-motion') == -1
  let g:comfortable_motion_no_default_key_mappings = 1
  nnoremap <silent> <C-d> :call comfortable_motion#flick(100)<CR>
  nnoremap <silent> <C-u> :call comfortable_motion#flick(-100)<CR>
  nnoremap <silent> <C-f> :call comfortable_motion#flick(125)<CR>
  nnoremap <silent> <C-b> :call comfortable_motion#flick(-125)<CR>
endif
"}}}2
" vim-LanguageTool {{{2
if index(g:pathogen_disabled, 'vim-LanguageTool') == -1
  let g:languagetool_jar='$HOME/.vim/LanguageTool-3.6/languagetool-commandline.jar'
endif
"}}}2
" thesaurus_query.vim {{{2
if index(g:pathogen_disabled, 'thesaurus_query.vim') == -1
  
endif
"}}}2
" Ultisnips {{{2

if index(g:pathogen_disabled, 'ultisnips') == -1
  let g:UltiSnipsExpandTrigger="<tab>"
  let g:UltiSnipsJumpForwardTrigger="<tab>"
  let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
  let g:UltiSnipsListSnippets="<c-tab>"
  " let g:UltiSnipsListSnippets="<Plug>DontMapUltiSnipsListSnippets"

  " in order to make ctrl+tab work
  if &term =~# '\vscreen|tmux|rxvt'
    inoremap [27;5;9~ <Esc>:call UltiSnips#ListSnippets()<CR>
  endif
endif

"}}}2
" nvim-completion-manager {{{2
if index(g:pathogen_disabled, 'nvim-completion-manager') == -1
  set shortmess+=c

  " inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  " inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  " inoremap <expr> <buffer> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

  " let g:UltiSnipsExpandTrigger        = "<Plug>(ultisnips_expand)"
  " let g:UltiSnipsJumpForwardTrigger   = "<Plug>(ultisnips_expand)"
  " let g:UltiSnipsJumpBackwardTrigger  = "<Plug>(ultisnips_backward)"
  " let g:UltiSnipsListSnippets         = "<Plug>(ultisnips_list)"
  let g:UltiSnipsRemoveSelectModeMappings = 0 

  " vnoremap <expr> <Plug>(ultisnip_expand_or_jump_result) g:ulti_expand_or_jump_res?'':"\<Tab>"
  " inoremap <expr> <Plug>(ultisnip_expand_or_jump_result) g:ulti_expand_or_jump_res?'':"\<Tab>"
  " imap <silent> <expr> <Tab> (pumvisible() ? "\<C-n>" : "\<C-r>=UltiSnips#ExpandSnippetOrJump()\<cr>\<Plug>(ultisnip_expand_or_jump_result)")
  " xmap <Tab> <Plug>(ultisnips_expand)
  " smap <Tab> <Plug>(ultisnips_expand)

  " vnoremap <expr> <Plug>(ultisnips_backwards_result) g:ulti_jump_backwards_res?'':"\<S-Tab>"
  " inoremap <expr> <Plug>(ultisnips_backwards_result) g:ulti_jump_backwards_res?'':"\<S-Tab>"
  " imap <silent> <expr> <S-Tab> (pumvisible() ? "\<C-p>" : "\<C-r>=UltiSnips#JumpBackwards()\<cr>\<Plug>(ultisnips_backwards_result)")
  " xmap <S-Tab> <Plug>(ultisnips_backward)
  " smap <S-Tab> <Plug>(ultisnips_backward)

  inoremap <silent> <C-Tab> <c-r>=cm#sources#ultisnips#trigger_or_popup("<Tab>")<cr>
  if &term =~# '\vscreen|tmux|rxvt'
    inoremap [27;5;9~ <c-r>=cm#sources#ultisnips#trigger_or_popup("<Tab>")<cr>
  endif

  imap <c-g> <Plug>(cm_force_refresh)
endif
"}}}2
" vim-surround {{{2
if index(g:pathogen_disabled, 'vim-surround') == -1
  let g:surround_no_insert_mappings = 1
endif
"}}}2
"}}}1
" Looks {{{1

" Invisible characters
set listchars=tab:▸\ ,eol:¬,nbsp:·

" Tab treatment
set expandtab     " Expand tabs into spaces
set tabstop=2     " Set width of tab character
set softtabstop=2 " Fine-tunes the amount of white-space to be inserted
set shiftwidth=2  " The amount of white-space to insert or remove using the indendation commands in normal mode

" Set line numbers
set nonumber

" Wrapping
set wrap         " Set wrapping on
set linebreak    " Set wrap to not break words
set breakindent  " Indent after wrapping
set showbreak=·· " How to begin soft-wrapped line continuations

" "====[ Make the 81st column stand out ]====================
" highlight ColorColumn ctermbg=magenta
" call matchadd('ColorColumn', '\%81v', 100)

" colorscheme
if has('gui_running')
  colorscheme solarized
else
  if has('mac')
    colorscheme solarized
  else
    if filereadable(expand("~/.vimrc_background"))
      let base16colorspace=256
      source ~/.vimrc_background
    endif
    " let s:background = system('xrdb -query | grep ''URxvt.background''')
    " if s:background =~ "#212121"
    "   colorscheme hybrid
    " elseif s:background =~ "#2B2B2B"
    "   colorscheme zenburn
    " elseif s:background =~ "#fdf6e3" || s:background =~ "#002b36"
    "   colorscheme solarized
    "   set background=dark
    " elseif s:background =~ "#3a3a3a"
    "   colorscheme seoul256
    " elseif s:background =~ "#282828"
    "   colorscheme gruvbox
    "   set background=dark
    " else
    "   colorscheme zenburn
    " endif
  endif
endif

" not to mark the line where the cursor is
set nocursorline

" Text encoding
set fileencodings=utf-8

" to set vimdiff in `wrap' mode
augroup VimDiffWrapMode
  autocmd!
  autocmd FilterWritePre * if &diff | setlocal wrap< | endif
augroup END

" To have vimdiff ignore whitespace while normal vim doesn't
set diffopt+=iwhite

" search options
set hlsearch   " highlight all matches of a search

" XML options {{{2

let g:xml_syntax_folding=1
augroup vimRC
  autocmd!
  au FileType xml setlocal foldmethod=syntax
augroup END

"}}}2
"" Status line {{{2
"" [Source](https://github.com/airblade/dotvim/blob/dd5d7737e39aad5e24c1a4a8c0d115ff2ae7b488/vimrc#L49-L91)

"function! WindowNumber()
"  return tabpagewinnr(tabpagenr())
"endfunction

"function! TrailingSpaceWarning()
"  if !exists("b:statline_trailing_space_warning")
"    let lineno = search('\s$', 'nw')
"    if lineno != 0
"      let b:statline_trailing_space_warning = '[trailing:'.lineno.']'
"    else
"      let b:statline_trailing_space_warning = ''
"    endif
"  endif
"  return b:statline_trailing_space_warning
"endfunction

"" recalculate when idle, and after saving
"augroup statline_trail
"  autocmd!
"  autocmd cursorhold,bufwritepost * unlet! b:statline_trailing_space_warning
"augroup END

"set statusline=
"set statusline+=%m%r                          " modified, readonly
"set statusline+=\ 
"set statusline+=%{expand('%:h')}/             " relative path to file's directory
"set statusline+=%t                            " file name
"set statusline+=\ 
"set statusline+=\ 
"set statusline+=%<                            " truncate here if needed
"set statusline+=%L\ lines                     " number of lines
"set statusline+=\ 
"set statusline+=\ 
"set statusline+=%{TrailingSpaceWarning()}     " trailing whitespace

"set statusline+=%=                            " switch to RHS

"set statusline+=col:%-3.c                     " column
"set statusline+=\ 
"set statusline+=\ 
"set statusline+=buf:%-3n                      " buffer number
"set statusline+=\ 
"set statusline+=\ 
"set statusline+=win:%-3.3{WindowNumber()}     " window number
""}}}2
""}}}1
" Personal mappings {{{1

if has('nvim')
  tnoremap <C-G> <C-\><C-N>
  tnoremap <C-H> <C-\><C-N><C-W>h
  tnoremap <C-J> <C-\><C-N><C-W>j
  tnoremap <C-K> <C-\><C-N><C-W>k
  tnoremap <C-L> <C-\><C-N><C-W>l
endif

" If the current buffer has never been saved, it will have no name,
" call the file browser to save it, otherwise just save it.
nnoremap <silent> <c-s> :if expand("%") == ""<CR>browse confirm w<CR>else<CR>confirm update<CR>endif<CR>

" And to be able to do it during insert mode
inoremap <silent> <c-s> <c-o>:if expand("%") == ""<CR>browse confirm w<CR>else<CR>confirm update<CR>endif<CR>

" ^C/^V to copy to/paste from +
" inoremap <C-V> <ESC>"+gpa
" vnoremap <C-V> <ESC>"+gpa
" vnoremap <C-C> "+y
" nnoremap <silent> csc :call setreg('+',getreg('"'))<CR>

" open pdf with PDF-Edit
nnoremap <silent> g<c-x> :silent !gtk-launch PDF-XChange-Editor.desktop <cfile> &> /dev/null <cr>:redraw!<cr>

" why go to to the marked line without going to the marked column as well?
nnoremap ' `

" for autoformatting without two spaces after periods
set nojoinspaces

" useful remap. %% is expanded into %:h
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:p').'/' : '%%'

" remaps C-p and C-n as <up> and <down> when on command mode
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" loads my digraphs
so $HOME/.vim/vimdigraphs

nnoremap Q @@
vnoremap Q @@

" " To clear the screen of highlights
" " I have no idea why I need <c-u> in the normal mapping, but it is
" " harmless and the mapping somehow doesn't work without it.
" " Note to self: I'm using :normal because otherwise I can't be in
" " insert mode, and press <c-o>ç to clear highlights.
" nnoremap <silent> ç :normal!:nohlsearch
" vnoremap <silent> ç :normal!:nohlsearchgv

" Trying to make my life easier when on Dvorak
command! J ls
nnoremap <F2> :ls<CR>:bu

" Always trying to make [ and ] easier to type
nmap cp [
nmap cu ]

" Copy current working directory into + register
nnoremap <C-W><C-Y> :let @+ = '<C-R>=getcwd()<CR>'<CR>

" More window mappings
nnoremap <C-W>< :tabmove-1<CR>
nnoremap <C-W>> :tabmove+1<CR>
nnoremap <C-W><< :tabmove-2<CR>
nnoremap <C-W>>> :tabmove+2<CR>
nnoremap <C-W><<< :tabmove-3<CR>
nnoremap <C-W>>>> :tabmove+3<CR>
" nnoremap <C-W>\| <C-W>v
" nnoremap <C-W>" <C-W>v
" nnoremap <C-W>- <C-W>s

" `J` that doesn't change cursor position
nnoremap <silent> J :let p=getpos('.')<BAR>join<BAR>call setpos('.',p)<CR>

" A logical mapping for . in visual mode
vnoremap . :normal .<CR>

" Easier access to the black hole
nnoremap _ "_
vnoremap _ "_

" " `l` is kind of hard to reach sometimes
" map <space> l

" " Making omnicompletion easier
" inoremap <c-o> <c-x><c-o>
" " I decided to use <c-o> for deoplete

" make insert mode undo more granular {{{2

inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
inoremap <cr>  <c-g>u<cr>

"}}}2

"" =====[ Highlight matches when jumping to next ]===== {{{2

"" This rewires n and N to do the highlighing...
"nnoremap <silent> n   n:call HLNext(0.25)<cr>
"nnoremap <silent> N   N:call HLNext(0.25)<cr>

"" just highlight the match in red...
"function! HLNext (blinktime)
"    let [bufnum, lnum, col, off] = getpos('.')
"    let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
"    let target_pat = '\m\%#\%('.@/.'\m\)'
"    let ring = matchadd('IncSearch', target_pat, 101)
"    redraw
"    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
"    call matchdelete(ring)
"    redraw
"endfunction
""}}}2
" Dealing with line breaks in a saner way {{{2
let s:swapped = 0

function! SwapMappings(...)
  if a:0 == 0 | let l:silent = 'not' | else | let l:silent = 'yes' | endif
  let l:pairs = { 'j' : 'gj' , 'k' : 'gk' , '$' : 'g$' , '^' : 'g^' , '0' : 'g0' }
  if s:swapped == 0
    for key in keys(l:pairs)
      exec 'nnoremap ' . key . ' ' . l:pairs[key]
      exec 'vnoremap ' . key . ' ' . l:pairs[key]
      exec 'nnoremap ' . l:pairs[key] . ' ' . key
      exec 'vnoremap ' . l:pairs[key] . ' ' . key
    endfor
    let s:swapped = 1
    if l:silent == 'not' | echom 'Screen lines' | endif
  elseif s:swapped == 1
    for key in keys(l:pairs)
      exec 'nunmap ' . key
      exec 'vunmap ' . key
      exec 'nunmap ' . l:pairs[key]
      exec 'vunmap ' . l:pairs[key]
    endfor
    let s:swapped = 0
    if l:silent == 'not' | echom 'Logical lines' | endif
  endif
endfunction

call SwapMappings('silent')
nnoremap <silent> cok :call SwapMappings()<CR>

"}}}2
" Make <c-y> and <c-e> copy word-wise {{{2
inoremap <expr> <c-y> pumvisible() ? "\<c-y>" : matchstr(getline(line('.')-1), '\%' . virtcol('.') . 'v\%(\k\+\\|.\)')
inoremap <expr> <c-e> pumvisible() ? "\<c-e>" : matchstr(getline(line('.')+1), '\%' . virtcol('.') . 'v\%(\k\+\\|.\)')

"}}}2
" Adds numbers, show result and copy it into register @" (mapping '+'){{{2

function! s:add_numbers()
  " Adds the numbers in the selected lines
  " Newlines are substituted by +
  silent :normal! gvy
  let l:calculation = substitute(getreg('"'),'[^0-9\n.+-]','','g')
  let l:calculation = substitute(l:calculation,'\n','+','g')
  let l:calculation = substitute(l:calculation,'+$','','')
  execute 'let @" = string('.l:calculation.')'
  echom l:calculation.'='.@"
endfunction

vnoremap <silent> + :<C-U>call <SID>add_numbers()<CR>

"}}}2
" Goes to tab by number and shortcut to go to last tab {{{2
for number in range(1,9)
  exec "nnoremap g".number." ".number."gt"
endfor

let g:lasttab = 1
augroup WhenLeavingTab
  autocmd!
  autocmd TabLeave * let g:lasttab = tabpagenr()
augroup END
nnoremap g\ :exe "tabn ".g:lasttab<CR>

"}}}2
" Spelling {{{2
function! s:toggle_language()
  if &spelllang == "en_us"
    set spelllang=pt
    echo "Português"
  else
    set spelllang=en_us
    echo "English"
  endif
endfunction

nnoremap <silent> cop :call <SID>toggle_language()<CR>

highlight clear SpellBad
highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
set spelllang=en_us
set iskeyword+=-     " To stop the spell checker from considering dashes as part of a word
set thesaurus+=~/.vim/mthesaur.txt
" Thesaurus function {{{3
function! s:thesaurus()
  let s:saved_ut = &ut
  if &ut > 200 | let &ut = 200 | endif
  augroup ThesaurusAuGroup
    autocmd CursorHold,CursorHoldI <buffer>
          \ let &ut = s:saved_ut |
          \ set iskeyword-=32 |
          \ autocmd! ThesaurusAuGroup
  augroup END
  return ":set iskeyword+=32\<cr>vaWovea\<c-x>\<c-t>"
endfunction

nnoremap <expr> <leader>t <SID>thesaurus()
"}}}3

"}}}2
" Toggles automatic line break {{{2
function! s:ToggleAutomaticBreaking()
  if &l:formatoptions =~ 'a'
    if &l:wrapmargin == 10
      setlocal wrapmargin=0
    endif
    setlocal formatoptions-=a
    echom 'Autoformat off'
  else
    setlocal formatoptions+=a
    if &l:textwidth == 0 && &l:wrapmargin == 0
      setlocal wrapmargin=10
    endif
    echom 'Autoformat on'
  endif
endfunction

nnoremap <silent> coa :call <SID>ToggleAutomaticBreaking()<CR>

"}}}2
" Jumps to paragraph edges {{{2
nnoremap <expr> g} len(getline(line('.')+1)) > 0 ? '}-' : '}+'
nnoremap <expr> g{ len(getline(line('.')-1)) > 0 ? '{+' : '{-'

"}}}2
" Prettifies XML{{{2

function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction

command! PrettyXML call DoPrettyXML()
"}}}2
" Creates quickfix from gloss location output from `~/bin/catalog-glosses.pl` {{{2

function! s:create_quickfix()
  call setqflist([],'r')
  let l:file_name = getline(1)
  let l:current_line = getline(getpos('.')[1])
  let [ l:message, l:line_numbers ] = split(l:current_line, ":")
  let l:array_line_numbers = split(l:line_numbers)
  for l:line_number in l:array_line_numbers
    let l:location = { 'filename' : l:file_name , 'text' : l:message, 'lnum' : l:line_number }
    call setqflist( [ l:location ] , 'a' )
  endfor
  copen
endfunction

nnoremap <leader>g :call <SID>create_quickfix()<CR>
"}}}2
""}}}1
" Terminal tweaks {{{1

" in order to make ctrl+arrow work in the terminal
if &term =~# '\vscreen|tmux'
  noremap  [1;5C <C-Right>
  cnoremap [1;5C <C-Right>
  inoremap [1;5C <C-Right>
  noremap  [1;5D <C-Left>
  cnoremap [1;5D <C-Left>
  inoremap [1;5D <C-Left>
elseif &term =~# "rxvt"
  noremap  Oc <C-Right>
  cnoremap Oc <C-Right>
  inoremap Oc <C-Right>
  noremap  Od <C-Left>
  cnoremap Od <C-Left>
  inoremap Od <C-Left>
endif

" " Rename windows in screen and tmux with the name of the file being edited
" if &term =~# 'screen\|tmux'
"   function! ScrWinTitle()
"     let &titlestring=expand("%:t")
"     if &titlestring == ""
"       let &titlestring="VIM"
"     elseif &titlestring =~ "mutt-rafael"
"       let &titlestring="/tmp/mutt"
"     endif
"     set t_ts=k
"     set t_fs=\
"     set title
"   endfunction

"   augroup scrWinTitle
"     autocmd!
"     autocmd BufEnter * call ScrWinTitle()
"   augroup END
" endif

"Change cursor color and shape conditionally on the environment {{{2

" Inside nvim
if has('nvim')
  "" one day I'll be running a terminal with true colors...
  " set termguicolors
  set guicursor=n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175
else
  " Change the cursor's color under xterm and rxvt
  " (doesn't work under terminal multiplexers or under nvim)
  if &term =~# "^xterm-color\\|^rxvt"
    " use a red color in insert mode
    let &t_SI = "\<Esc>]12;red\x7"
    " use gray cursor otherwise
    let &t_EI = "\<Esc>]12;gray\x7"
    silent !echo -ne "\033]12;red\007"
    " reset cursor when vim exits
    augroup ReturnsToOriginalCursorColor
      autocmd!
      autocmd VimLeave * silent !echo -ne "\033]12;gray\007"
    augroup END
  endif

  " Also change the cursor shape
  " (doesn't work under terminal multiplexers or under nvim)
  if &term =~# "^xterm-color\\|^rxvt"
    " blinking bar
    let &t_SI .= "\<Esc>[5 q"
    " solid block
    let &t_EI .= "\<Esc>[2 q"
  endif

  " To change color and shape of the cursor under tmux
  function! TmuxCursor()
    " Change color
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]12;gray\x7\<Esc>\\"
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]12;red\x7\<Esc>\\"
    " Change shape
    let &t_EI .= "\<Esc>Ptmux;\<Esc>\<Esc>[2 q\<Esc>\\"
    let &t_SI .= "\<Esc>Ptmux;\<Esc>\<Esc>[5 q\<Esc>\\"
    augroup cursorColor
      autocmd!
      autocmd VimEnter * silent !echo -ne "\033Ptmux;\033\033]12;gray\007\033\\"
      autocmd VimLeave * silent !echo -ne "\033Ptmux;\033\033]12;gray\007\033\\"
    augroup END
  endfunction

  if $TMUX != "" && $XAUTHORITY != "" && !has('nvim')
    call TmuxCursor()
  endif
endif

"}}}2
"}}}1
" Other settings {{{1

" So that I can include file-specific commands as the first line of a file
set modeline

" To be allowed to leave modified buffers without first saving the changes
set hidden

" Mouse preferences
set mouse=a
set mousefocus
set mousehide
if !has('nvim')
  set ttymouse=xterm
endif

" keep persistent undo history
set undofile

" Tell vim to remember certain things when we exit
"   '100   : marks will be remembered for up to 10 previously edited files
"   "100   : will save up to 100 lines for each register
"   :10000 : up to 10000 lines of command-line history will be remembered
"   %      : saves and restores the buffer list
"   n...   : where to save the viminfo files
if !has('nvim')
  set viminfo='1000,\"1000,:100000,%,n~/.viminfo
endif

" for cmdline completion to work like in the shell
set wildmode=longest,full

" If a file can't be opened as utf-8, then try to open it as latin1
set fileencodings=utf8,latin1

" Apparently enables faster redraws
set ttyfast

" so . also repeats yank commands
set cpoptions+=y

" So I can move my cursor anywhere in the screen
set virtualedit=block,insert

" Changes each window's directory to the directory of the buffer open in it
" set autochdir
augroup ChangeDir
  autocmd!
  autocmd BufEnter * silent execute expand('%:p') !~# '\v(^/tmp/|^$|^fugitive|\.git/|/thesaurus: )' ? 'lcd %:p:h' : ''
augroup END

" To allow hiding dotfiles by default. `gh` toggles hiding
let g:netrw_hide = 1

" {char1}<BS>{char2} == <C-K>{char1}{char2}
" set digraph

" More seamless interaction with the system clipboard
set clipboard=unnamedplus

" To force me to notice when I've searched a file all the way to the end
set nowrapscan

" To show incomplete commands in the status line
set showcmd

" So I can combine up to three characters
set maxcombine=3

" Don't want 'longest' anymore
set completeopt=menuone,preview

" This is cool, but only works in neovim
if exists('&inccommand')
  set inccommand=split
endif

" Imports binary formats (pdf, doc, etc) into text {{{2

let g:zipPlugin_ext = "*.zip,*.jar,*.xpi,*.ja,*.war,*.ear,*.celzip,*.oxt,*.kmz,*.wsz,*.xap,*.docm,*.dotx,*.dotm,*.potx,*.potm,*.ppsx,*.ppsm,*.pptx,*.pptm,*.ppam,*.sldx,*.thmx,*.xlam,*.xlsx,*.xlsm,*.xlsb,*.xltx,*.xltm,*.xlam,*.crtx,*.vdw,*.glox,*.gcsx,*.gqsx"

augroup importBinaryToText
  autocmd!

  "" Read-only .doc
  autocmd BufReadPre *.doc silent set ro
  " autocmd BufReadPost *.doc silent %!antiword "%"
  autocmd BufReadPost *.doc silent %!pandoc --columns=80 -f doc -t markdown "%"

  "" Read-only .docx
  autocmd BufReadPre *.docx silent set ro
  autocmd BufReadPost *.docx silent %!pandoc --columns=80 -f docx -t markdown "%"

  "" Read-only odt
  autocmd BufReadPre *.odt silent set ro
  " autocmd BufReadPost *.odt,*.odp silent %!odt2txt "%"
  autocmd BufReadPost *.doc silent %!pandoc --columns=80 -f odt -t markdown "%"

  "" Read-only pdf
  autocmd BufReadPre *.pdf silent set ro
  autocmd BufReadPost *.pdf silent %!pdftotext -nopgbrk -layout -q -eol unix "%" -
  autocmd BufReadPost *.pdf silent set ft=

  "" Read-only rtf through unrtf
  " autocmd BufReadPre *.rtf silent set ro
  " autocmd BufReadPost *.rtf silent %!unrtf --text
augroup END

"}}}2
" Restores cursor position and folding {{{2

if has("folding")
  function! UnfoldCur()
    if !&foldenable
      return
    endif
    let cl = line(".")
    if cl <= 1
      return
    endif
    let cf  = foldlevel(cl)
    let uf  = foldlevel(cl - 1)
    let min = (cf > uf ? uf : cf)
    if min
      execute "normal!" min . "zo"
      return 1
    endif
  endfunction
endif

function! ResCur()
  if line("'\"") > 1 && line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  if has("folding")
    autocmd BufWinEnter * if ResCur() | call UnfoldCur() | endif
  else
    autocmd BufWinEnter * call ResCur()
  endif
augroup END
"}}}2
" Resizes splits whenever Vim itself is resized {{{2
augroup vimRC
  autocmd!
  autocmd VimResized * wincmd =
augroup END
"}}}2
"}}}1
