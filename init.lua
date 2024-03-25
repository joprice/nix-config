vim.cmd([[
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
set timeoutlen=1000 ttimeoutlen=0
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

" overrides auto-detection, which falls back to nroff when the first 10 lines
" don't contain an import
au BufNewFile,BufRead *.mm set filetype=objcpp
"au BufNewFile,BufRead Cakefile set filetype=ruby
au BufNewFile,BufRead *.plist setf xml
au BufNewFile,BufRead *.intentdefinition setf xml
au BufNewFile,BufRead WORKSPACE.bzlmod setf bzl
au BufNewFile,BufRead Pods.WORKSPACE setf bzl
au BufNewFile,BufRead *.entitlements setf xml
autocmd BufNewFile,BufRead *.fs,*.fsx,*.fsi set filetype=fsharp

"nmap <C-s> <Plug>MarkdownPreview
"nmap <M-s> <Plug>MarkdownPreviewStop
"nmap <C-p> <Plug>MarkdownPreviewToggle
"let g:mkdp_auto_start = 1
"let g:mkdp_echo_preview_url = 1

let g:zenburn_high_Contrast=1
"colorscheme zenburn

"set shortmess+=c
set completeopt=menuone,noinsert,noselect

let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
let g:prettier#exec_cmd_async = 1
let g:prettier#quickfix_enabled = 0

"#\   '--compilertool:"~/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0"'
"FSharp.fsiExtraParameters": ["--langversion:preview"]
"let g:fsharp#fsi_extra_parameters = [ '--compilertool:/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0' ]
let g:fsharp#fsi_compiler_tool_locations =
  \ [ '/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0' ]
let g:fsharp#fsiCompilerToolLocations =
  \ [ '/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0' ]
  "--   fsiCompilerToolLocations = "/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0"
let g:fsharp#fsautocomplete_command =
    \ [ 'dotnet',
    \   'fsautocomplete',
    \   '--adaptive-lsp-server-enabled',
    \ ]

if &term =~ "screen"
	  let &t_BE = "\e[?2004h"
	  let &t_BD = "\e[?2004l"
	  exec "set t_PS=\e[200~"
	  exec "set t_PE=\e[201~"
endif

let g:fsharp#lsp_auto_setup = 0

set runtimepath+=/home/josephp/dev/Ionide-vim/
set packpath^=/home/josephp/dev/Ionide-vim/lua/ionide
packloadall!
packadd! ionide
]])

require('nvim-web-devicons').setup()
-- require('Comment').setup()
require('todo-comments').setup()
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
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
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
local ft = require('Comment.ft')
ft.set('reason', ft.get('c'))

require("tokyonight").setup({
  styles = {
    keywords = { italic = false },
    floats = "normal"
  }
})

-- https://github.com/fannheyward/telescope-coc.nvim
require("telescope").setup({
  defaults = {
    layout_strategy = 'vertical'
  },
  extensions = {
    coc = {
      -- theme = 'ivy',
      prefer_locations = true, -- always use Telescope locations to preview definitions/declarations/implementations etc
    }
  },
})
-- require('telescope').load_extension('coc')
require('telescope').load_extension('fzy_native')
require('telescope').load_extension('frecency')
require('telescope').load_extension('z')
-- TODO: get this into vim
-- require("telescope").load_extension('smart_history')
require('telescope').load_extension('media_files')
require('telescope').load_extension('file_browser')

vim.cmd.colorscheme "tokyonight-night"

require 'nvim-treesitter.configs'.setup {
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
}

vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

vim.opt.guifont = "FiraMono Nerd Font Mono:h15"

local builtin = require('telescope.builtin')
local telescope = require('telescope')

-- See https://github.com/nvim-telescope/telescope.nvim#neovim-lsp-pickers
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fm', builtin.marks, {})
vim.keymap.set('n', '<leader>fr', builtin.resume, {})
vim.keymap.set('n', '<leader>fi', builtin.current_buffer_fuzzy_find, {})
-- local coc = telescope.extensions.coc
-- vim.keymap.set('n', '<leader>fo', function() coc.document_symbols {} end, {})
vim.keymap.set('n', '<leader>ft', '<Cmd>TodoTelescope keywords=TODO,FIX<CR>', {})
vim.keymap.set('n', '<leader>fd', builtin.git_status, {})
vim.keymap.set('n', '<leader>fl', builtin.git_branches, {})
vim.keymap.set('n', '<space>a', builtin.diagnostics, {})
vim.keymap.set('n', '<space>f', builtin.buffers, {})

vim.keymap.set("n", "<C-p>", builtin.find_files, {})

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)

require('neodev').setup()

-- see https://github.com/lukas-reineke/lsp-format.nvim/issues/50
local config = {}
for _, v in pairs(vim.fn.getcompletion("", "filetype")) do
  config[v] = { sync = true }
end
require("lsp-format").setup(config)

-- local nlspsettings = require("nlspsettings")
--
-- nlspsettings.setup({
--   config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
--   local_settings_dir = ".nlsp-settings",
--   local_settings_root_markers_fallback = { '.git' },
--   append_default_schemas = true,
--   loader = 'json'
-- })

local lspconfig = require('lspconfig')
--  inlay_hints = { enabled = true }
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


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
  if client.server_capabilities.inlayHintProvider then
    print "has inlay"
    --   vim.lsp.buf.inlay_hint(bufnr, true)
  end
  vim.lsp.codelens.refresh()
end

-- lspconfig.jsonls.setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
-- }
--
local swift_format = {
  formatCommand = [[swift-format]],
  formatStdin = true,
}
local buildifier = {
  formatCommand = [[buildifier -lint=fix]],
  formatStdin = true,
}
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
lspconfig.pyright.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

lspconfig.metals.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

lspconfig.haxe_language_server.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = { "node", "/Users/josephprice/dev/haxe-language-server/bin/server.js" },
  init_options = {
    displayArguments = { 'build.hxml' },
    -- displayArguments = { 'html5.hxml' },
  },

})

lspconfig.nim_langserver.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

lspconfig.gopls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        unusedvariable = true,
        unusedwrite = true,
      }
    }
  }
}

lspconfig.hls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

lspconfig.elmls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

-- lspconfig.java_language_server.setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
-- }

lspconfig.rust_analyzer.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  -- Server-specific settings. See `:help lspconfig-setup`
  settings = {
    ['rust-analyzer'] = {},
  },
}

-- lspconfig.tailwindcss.setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
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
--       includeLanguages = {
--         ocaml = "html"
--       },
--       -- TODO: get project-specific config working so this isn't global
--       -- * https://github.com/neovim/nvim-lspconfig/wiki/Project-local-settings
--       -- examples
--       -- * https://github.com/ecosse3/nvim/blob/01a4feef16d5714abb1e49ee8e047a32e7d8ec4e/lua/lsp/servers/tailwindcss.lua#L45-L53
--       -- * https://github.com/tailwindlabs/tailwindcss/issues/7553
--       -- * https://github.com/tailwindlabs/tailwindcss/discussions/7554
--       -- config schema https://github.com/tailwindlabs/tailwindcss-intellisense/blob/0b83e8d5fb81fe2d75835f38dfe8836e4e332c95/packages/vscode-tailwindcss/package.json#L204
--       experimental = {
--         classRegex = {
--           "~class_\\:\\s*\\(Prop.s\\s+\"([^\"]*)\"",
--         }
--       }
--     }
--   }
-- }
-- lspconfig.flow.setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
-- }
local util = require 'lspconfig.util'

lspconfig.tsserver.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  -- root_dir = util.root_pattern(".git"),
  single_file_support = false,
  root_dir = util.root_pattern('package.json')
}

-- having issues with "buffer is not modifiable" on save
lspconfig.nil_ls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    ['nil'] = {
      formatting = {
        command = { "nixpkgs-fmt" },
      },
    },
  },
}

lspconfig.ocamllsp.setup {
  capabilities = capabilities,
  on_attach = on_attach
}

-- vim.lsp.set_log_level("trace")

-- require 'ionide'.setup {
--   -- require '/home/josephp/dev/Ionide-vim/lua'.setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
--   -- init_options = {
--   --   FSharp = {
--   --     fsiExtraParameters = {
--   --       "--langversion:preview",
--   --       "--compilertool:/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0"
--   --   },
--   --   }
--   -- },
--   settings = {
--       ["FSharp"] = {
--         fsiExtraParameters = {
--           "--langversion:preview",
--           "--compilertool:/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0"
--         },
--         fsiCompilerToolLocations = {
--           "/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0"
--         },
--     }
--   },
--   -- init_options = {
--   --   FSharp = {
--   --     fsiExtraParameters = {
--   --       "--compilertool:/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0"
--   --     },
--   --     FSIExtraParameters = {
--   --       "--compilertool:/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0"
--   --     },
--   --     fsiCompilerToolLocations = {
--   --       "/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0"
--   --     },
--   --     FSICompilerToolLocations = {
--   --       "/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0"
--   --     }
--   --   }
--   -- }
--   -- settings = {
--   --   fsiCompilerToolLocations = "/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0"
--   -- }
-- }

lspconfig.fsautocomplete.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = {
    'dotnet',
    'fsautocomplete',
    '--adaptive-lsp-server-enabled'
  },
  settings = {
    FSharp = {
      Linter = true,
      RecordStubGeneration = true,
      InterfaceStubGeneration = true,
      UnusedOpensAnalyzer = true,
      -- SimplifyNameAnalyzer = true,
      ResolveNamespaces = true,
      EnableReferenceCodeLens = true,
      ExternalAutocomplete = true,
      InlayHints = {
        typeAnnotations = true
      },
      -- FullNameExternalAutocomplete = true,
      keywordsAutocomplete = true,
      UnionCaseStubGeneration = true,
      UnusedDeclarationsAnalyzer = true,
      UnionCaseStubGenerationBody = "failwith \"---\"",
      UseSdkScripts = true,
      -- LineLens = {
      --   enabled = true
      -- }
      --   fsiCompilerToolLocations = {
      --     "/home/josephp/.nuget/packages/fsharp.dependencymanager.paket/7.0.0/lib/netstandard2.0" }
    }
  }
}

lspconfig.purescriptls.setup {
  capabilities = capabilities,
  on_attach = on_attach
}

lspconfig.sourcekit.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = {
    -- "xcrun",
    "xcrun",
    "--toolchain",
    "swift",
    "sourcekit-lsp",
    "--log-level",
    "warning",
    -- "-Xswiftc",
    -- "-sdk",
    -- "-Xswiftc",
    -- "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk",
    -- "-Xswiftc",
    -- "-target",
    -- "-Xswiftc",
    -- "x86_64-apple-ios17.0-simulator",
    "--completion-max-results", "100"
  }
}

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      },
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
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
    "lint", "--use-stdin", "--reporter", "json", "--quiet", get_file_name },
  stream = "stdout",
  ignore_exitcode = true,
  env = nil,
  parser = function(output, bufnr)
    print(output)
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
  swift = { "swiftlint" }
  -- TODO: toggle this conditionally
  -- swift = { "swiftlint", "periphery" },
  -- bzl = { "buildifier" },
  -- go = { "golangcilint" },
}

local util = require "formatter.util"

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    bzl = {
      function()
        return {
          exe = "buildifier",
          -- args = { vim.api.nvim_buf_get_name(0) },
          stdin = false
        }
      end },
    python = {
      function()
        return {
          exe = "black",
          args = { '-' },
          stdin = true,
        }
      end
    },
    purescript = {
      function()
        return {
          exe = "purs-tidy",
          args = { 'format-in-place' },
          stdin = false,
        }
      end
    },
    nim = {
      function()
        return {
          exe = "nimpretty",
          stdin = false,
        }
      end
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
          stdin = true
        }
      end },
    ["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace
    }
  }
}


vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*',
  callback = function()
    require("lint").try_lint()
    vim.cmd('FormatWriteLock')
    -- vim.cmd('FormatLock')
  end,
})


-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[g', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']g', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>d', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

local cmp = require 'cmp'

-- notifications in the bottom right corner
-- require("fidget").setup {}

local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
        -- elseif luasnip.expand_or_locally_jumpable() then
        --   luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
        -- elseif luasnip.locally_jumpable(-1) then
        --   luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    -- { name = 'luasnip' },
  },
}

-- lsp_installer.on_server_ready(function(server)
--   server:setup({
--     on_attach = on_attach
--   })
-- end)
--
-- require("nvim-lightbulb").setup({
--   autocmd = { enabled = true }
-- })
--
-- vim.diagnostic.config({
--   virtual_text = false
-- })
--
-- -- Show line diagnostics automatically in hover window
-- vim.o.updatetime = 250
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
