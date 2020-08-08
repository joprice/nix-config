syntax on
" disable vi backwards compatibility
set nocompatible
set encoding=utf-8
set autoread
set tabstop=2     " number of visual spaces per TAB
set softtabstop=2 " number of spaces in tab when editing
set shiftwidth=2
set autoindent
set expandtab     " tabs are spaces
set number        " show line numbers
set showcmd       " show command in bottom bar
set cursorline    " highlight current line
set wildmode=longest,list,full " show autocomplete
set wildmenu " visual autocomplete for commands
set wildchar=<Tab>
set ttyfast

set lazyredraw " redraw only when we necessary
" searching
set ignorecase
set smartcase
set incsearch " search as characters are typed
set hlsearch " highlight search matches
set showmatch           " highlight matching braces

set nowritebackup
set backspace=2
set listchars=tab:>\ ,trail:.
set termguicolors

"autocmd FileType netrw setl bufhidden=delete
set hidden
" make exiting insert mode fast
set timeoutlen=1000 ttimeoutlen=0
" keep extra lines/columns around cursor to see past while scrolling
set scrolloff=2
set sidescrolloff=5

set spell
set exrc

let g:zenburn_high_Contrast=1
colorscheme zenburn

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'nix': ['nixpkgs-fmt'],
\   'cpp': ['clang-format'],
\}
let g:ale_linters = {
\   'cpp': ['clang-check'],
\}

" allow loading folder-specific configs
let file = expand('%:p:h') . "/.vimrc"
if filereadable(file)
  echo "Loading local .vimrc file " . file
  execute "source " . file
endif
