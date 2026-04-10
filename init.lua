-- require("rest-nvim").setup()
-- require("luarocks").setup({ rocks = { "fzy" } })

vim.g.loaded_netrwPlugin = 0

vim.cmd([[
" set runtimepath += '/home/josephp/dev/Ionide-vim'
" set runtimepath += "/Users/josephprice/.config/home-manager/"
set rtp+=/Users/josephprice/.config/home-manager/

let g:readonly_paths = ['server/QueriesGenerated.fs']
" let g:readonly_paths = g:readonly_paths "+ ['server/QueriesGenerated.fs']
" packadd! Ionide-vim/lua
" set runtimepath += '/home/josephp/dev/Ionide-vim'
set t_BE=
"syntax on

" Debugging language servers:
" :CocCommand workspace.showOutput

" coc.vim - see https://github.com/neoclide/coc.nvim#example-vim-configuration
"set cmdheight=2
"set laststatus=2

" disable vi backwards compatibility
set nocompatible
" disable automatic word wrap
set formatoptions-=t
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

set nobackup
set nowritebackup
"set backupcopy=yes
set backspace=2
set listchars=tab:>\ ,trail:.
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

"autocmd FileType netrw setl bufhidden=delete
set hidden
" make exiting insert mode fast
"set timeoutlen=1000 ttimeoutlen=0
" keep extra lines/columns around cursor to see past while scrolling
set scrolloff=10
set sidescrolloff=5

" set spell
set exrc

"let g:ale_fix_on_save = 1
"let g:ale_fixers = {
"\   '*': ['remove_trailing_lines', 'trim_whitespace'],
"\   'nix': [],
"\   'purescript': ['purty'],
"\   'rust': ['rustfmt'],
"\   'xml': ['xmllint'],
"\   'json': ['jq'],
"\   'ocaml': [],
"\   'swift': [],
"\   'cpp': ['clang-format'],
"\   'objc': [],
"\   'objcpp': [],
"\   'scala': [],
"\}
""\   'nix': ['nixpkgs-fmt'],
"" \   'ocaml': ['ocamlformat'],
"let g:ale_linters = {
"\   'rust': [],
"\   'haskell': [],
"\   'ocaml': [],
"\   'swift': [],
"\   'cpp': [],
"\   'objcpp': [],
"\   'scala': [],
"\}
""\   'swift': ['swift-format'],
"" \   'cpp': ['clang-check'],

"let g:ale_swift_swiftformat_executable = "/Users/josephprice/dev/ocaml-bare-nix/swift-format/.build/x86_64-apple-macosx/debug/swift-format"

" \   'haskell': ['hlint'],

" allow loading folder-specific configs
let file = expand('%:p:h') . "/.vimrc"
if filereadable(file)
  echo "Loading local .vimrc file " . file
  execute "source " . file
endif

let g:psc_ide_log_level = 3
"let g:deoplete#enable_at_startup = 1

nnoremap <C-N> :bnext<CR>
nnoremap <C-M> :bprevious<CR>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

"let g:ctrlp_custom_ignore = {
"  \ 'dir':  '\.git$\|node_modules$\|tmp$\|target$'
"  \ }

let g:gitgutter_diff_base = 'master'
"nmap <leader>dm let g:gitgutter_diff_base = 'master'
"nmap <leader>db let g:gitgutter_diff_base = 'head'
"
" set langmap=ЖФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;:ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

" this layout is a bit different than the default OSX one, e.g. the `ё` key is
" `~`, to retain vim's leader key
" see https://en.wikipedia.org/wiki/JCUKEN
nnoremap <Leader>r :set keymap=russian-jcuken<CR>
nnoremap <Leader>e :set keymap=<CR>
inoremap <Leader>r <ESC>:set keymap=russian-jcuken<CR>a
inoremap <Leader>e <ESC>:set keymap=<CR>a

" attempt to fix paste breaking vim
inoremap <C-V> <C-R>*
inoremap <C-C> <C-V>

" overrides auto-detection, which falls back to nroff when the first 10 lines
" don't contain an import
au BufNewFile,BufRead *.mm set filetype=objcpp
au BufNewFile,BufRead *.env.* set filetype=sh
"au BufNewFile,BufRead Cakefile set filetype=ruby
au BufNewFile,BufRead *.plist setf xml
au BufNewFile,BufRead *.intentdefinition setf xml
au BufNewFile,BufRead WORKSPACE.bzlmod setf bzl
au BufNewFile,BufRead Pods.WORKSPACE setf bzl
au BufNewFile,BufRead *.entitlements setf xml

au BufNewFile,BufRead *.mill setlocal filetype=scala
au BufNewFile,BufRead *.fsl setlocal filetype=fslex syntax=fsharp
au BufNewFile,BufRead *.fsy setlocal filetype=fsyacc syntax=fsharp
"autocmd BufNewFile,BufRead *.fs,*.fsx,*.fsi set filetype=fsharp
autocmd BufNewFile,BufRead *.fsproj         set filetype=fsharp_project syntax=xml

" fastlane
au BufNewFile,BufRead Appfile set ft=ruby
au BufNewFile,BufRead Deliverfile set ft=ruby
au BufNewFile,BufRead Fastfile set ft=ruby
au BufNewFile,BufRead Gymfile set ft=ruby
au BufNewFile,BufRead Matchfile set ft=ruby
au BufNewFile,BufRead Snapfile set ft=ruby
au BufNewFile,BufRead Scanfile set ft=ruby
au BufRead,BufNewFile *.tsp set filetype=typespec

"nmap <C-s> <Plug>MarkdownPreview
"nmap <M-s> <Plug>MarkdownPreviewStop
"nmap <C-p> <Plug>MarkdownPreviewToggle
"let g:mkdp_auto_start = 1
"let g:mkdp_echo_preview_url = 1

let g:zenburn_high_Contrast=1
"colorscheme zenburn

"set shortmess+=c
set completeopt=menuone,noinsert,noselect

"let g:prettier#autoformat = 1
"let g:prettier#autoformat_require_pragma = 0
"let g:prettier#exec_cmd_async = 1
"let g:prettier#quickfix_enabled = 0

"#\   '--compilertool:"~/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0"'
"FSharp.fsiExtraParameters": ["--langversion:preview"]
"let g:fsharp#fsi_extra_parameters = [ '--compilertool:/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0' ]
"let g:fsharp#fsi_compiler_tool_locations =
"  \ [ '/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0' ]
"let g:fsharp#fsiCompilerToolLocations =
"  \ [ '/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0' ]
  "--   fsiCompilerToolLocations = "/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0"
let language = system('dotnet tool list | grep fsautocomplete || true')
if len(language) == 0
let g:fsharp#fsautocomplete_command =
    \ [
    \   'fsautocomplete',
    \   '--adaptive-lsp-server-enabled'
    \ ]
else
let g:fsharp#fsautocomplete_command =
    \ [
    \   'dotnet',
    \   'fsautocomplete',
    \   '--adaptive-lsp-server-enabled'
    \ ]
endif

"let g:fsharp#use_recommended_server_config = 0
" disabling this temporarily since it gives false positives in fable bindings
" see here for defaults https://github.com/ionide/Ionide-vim/blob/00099c3cf53cba28a1d8084ab8d21639c62bd747/autoload/fsharp.vim#L161
" disabling these as they cause flashing while navigating the file
"let g:LanguageClient_useVirtualText = 0
" let g:fsharp#lsp_codelens = 0
let g:fsharp#UnusedDeclarationsAnalyzer = 0
let g:fsharp#AddPrivateAccessModifier = 1
let g:fsharp#SimplifyNameAnalyzer = 0
"let g:fsharp#UnnecessaryParenthesesAnalyzer = 1
" let g:fsharp#EnableReferenceCodeLens = 0
let g:fsharp#linter = 1
let g:fsharp#ExternalAutocomplete = 1
let g:fsharp#EnableAnalyzers = 1
let g:fsharp#lsp_auto_setup = 0
let g:polyglot_disabled = ['markdown', 'fsharp']
"let g:fsharp#AnalyzersPath =
"   \ [
"   \ 'packages/analyzers/G-Research.FSharp.Analyzers/analyzers',
"   \ 'packages/analyzers/Ionide.Analyzers/analyzers',
"   \ ]
"let g:fsharp#AnalyzersPath =
"   \ [
"   \ 'packages/analyzers'
"   \ ]
"'packages/analyzers']
"\ 'packages/analyzers/NpgsqlFSharpAnalyzer'

"let g:fsharp#TooltipMode = "summary"

if &term =~ "screen"
  let &t_BE = "\e[?2004h"
  let &t_BD = "\e[?2004l"
  exec "set t_PS=\e[200~"
  exec "set t_PE=\e[201~"
endif


"set runtimepath+=/home/josephp/dev/Ionide-vim/
"set packpath^=/home/josephp/dev/Ionide-vim/
"set runtimepath+=/home/josephp/dev/rest.nvim
"set packpath^=/home/josephp/dev/rest.nvim
"packloadall!
"packadd! ionide
"packadd! rest-nvim.lua

]])
-- require('rocks')

vim.opt.termguicolors = true

require("nvim-highlight-colors").setup({})

require("nvim-web-devicons").setup()
-- require('Comment').setup()
require("todo-comments").setup()
require("auto-session").setup()

-- Some servers have issues with backup files, see #649
vim.opt.backup = false
vim.opt.writebackup = false

-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
-- delays and poor user experience
vim.opt.updatetime = 300

-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appeared/became resolved
vim.opt.signcolumn = "yes"

local keyset = vim.keymap.set
-- Autocomplete
function _G.check_back_space()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

-- Use Tab for trigger completion with characters ahead and navigate
-- NOTE: There's always a completion item selected by default, you may want to enable
-- no select by setting `"suggest.noselect": true` in your configuration file
-- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
-- other plugins before putting this into your config
--local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
--keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
--keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
--
---- Make <CR> to accept selected completion item or notify coc.nvim to format
---- <C-g>u breaks current undo, please make your own choice
--keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
--
---- Use <c-j> to trigger snippets
--keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
---- Use <c-space> to trigger completion
--keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})
--
---- Use `[g` and `]g` to navigate diagnostics
---- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
--keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
--keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})
--
---- GoTo code navigation
--keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
--keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
--keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
--keyset("n", "gr", "<Plug>(coc-references)", {silent = true})
--
--
---- Use K to show documentation in preview window
--function _G.show_docs()
--    local cw = vim.fn.expand('<cword>')
--    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
--        vim.api.nvim_command('h ' .. cw)
--    elseif vim.api.nvim_eval('coc#rpc#ready()') then
--        vim.fn.CocActionAsync('doHover')
--    else
--        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
--    end
--end
--keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})
--
--
---- Highlight the symbol and its references on a CursorHold event(cursor is idle)
--vim.api.nvim_create_augroup("CocGroup", {})
--vim.api.nvim_create_autocmd("CursorHold", {
--    group = "CocGroup",
--    command = "silent call CocActionAsync('highlight')",
--    desc = "Highlight symbol under cursor on CursorHold"
--})
--
--
---- Symbol renaming
--keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})
--
--
---- Formatting selected code
--keyset("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
--keyset("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
--
--
---- Setup formatexpr specified filetype(s)
--vim.api.nvim_create_autocmd("FileType", {
--    group = "CocGroup",
--    pattern = "typescript,json",
--    command = "setl formatexpr=CocAction('formatSelected')",
--    desc = "Setup formatexpr specified filetype(s)."
--})
--
---- Update signature help on jump placeholder
--vim.api.nvim_create_autocmd("User", {
--    group = "CocGroup",
--    pattern = "CocJumpPlaceholder",
--    command = "call CocActionAsync('showSignatureHelp')",
--    desc = "Update signature help on jump placeholder"
--})
--
---- Apply codeAction to the selected region
---- Example: `<leader>aap` for current paragraph
--local opts = {silent = true, nowait = true}
--keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
--keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
--
---- Remap keys for apply code actions at the cursor position.
--keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
---- Remap keys for apply source code actions for current file.
--keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
---- Apply the most preferred quickfix action on the current line.
--keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)
--
---- Remap keys for apply refactor code actions.
--keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
--keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
--keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
--
---- Run the Code Lens actions on the current line
--keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)
--
--
---- Map function and class text objects
---- NOTE: Requires 'textDocument.documentSymbol' support from the language server
--keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
--keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
--keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
--keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
--keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
--keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
--keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
--keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)
--
--
---- Remap <C-f> and <C-b> to scroll float windows/popups
-----@diagnostic disable-next-line: redefined-local
--local opts = {silent = true, nowait = true, expr = true}
--keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
--keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
--keyset("i", "<C-f>",
--       'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
--keyset("i", "<C-b>",
--       'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
--keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
--keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
--
--
---- Use CTRL-S for selections ranges
---- Requires 'textDocument/selectionRange' support of language server
--keyset("n", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
--keyset("x", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
--
--
---- Add `:Format` command to format current buffer
--vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})
--
---- " Add `:Fold` command to fold current buffer
--vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})
--
---- Add `:OR` command for organize imports of the current buffer
--vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})
--
---- Add (Neo)Vim's native statusline support
---- NOTE: Please see `:h coc-status` for integrations with external plugins that
---- provide custom statusline: lightline.vim, vim-airline
--vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")
--
---- Mappings for CoCList
---- code actions and coc stuff
-----@diagnostic disable-next-line: redefined-local
--local opts = {silent = true, nowait = true}
---- Show all diagnostics
--keyset("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
---- Manage extensions
--keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
---- Show commands
--keyset("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
---- Find symbol of current document
--keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
---- Search workspace symbols
--keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)
---- Do default action for next item
--keyset("n", "<space>j", ":<C-u>CocNext<cr>", opts)
---- Do default action for previous item
--keyset("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
---- Resume latest coc list
--keyset("n", "<space>p", ":<C-u>CocListResume<cr>", opts)
--
--
require("neoconf").setup({})
-- require 'lspconfig'.dartls.setup {}
-- require 'lspconfig'.ruby_lsp.setup {}
-- require 'lspconfig'.dockerls.setup {
--   cmd = { "npx", "docker-langserver", '--stdio' },
-- }

local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")
if not configs.tombi then
	configs.tombi = {
		default_config = {
			cmd = { "tombi", "lsp" },
			filetypes = { "toml" },
			root_dir = { "Cargo.toml", "tombi.toml", "pyproject.toml", ".git" },
		},
	}
end

local util = require("lspconfig.util")
lspconfig.tombi.setup({
	root_dir = util.root_pattern("Cargo.toml"),
})

if not configs.moonbit then
	configs.moonbit = {
		default_config = {
			cmd = { "moonbit-lsp" },
			filetypes = { "moonbit" },
			root_dir = util.root_pattern("moon.mod.json"),
		},
		docs = {
			description = [[
The moonbit language server.
]],
		},
	}
end
lspconfig.moonbit.setup({})

-- if not configs.sqruff then
--   configs.sqruff = {
--     default_config = {
--       cmd = { 'sqruff', 'lsp' },
--       filetypes = { 'sql' },
--       root_dir = { '.sqruff', '.git' },
--     }
--   }
-- end

-- local ft = require('Comment.ft')
-- ft.set('typespec', ft.get('c'))
-- ft.set('fsharp_project', ft.get('xml'))
--
-- pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
-- require('Comment').setup({
--   pre_hook
-- })

-- vim.cmd [[
-- autocmd FileType http :packadd rest-nvim
-- ]]
-- "require("luarocks-nvim").setup()

require("tokyonight").setup({
	styles = {
		keywords = { italic = false },
		floats = "normal",
	},
})

-- https://github.com/fannheyward/telescope-coc.nvim
require("telescope").setup({
	defaults = {
		layout_strategy = "vertical",
	},
	extensions = {
		coc = {
			-- theme = 'ivy',
			prefer_locations = true, -- always use Telescope locations to preview definitions/declarations/implementations etc
		},
	},
})
-- require('telescope').load_extension('coc')
require("telescope").load_extension("fzy_native")
require("telescope").load_extension("frecency")
require("telescope").load_extension("z")
-- TODO: get this into vim
-- require("telescope").load_extension('smart_history')
require("telescope").load_extension("media_files")
require("telescope").load_extension("file_browser")

vim.cmd.colorscheme("tokyonight-night")
-- vim.cmd.colorscheme "kanagawa"
-- vim.cmd.colorscheme "iceberg"
-- vim.cmd.colorscheme "spacevim"
-- vim.cmd.colorscheme "kanagawa-paper"
-- vim.cmd.colorscheme "tokyonight-night"

require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all" (the five listed parsers should always be installed)
	-- ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "ocaml" },
	-- Install parsers synchronously (only applied to `ensure_installed`)
	ensure_installed = {},
	sync_install = false,
	auto_install = false,
	-- List of parsers to ignore installing (or "all")
	ignore_install = { "all" },
	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

	highlight = {
		enable = true,
		-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
		-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
		-- the name of the parser)
		-- list of language that will be disabled
		-- disable = { "c", "rust" },
		-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
		-- disable = function(lang, buf)
		--    local max_filesize = 100 * 1024 -- 100 KB
		--    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
		--    if ok and stats and stats.size > max_filesize then
		--        return true
		--    end
		-- end,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn", -- set to `false` to disable one of the mappings
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
})
-- vim.treesitter.language.register("fsharp", "fsharp")

vim.keymap.set("n", "]t", function()
	require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
	require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

vim.opt.guifont = "FiraMono Nerd Font Mono:h15"

local builtin = require("telescope.builtin")
local telescope = require("telescope")

vim.keymap.set("n", "<space>wc", builtin.commands, {})
vim.keymap.set("n", "<space>we", builtin.lsp_workspace_symbols, {})
vim.keymap.set("n", "<space>ws", builtin.lsp_document_symbols, {})
vim.keymap.set("n", "<space>wt", builtin.treesitter, {})
vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { desc = "Run CodeLens" })
-- See https://github.com/nvim-telescope/telescope.nvim#neovim-lsp-pickers
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<space><space>", builtin.live_grep, {})
vim.keymap.set("n", "<space>fa", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fm", builtin.marks, {})
vim.keymap.set("n", "<leader>fr", builtin.resume, {})
vim.keymap.set("n", "<leader>fi", builtin.current_buffer_fuzzy_find, {})
-- local coc = telescope.extensions.coc
-- vim.keymap.set('n', '<leader>fo', function() coc.document_symbols {} end, {})
vim.keymap.set("n", "<leader>ft", "<Cmd>TodoTelescope keywords=TODO,FIX<CR>", {})
vim.keymap.set("n", "<leader>fd", builtin.git_status, {})
vim.keymap.set("n", "<leader>fl", builtin.git_branches, {})
vim.keymap.set("n", "<space>a", builtin.diagnostics, {})
vim.keymap.set("n", "<space>tt", builtin.lsp_references, {})
-- vim.keymap.set('n', '<space>f', builtin.buffers, {})
vim.keymap.set("n", "<space>rr", builtin.buffers, {})

vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<space>pp", builtin.find_files, {})

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<A-c>", "<Cmd>BufferClose<CR>", opts)
vim.keymap.set("n", "<space>cc", "<Cmd>BufferCloseAllButCurrent<CR>", opts)
-- vim.keymap.set('n', '<space>r', '<Cmd>FlutterHotReload<CR>', opts)

require("neodev").setup()

-- see https://github.com/lukas-reineke/lsp-format.nvim/issues/50
local config = {
	fsharp = { sync = true },
}
for _, v in pairs(vim.fn.getcompletion("", "filetype")) do
	local c = config[v] or {}
	-- print(v)
	-- print(vim.inspect(c))
	config[v] = vim.tbl_extend("force", c, { sync = true, exclude = { "ts_ls" } })
	-- config[v].exclude = { "ts_ls" }
	-- config[v] = { sync = true, exclude = { "ts_ls" } }
end
-- print(vim.inspect(config.fsharp))
require("lsp-format").setup({})

-- local nlspsettings = require("nlspsettings")
--
-- nlspsettings.setup({
--   config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
--   local_settings_dir = ".nlsp-settings",
--   local_settings_root_markers_fallback = { '.git' },
--   append_default_schemas = true,
--   loader = 'json'
-- })
--

local lspconfig = require("lspconfig")
-- inlay_hints = { enabled = true }
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
-- capabilities.offsetEncoding = { "utf-16" }
-- capabilities.offset_encoding = { "utf-16" }
-- capabilities.general.positionEncodings = { "utf-16" }
capabilities = vim.tbl_deep_extend("force", capabilities, {
	offsetEncoding = { "utf-16" },
	general = {
		positionEncodings = { "utf-16" },
	},
})

-- function on_attach(client, bufnr)
--   local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
--   buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
-- end

-- local global_capabilities = vim.lsp.protocol.make_client_capabilities()
-- global_capabilities.textDocument.completion.completionItem.snippetSupport = true

-- lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
-- capabilities = global_capabilities,
-- })

-- lsp_installer.on_server_ready(function(server)
--   server:setup({
--     on_attach = on_attach
--   })
-- end)

local on_attach = function(client, bufnr)
	require("lsp-format").on_attach(client, bufnr)
	-- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	-- if client.server_capabilities.inlayHintProvider then
	-- vim.lsp.inlay_hint.enable(true) -- , { bufnr = bufnr })
	-- if client.server_capabilities.codeLensProvider then
	-- vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
	--   buffer = bufnr,
	--   callback = vim.lsp.codelens.refresh,
	-- })
	-- end
	--   vim.lsp.buf.inlay_hint(bufnr, true)
	-- end
	-- client.server_capabilities.codeLensProvider = false
	-- if client.server_capabilities.codeLensProvider then
	--   print "has lens"
	--   -- vim.lsp.codelens.refresh()
	-- end
end

-- lspconfig.sqls.setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
--   -- NOTE: these don't seem to work - config is global https://github.com/sqls-server/sqls/issues/59
--   -- settings = {
--   --   sqls = {
--   --     connections = {
--   --       {
--   --         alias = 'psql',
--   --         driver = 'postgresql',
--   --         dataSourceName = 'host=127.0.0.1 port=5433 user=postgres password=litterat dbname=postgres sslmode=disable'
--   --       },
--   --     },
--   --   },
--   -- },
-- }
--
-- lspconfig.sqruff.setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
-- }

-- lspconfig.jsonls.setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
-- }
--
-- local swift_format = {
--   formatCommand = [[swift-format]],
--   formatStdin = true,
-- }
-- local buildifier = {
--   formatCommand = [[buildifier -lint=fix]],
--   formatStdin = true,
-- }

-- local prettier = {
--   formatCommand = "npx prettier --stdin-filepath ${INPUT}",
--   formatStdin = true,
-- }

local efm_tools = {
	prettierd = {
		formatCommand = "prettierd '${INPUT}' ${--range-start=charStart} ${--range-end=charEnd}",
		formatStdin = true,
		formatCanRange = true,
	},
	eslint_d = {
		lintSource = "efm/eslint_d",
		lintCommand = 'eslint_d --no-color --format visualstudio --stdin-filename "${INPUT}" --stdin',
		lintIgnoreExitCode = true,
		lintStdin = true,
		lintFormats = {
			"%f(%l,%c): %trror %m",
			"%f(%l,%c): %tarning %m",
		},
		rootMarkers = {
			"eslint.config.js",
			"eslint.config.mjs",
			"eslint.config.cjs",
			"package.json",
		},
	},
}

require("lspconfig").yamlls.setup({})

require("lspconfig").efm.setup({
	init_options = {
		documentFormatting = true,
		documentRangeFormatting = true,
	},
	on_attach = on_attach,
	settings = {
		rootMarkers = { ".git/" },
		languages = {
			javascript = {
				-- efm_tools.eslint_d,
				efm_tools.prettierd,
			},
			typescript = {
				-- efm_tools.eslint_d,
				efm_tools.prettierd,
			},
			typescriptreact = {
				-- efm_tools.eslint_d,
				efm_tools.prettierd,
			},
		},
	},
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.jsx",
	},
})

-- lspconfig.efm.setup {
--   on_attach = on_attach,
--   init_options = { documentFormatting = true },
--   settings = {
--     languages = {
--       bzl = {
--         buildifier
--       },
--       swift = {
--         swift_format
--       }
--     },
--   },
-- }

-- lspconfig.clangd.setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
-- }

-- lspconfig.starlark_rust.setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
-- }
--
-- NOTE:many libs don't have types, so stub errors show up all over the files
lspconfig.pyright.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { "poetry", "run", "pyright-langserver", "--stdio" },
})

-- lspconfig.ltex.setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
--   cmd = { "ltex-ls-plus" }
-- }

lspconfig.tsp_server.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { "npx", "tsp-server", "tsp-server", "--stdio" },
})

-- lspconfig.astro.setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
--   cmd = { "npx", "astro-ls", "--stdio" }
-- }

local util = require("lspconfig.util")
local lspconfigs = require("lspconfig.configs")
-- TODO: narrow down to fable projects
lspconfigs.fable = {
	default_config = {
		cmd = { "/Users/josephprice/dev/fable-lsp/bin/Debug/net8.0/fable-lsp" },
		filetypes = { "fsharp" },
		root_dir = util.root_pattern("fable-project"),
		-- root_dir = util.root_pattern('.config/dotnet-tools.json'),
		single_file_support = false,
	},
}

-- TODO: disabled until this can avoid spinning up multiple instances per project
-- lspconfig.fable.setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
--   -- flags = {
--   --   exit_timeout = 10000
--   -- },
-- }

-- lspconfig.metals.setup {
--   -- message_level = vim.lsp.protocol.MessageType.Debug,
--   root_dir = util.root_pattern('build.mill', 'build.sbt', 'build.sc', 'build.gradle', 'pom.xml', 'build.scala'),
--   -- capabilities = capabilities,
--   capabilities = {
--     workspace = {
--       configuration = false,
--     },
--   },
--   on_init = config.on_init,
--   filetypes = { 'scala' },
--   on_attach = on_attach,
--   inlay_hints = { enabled = true },
--   settings = {
--     automaticImportBuild = 'initial',
--     autoImportBuild = 'initial',
--     showInferredType = true,
--     showImplicitArguments = true,
--     inlayHints = {
--       byNameParameters = { enable = true },
--       closingLabels = { enable = true },
--       hintsInPatternMatch = { enable = true },
--       hintsXRayMode = { enable = true },
--       implicitArguments = { enable = true },
--       implicitConversions = { enable = true },
--       inferredTypes = { enable = true },
--       namedParameters = { enable = true },
--       typeParameters = { enable = true },
--     },
--     metals = {
--       verboseCompilation = true,
--       showImplicitArguments = true,
--       automaticImportBuild = 'initial',
--       autoImportBuild = 'initial',
--       inlayHints = {
--         byNameParameters = { enable = true },
--         closingLabels = { enable = true },
--         hintsInPatternMatch = { enable = true },
--         hintsXRayMode = { enable = true },
--         implicitArguments = { enable = true },
--         implicitConversions = { enable = true },
--         inferredTypes = { enable = true },
--         namedParameters = { enable = true },
--         typeParameters = { enable = true },
--       },
--     }
--   },
--   init_options = {
--     statusBarProvider = 'off',
--     isHttpEnabled = true,
--     compilerOptions = {
--       snippetAutoIndent = false,
--     },
--   }
-- }

-- lspconfig.haxe_language_server.setup({
--   capabilities = capabilities,
--   on_attach = on_attach,
--   cmd = { "node", "/Users/josephprice/dev/haxe-language-server/bin/server.js" },
--   init_options = {
--     displayArguments = { 'build.hxml' },
--     -- displayArguments = { 'html5.hxml' },
--   },
--
-- })

-- local null_ls = require("null-ls")
-- local util = require 'lspconfig.util'
-- null_ls.setup({
--   debug = true,
--   root_dir = util.root_pattern('.config/dotnet-tools.json'),
-- })
-- local helpers = require("null-ls.helpers")

-- local s = "./server/SerializationTests.fs(29,3): (29,4) error FSHARP: A type parameter is missing a constraint 'when 'a: equality' (code 1)roject and references (80 source files) parsed in 119ms"
-- for file in s:gmatch([[(.-)%(.+$]]) do
--  print(file)
-- end

-- local log = require("null-ls.logger")
-- local fable = {
--   method = null_ls.methods.DIAGNOSTICS,
--   filetypes = { "fsharp" },
--   --root_dir = require("null-ls.utils").root_pattern('.config/dotnet-tools.json'),
--   generator = ({
--     -- command = "dotnet",
--     -- args = {
--     --   "fable",
--     --   "watch",
--     --   "server",
--     --   "-o",
--     --   "server/js",
--     --   "-s",
--     --   "-e",
--     --   ".fs.js",
--     --   "server"
--     -- },
--     -- runtime_condition =
--     -- to_stdin = false,
--     -- use_cache = true,
--     -- from_stderr = true,
--     -- format = "line",
--     -- multiple_files = true,
--     fn = function(params)
--       log:trace(string.format("fsharp output: %s", vim.inspect(params)))
--       return {
--         {
--           col = "3",
--           end_col = "4",
--           end_row = "29",
--           filename = "./server/SerializationTests.fs",
--           row = 29,
--           message = "A type parameter is missing a constraint 'when 'a: equality' (code 1)",
--           severity = "error"
--         }
--       }
--     end
--     -- on_output = function(line)
--     --   -- local output = params.output
--     --   log:trace(string.format("fsharp output: %s", line))
--     --   -- if not output then
--     --   --   return done()
--     --   -- end
--     -- end
--     -- on_output = helpers.diagnostics.from_patterns({
--     --   -- ./server/SerializationTests.fs(29,3): (29,4) error FSHARP: A type parameter is missing a constraint 'when 'a: equality' (code 1)roject and references (80 source files) parsed in 119ms
--     --   {
--     --     -- pattern = [[:(%d+):(%d+) [%w-/]+ (.*)]],
--     --     pattern = [[(.-)%((%d+),(%d+)%): %((%d+),(%d+)%) (.+) FSHARP: (.+)$]],
--     --     groups = {
--     --       "filename",
--     --       "line",
--     --       "col",
--     --       "end_line",
--     --       "end_col",
--     --       "message",
--     --       "severity"
--     --     }
--     --   },
--     --   -- {
--     --   --     pattern = [[:(%d+) [%w-/]+ (.*)]],
--     --   --     groups = { "row", "message" },
--     --   -- },
--     -- }),
--     --on_output = helpers.diagnostics.from_patterns({
--     --})
--     -- fn = function(params)
--     --   local diagnostics = {}
--     --   -- sources have access to a params object
--     --   -- containing info about the current file and editor state
--     --   for i, line in ipairs(params.content) do
--     --     local col, end_col = line:find("really")
--     --     if col and end_col then
--     --       -- null-ls fills in undefined positions
--     --       -- and converts source diagnostics into the required format
--     --       table.insert(diagnostics, {
--     --         row = i,
--     --         col = col,
--     --         end_col = end_col + 1,
--     --         source = "no-really",
--     --         message = "Don't use 'really!'",
--     --         severity = vim.diagnostic.severity.WARN,
--     --       })
--     --     end
--     --   end
--     --   return diagnostics
--     -- end,
--   }),
-- }

-- null_ls.register(fable)

-- lspconfig.nim_langserver.setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
-- }

local lspconfigs = require("lspconfig.configs")
-- if not lspconfigs.roc_ls then
--   lspconfigs.roc_ls = {
--     default_config = {
--       cmd = { 'roc_language_server' },
--       filetypes = { 'roc' },
--       root_dir = require('lspconfig.util').find_git_ancestor,
--       single_file_support = true,
--     },
--     docs = {
--       description = [[
--   https://github.com/roc-lang/roc/tree/main/crates/language_server#roc_language_server
--
--   The built-in language server for the Roc programming language.
--   [Installation](https://github.com/roc-lang/roc/tree/main/crates/language_server#installing)
--   ]],
--       default_config = {
--         root_dir = [[util.find_git_ancestor]],
--       },
--     },
--   }
-- end

-- lspconfig.roc_ls.setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
-- }

lspconfig.gopls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				unusedvariable = true,
				unusedwrite = true,
			},
		},
	},
})

-- lspconfig.hls.setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
-- }

-- lspconfig.elmls.setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
-- }

-- lspconfig.java_language_server.setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
-- }

-- vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
--   callback = function()
--     vim.lsp.codelens.refresh()
--   end,
-- })

vim.diagnostic.config({
	update_in_insert = true,
})

lspconfig.bacon_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	init_options = {
		updateOnSave = true,
		updateOnSaveWaitMillis = 500,
		runBaconInBackground = false,
		synchronizeAllOpenFilesWaitMillis = 1000,
	},
	-- settings = { runBaconInBackground = true },
	root_markers = { "Cargo.toml" },
	root_dir = lspconfig.util.root_pattern("Cargo.lock"),
})

lspconfig.rust_analyzer.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	root_dir = lspconfig.util.root_pattern("rust-toolchain.toml", "Cargo.toml"),
	-- Server-specific settings. See `:help lspconfig-setup`
	-- cmd = {
	--   "/Users/josephprice/Downloads/rust-analyzer-aarch64-apple-darwin"
	-- },
	settings = {
		["rust-analyzer"] = {
			-- codeLens = {
			--   enable = true,
			-- },
			-- completion = {
			--   fullFunctionSignatures = {
			--     enable = true
			--   }
			-- },
			-- hover = {
			--   actions = {
			--     references = {
			--       enable = true
			--     }
			--   }
			-- },
			-- lens = {
			--   enable = true,
			--   references = {
			--     adt = {
			--       enable = true
			--     }
			--   }
			-- },
			-- inlayHints = {
			--   bindingModeHints = {
			--     enable = true
			--   }
			-- },
			diagnostics = {
				enable = false,
				disabled = { "inactive-code" },
				styleLints = {
					enable = true,
				},
			},
			-- server = {
			--   path = "/Users/josephprice/Downloads/rust-analyzer-aarch64-apple-darwin"
			-- },
			-- assist = {
			--   preferSelf = true
			-- },
			-- procMacro = {
			--   enable = true
			-- },
			-- -- see https://github.com/rust-lang/rust-analyzer/blob/fc18d263aa95f7d6de8174bd4c6663dfe865e6d5/docs/user/generated_config.adoc#L172
			-- cargo = {
			--   -- features = {
			--   --   "diesel/postgres"
			--   -- },
			--   -- targetDir = true,
			--   buildScripts = { enable = true }
			-- },
			checkOnSave = {
				enable = false,
			},
			-- check = {
			--   -- this is quite slow
			--   command = "clippy"
			-- }
			-- diagnostics = {
			--   enable = false;
			-- }
		},
	},
})

lspconfig.tailwindcss.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
--   cmd = {
--     "node_modules/.bin/tailwindcss-language-server"
--   },
--   -- init_options = {
--   --   userLanguages = {
--   --     ocaml = "html"
--   --   }
--   -- },
--   -- filetypes = { "html", "reason",
--   --   -- this is disabled due to high cpu usage
--   --   -- "ocaml" },
--   -- },
--   -- filetypes = { "ocaml", "html", "reason" },
--   -- TODO: extend defaults somehow
--   -- filetypes = vim.tbl_extend(lspconfig.tailwindcss.default_config, { "ocaml" }),
--   settings = {
--     tailwindCSS = {
--       lint = {
--         cssConflict = "error",
--       },
--       -- colorDecorators = true,
--       -- includeLanguages = {
--       --   ocaml = "html"
--       -- },
--       -- TODO: get project-specific config working so this isn't global
--       -- * https://github.com/neovim/nvim-lspconfig/wiki/Project-local-settings
--       -- examples
--       -- * https://github.com/ecosse3/nvim/blob/01a4feef16d5714abb1e49ee8e047a32e7d8ec4e/lua/lsp/servers/tailwindcss.lua#L45-L53
--       -- * https://github.com/tailwindlabs/tailwindcss/issues/7553
--       -- * https://github.com/tailwindlabs/tailwindcss/discussions/7554
--       -- config schema https://github.com/tailwindlabs/tailwindcss-intellisense/blob/0b83e8d5fb81fe2d75835f38dfe8836e4e332c95/packages/vscode-tailwindcss/package.json#L204
--       -- experimental = {
--       --   classRegex = {
--       --     "~class_\\:\\s*\\(Prop.s\\s+\"([^\"]*)\"",
--       --   }
--       -- }
--     }
--   }
-- }

local util = require("lspconfig.util")

if os.getenv("ESLINT_ENABLE") then
	lspconfig.eslint.setup({
		settings = {
			workingDirectories = { mode = "auto" },
			options = {
				cache = true,
			},
		},
		flags = {
			allow_incremental_sync = false,
			debounce_text_changes = 800,
		},
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				command = "EslintFixAll",
			})
			on_attach(client, bufnr)
		end,
	})
end

--
lspconfig.ts_ls.setup({
	capabilities = capabilities,
	-- on_attach = lspconfig.ts_ls.on_attach,
	-- root_dir = util.root_pattern(".git"),
	single_file_support = false,
	-- root_markers = { 'pnpm-workspace.yaml', 'package.json' },
	root_dir = util.root_pattern("pnpm-workspace.yaml", "package.json"),
	-- cmd_env = {
	-- TSS_LOG = "-level verbose -file /tmp/tsserver.log -logToFile true",
	--   -- NODE_OPTIONS = "--max-old-space-size=4096",
	-- }
})

-- having issues with "buffer is not modifiable" on save
-- lspconfig.nil_ls.setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
--   settings = {
--     ['nil'] = {
--       formatting = {
--         command = { "nixpkgs-fmt" },
--       },
--     },
--   },
-- }

-- lspconfig.ocamllsp.setup {
--   capabilities = capabilities,
--   on_attach = on_attach
-- }

lspconfig.mdx_analyzer.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { "npx", "mdx-language-server", "--stdio" },
})

-- vim.lsp.set_log_level("trace")

require("ionide").setup({
	-- require '/home/josephp/dev/Ionide-vim/lua'.setup {
	capabilities = capabilities,
	on_attach = on_attach,
	-- root_dir = util.root_pattern('global.json')
	root_dir = util.root_pattern(".config/dotnet-tools.json", "*.sln"),
	settings = {
		FSharp = {
			-- EnableReferenceCodeLens = false,
			-- UnusedDeclarationsAnalyzer = false,
			-- unusedDeclarationsAnalyzer = false,
			-- lineLens = { enabled = "replaceCodeLens", prefix = '' },
			codeLenses = {
				references = {
					enabled = false,
				},
				signature = {
					enabled = false,
				},
			},
			fsac = { gc = { useDatas = true } },
		},
	},
	-- init_options = {
	--   UnusedDeclarationsAnalyzerExclusions = {
	--     ".*/bun/App.fs"
	--   },
	--   -- FSharp = {
	--   --   UnusedDeclarationsAnalyzerExclusions = {
	--   --     ".*/bun/App.fs"
	--   --   }
	--   -- }
	-- }
	-- --     fsiExtraParameters = {
	-- --       "--langversion:preview",
	-- --       "--compilertool:/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0"
	-- --   },
	-- --   }
	-- -- },
	-- settings = {
	--     ["FSharp"] = {
	--       fsiExtraParameters = {
	--         "--langversion:preview",
	--         "--compilertool:/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0"
	--       },
	--       fsiCompilerToolLocations = {
	--         "/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0"
	--       },
	--   }
	-- },
	-- init_options = {
	--   FSharp = {
	--     fsiExtraParameters = {
	--       "--compilertool:/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0"
	--     },
	--     FSIExtraParameters = {
	--       "--compilertool:/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0"
	--     },
	--     fsiCompilerToolLocations = {
	--       "/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0"
	--     },
	--     FSICompilerToolLocations = {
	--       "/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0"
	--     }
	--   }
	-- }
	-- settings = {
	--   fsiCompilerToolLocations = "/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0"
	-- }
})

-- https://github.com/fsharp/FsAutoComplete/blob/4bc676cc1e8659d9338d31d82d6244bcfcc55cc4/src/FsAutoComplete/LspHelpers.fs#L636
--
-- lspconfig.fsautocomplete.setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
--   cmd = {
--     -- TODO: test for either
--     -- 'dotnet',
--     'fsautocomplete',
--     '--adaptive-lsp-server-enabled'
--   },
--   -- cmd = {
--   --   'dotnet',
--   --   'fsautocomplete',
--   --   '--adaptive-lsp-server-enabled'
--   -- },
--   settings = {
--     FSharp = {
--       ExcludeProjectDirectories = {
--         ".git",
--         "paket-files",
--         "packages"
--       },
--       Linter = true,
--       RecordStubGeneration = true,
--       InterfaceStubGeneration = true,
--       UnusedOpensAnalyzer = true,
--       -- SimplifyNameAnalyzer = true,
--       ResolveNamespaces = true,
--       EnableReferenceCodeLens = true,
--       ExternalAutocomplete = true,
--       InlayHints = {
--         typeAnnotations = true
--       },
--       -- FullNameExternalAutocomplete = true,
--       keywordsAutocomplete = true,
--       UnionCaseStubGeneration = true,
--       UnusedDeclarationsAnalyzer = true,
--       UnionCaseStubGenerationBody = "failwith \"---\"",
--       UseSdkScripts = true,
--       -- LineLens = {
--       --   enabled = true
--       -- }
--       --   fsiCompilerToolLocations = {
--       --     "/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0" }
--     }
--   }
-- }

-- lspconfig.purescriptls.setup {
--   capabilities = capabilities,
--   on_attach = on_attach
-- }

lspconfig.just.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig.sourcekit.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = {
		-- "xcrun",
		"xcrun",
		"--toolchain",
		"swift",
		"sourcekit-lsp",
		-- "--log-level",
		-- "warning",
		-- "-Xswiftc",
		-- "-sdk",
		-- "-Xswiftc",
		-- "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk",
		-- "-Xswiftc",
		-- "-target",
		-- "-Xswiftc",
		-- "x86_64-apple-ios17.0-simulator",
		"--completion-max-results",
		"100",
	},
})

lspconfig.lua_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

local function get_file_name()
	return vim.api.nvim_buf_get_name(0)
end

local swiftlint_severities = {
	-- info = vim.diagnostic.severity.INFO,
	-- refactor = vim.diagnostic.severity.HINT,
	-- convention = vim.diagnostic.severity.WARN,
	Warning = vim.diagnostic.severity.WARN,
	Error = vim.diagnostic.severity.ERROR,
	-- fatal = vim.diagnostic.severity.ERROR,
}

-- See https://github.com/peripheryapp/periphery
require("lint").linters.periphery = {
	cmd = "./scripts/lint.sh",
	stdin = false,
	stream = "stdout",
	ignore_exitcode = false,
	parser = function(output, _)
		local offenses = vim.json.decode(output)
		if vim.tbl_isempty(offenses) then
			return {}
		end
		local diagnostics = {}
		for _, offense in pairs(offenses) do
			table.insert(diagnostics, {
				lnum = offense.line - 1,
				col = offense.column - 1,
				message = offense.reason,
				severity = swiftlint_severities[offense.severity],
				source = "periphery",
			})
		end
		return diagnostics
	end,
}

require("lint").linters.swiftlint = {
	-- cmd = "bazelisk",
	cmd = "swiftlint",
	stdin = true,
	args = {
		-- "run",
		-- "@SwiftLint//:swiftlint", "-c", "opt",
		-- "--",
		"lint",
		"--use-stdin",
		"--reporter",
		"json",
		"--quiet",
		get_file_name,
	},
	stream = "stdout",
	ignore_exitcode = true,
	env = nil,
	parser = function(output, bufnr)
		-- print(output)
		local offenses = vim.json.decode(output)
		if vim.tbl_isempty(offenses) then
			return {}
		end
		local diagnostics = {}
		for _, offense in pairs(offenses) do
			table.insert(diagnostics, {
				lnum = offense.line - 1,
				col = 0,
				message = offense.reason,
				severity = swiftlint_severities[offense.severity],
				source = "swiftlint",
			})
		end
		return diagnostics
	end,
}

require("lint").linters_by_ft = {
	swift = { "swiftlint" },
	-- TODO: toggle this conditionally
	-- swift = { "swiftlint", "periphery" },
	-- bzl = { "buildifier" },
	-- go = { "golangcilint" },
}

local util = require("formatter.util")

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
	logging = true,
	log_level = vim.log.levels.WARN,
	filetype = {
		bzl = {
			function()
				return {
					exe = "buildifier",
					-- args = { vim.api.nvim_buf_get_name(0) },
					stdin = false,
				}
			end,
		},
		python = {
			function()
				return {
					exe = "poetry",
					args = { "run", "black", "-" },
					stdin = true,
				}
			end,
		},
		purescript = {
			function()
				return {
					exe = "purs-tidy",
					args = { "format-in-place" },
					stdin = false,
				}
			end,
		},
		nim = {
			function()
				return {
					exe = "nimpretty",
					stdin = false,
				}
			end,
		},
		objcpp = {
			require("formatter.filetypes.cpp").clangformat,
		},
		cpp = {
			require("formatter.filetypes.cpp").clangformat,
		},
		swift = {
			function()
				return {
					exe = "swift-format",
					args = { vim.api.nvim_buf_get_name(0) },
					stdin = true,
				}
			end,
		},
		-- TODO: this doesn't work when an lsp is modifying the buffer
		-- ["*"] = {
		--   require("formatter.filetypes.any").remove_trailing_whitespace
		-- }
	},
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.mdx",
	command = "set filetype=markdown.mdx",
})
--
-- vim.api.nvim_create_autocmd('BufWritePost', {
--   pattern = '*',
--   callback = function()
--     require("lint").try_lint()
--     vim.cmd('FormatWriteLock')
--     -- vim.cmd('FormatLock')
--   end,
-- })

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

local function highlight_symbol(event)
	local id = vim.tbl_get(event, "data", "client_id")
	local client = id and vim.lsp.get_client_by_id(id)
	if client == nil or not client.supports_method("textDocument/documentHighlight") then
		return
	end

	local group = vim.api.nvim_create_augroup("highlight_symbol", { clear = false })

	vim.api.nvim_clear_autocmds({ buffer = event.buf, group = group })

	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		group = group,
		buffer = event.buf,
		callback = vim.lsp.buf.document_highlight,
	})

	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		group = group,
		buffer = event.buf,
		callback = vim.lsp.buf.clear_references,
	})
end

local format_group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		highlight_symbol(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gu", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)
		--vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<space>d", function()
			vim.lsp.buf.format({ async = false })
		end, opts)

		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local bufnr = ev.buf

		-- if client.supports_method("textDocument/formatting", bufnr) then
		--   vim.api.nvim_create_autocmd("BufWritePre", {
		--     group = format_group,
		--     buffer = bufnr,
		--     callback = function()
		--       vim.lsp.buf.format({ bufnr = bufnr })
		--     end,
		--   })
		-- end
	end,
})

local cmp = require("cmp")

-- notifications in the bottom right corner
require("fidget").setup({})

local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup({})

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete({}),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			-- elseif luasnip.expand_or_locally_jumpable() then
			--   luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			-- elseif luasnip.locally_jumpable(-1) then
			--   luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
		-- { name = 'luasnip' },
	},
})

-- lsp_installer.on_server_ready(function(server)
--   server:setup({
--     on_attach = on_attach
--   })
-- end)
--
require("nvim-lightbulb").setup({
	autocmd = { enabled = true },
})
--
-- vim.diagnostic.config({
--   virtual_text = false
-- })
--
-- -- Show line diagnostics automatically in hover window
-- vim.o.updatetime = 250
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
--

-- function MagmaInitFSharp()
--   vim.cmd [[
--     :MagmaInit .net-fsharp
--     :MagmaEvaluateArgument Microsoft.DotNet.Interactive.Formatting.Formatter.SetPreferredMimeTypesFor(typeof<System.Object>,"text/plain")
--     ]]
-- end
--
-- function MagmaInitPython()
--   vim.cmd [[
--     :MagmaInit python3
--     :MagmaEvaluateArgument a=5
--     ]]
-- end
--
-- vim.cmd [[
-- let g:magma_output_window_borders = v:false
-- :command MagmaInitPython lua MagmaInitPython()
-- :command MagmaInitFSharp lua MagmaInitFSharp()
-- " executes the current file, useful for interactively testing bash scripts
-- :command Exec set splitright | vnew | set filetype=sh | read !sh #
-- ]]

-- vim.cmd [[
-- autocmd FileType fsharp :packadd sniprun
-- ]]
-- require 'sniprun'.setup {
--   selected_interpreters = { 'Fsharp_fifo' },
--   interpreter_options = {
--     FSharp_fifo = {
--       interpreter = "dotnet fsi --nologo"
--     }
--   }
-- }
--
--
-- vim.lsp.set_log_level('debug')

-- vim.lsp.enable('biome')
-- vim.lsp.config("biome", {
--   capabilities = capabilities,
--   on_attach = on_attach,
--   cmd = { "pnpm", "biome", "lsp-proxy" },
-- })

-- disables semantic highlighting added by lsp to debug tree-sitter parsers
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
	vim.api.nvim_set_hl(0, group, {})
end

-- require("dbee").setup()

local function get_query()
	local ts_utils = require("nvim-treesitter.ts_utils")
	local current_node = ts_utils.get_node_at_cursor()

	local last_statement = nil
	while current_node do
		if current_node:type() == "statement" then
			last_statement = current_node
		end
		if current_node:type() == "program" then
			break
		end
		current_node = current_node:parent()
	end

	if not last_statement then
		return ""
	end

	local srow, scol, erow, ecol = vim.treesitter.get_node_range(last_statement)
	local selection = vim.api.nvim_buf_get_text(0, srow, scol, erow, ecol, {})
	return table.concat(selection, "\n")
end

local log = require("plenary.log").new({
	plugin = "my_plugin",
	level = "info",
	use_console = "sync",
	use_file = true,
})

local function make_parent(path)
	-- https://github.com/torch/paths/blob/4ebe222ba12589fb9d86c1d3895d7f509df77b6a/doc/dirfunctions.md?plain=1#L11
	local paths = require("paths")
	paths.mkdir(paths.dirname(path))
end

local function read_file(path)
	make_parent(path)
	local file = io.open(path, "rb") -- r read mode and b binary mode
	if not file then
		return nil
	end
	local content = file:read("*a") -- *a or *all reads the whole file
	file:close()
	return content
end

local function copy_file(src, dest)
	local contents = read_file(src)
	local fp = assert(io.open(dest, "w+b"))
	assert(fp:write(contents))
	fp:close()
end

local function sync_file(src, dest)
	local w = vim.uv.new_fs_event()

	local watch_file
	local function on_change(err, fname, status)
		-- log.info("got change", src, dest)
		copy_file(src, dest)
		vim.api.nvim_command("checktime")
		w:stop()
		watch_file(src)
	end

	watch_file = function(fname)
		-- log.info("watching", fname)
		local fullpath = vim.api.nvim_call_function("fnamemodify", { fname, ":p" })
		assert(w:start(
			fullpath,
			{},
			vim.schedule_wrap(function(...)
				on_change(...)
			end)
		))
	end

	watch_file(src)

	-- vim.api.nvim_command("command! -nargs=1 Watch call luaeval('watch_file(_A)', expand('<args>'))")
end

local watching = {}

vim.api.nvim_create_autocmd({ "FileType" }, {
	desc = "On buffer enter with file type sql",
	group = vim.api.nvim_create_augroup("dbee", { clear = true }),
	pattern = { "sql" },
	callback = function(args)
		vim.keymap.set({ "n" }, "<leader>de", function()
			local dbee = require("dbee").api
			local conn = dbee.core.get_current_connection()
			local file = args.file
			local fileName = file:gsub("/", "_")
			local notes = dbee.ui.editor_namespace_get_notes(conn.id)
			local found = nil
			for _, note in ipairs(notes) do
				-- log.info("note", note.id, note, file, note.name)
				if fileName == note.name then
					found = note
					break
				end
			end
			local id = nil
			local noteFile = nil
			if not found then
				-- log.info("create", conn.id, file)
				id = dbee.ui.editor_namespace_create_note(conn.id, fileName)
				noteFile = dbee.ui.editor_search_note(id).file
			else
				-- log.info("found", found)
				id = found.id
				noteFile = found.file
			end
			if file == noteFile then
				log.error("Attempted to open dbee from scratch file")
				return
			end

			if not watching[file] then
				sync_file(noteFile, file)
				watching[file] = true
			else
				make_parent(noteFile)
				copy_file(file, noteFile)
			end
			dbee.ui.editor_set_current_note(id)
			require("dbee").open()
		end, {
			desc = "[D]bee [e]xecute query under cursor",
			buffer = args.buf,
		})
	end,
})

vim.opt.autoread = true

local function jq_format()
	vim.cmd("%!jq .")
end

-- Map it to a key, e.g. <leader>j
vim.keymap.set("n", "<leader>j", jq_format, { desc = "Format JSON with jq" })
