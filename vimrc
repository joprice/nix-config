syntax on

" coc.vim - see https://github.com/neoclide/coc.nvim#example-vim-configuration
set cmdheight=2
set updatetime=300
set shortmess+=c

" Always show the signcolumn
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

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
" https://vim.fandom.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE

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

let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'nix': ['nixpkgs-fmt'],
\   'cpp': ['clang-format'],
\   'ocaml': ['ocamlformat'],
\   'purescript': ['purty'],
\   'rust': ['rustfmt'],
\}
let g:ale_linters = {
\   'cpp': ['clang-check'],
\   'haskell': ['hlint'],
\}

" allow loading folder-specific configs
let file = expand('%:p:h') . "/.vimrc"
if filereadable(file)
  echo "Loading local .vimrc file " . file
  execute "source " . file
endif

let g:psc_ide_log_level = 3

let g:deoplete#enable_at_startup = 1

nnoremap <C-N> :bnext<CR>
nnoremap <C-M> :bprevious<CR>
