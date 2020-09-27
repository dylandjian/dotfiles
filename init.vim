" Disable vim polyglot for some languages, current problems between TS and JSX
let g:polyglot_disabled = ['css', 'tsx', 'jsx']

" Plugin
call plug#begin()
"
" Status bar
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Commenting
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-commentary'

" Motion
Plug 'justinmk/vim-sneak'

" Copy paste
Plug 'roxma/vim-tmux-clipboard'

" Git
Plug 'tpope/vim-fugitive'

" Files
" Plug 'scrooloose/nerdtree'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" Colors
Plug 'flazz/vim-colorschemes'
Plug 'morhetz/gruvbox'

" CSS
Plug 'hail2u/vim-css3-syntax'

" JS / TS / React
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'sheerun/vim-polyglot'

" Syntax
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-surround'

" Language Server
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Coc installs its own plugins using yarn

" Git
Plug 'mhinz/vim-signify'

call plug#end()

" Leader shortcut
:let mapleader=","									" leader is coma

" Copy paste vim to macOS clipboard
set clipboard=unnamed

" Ripgrep
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)
set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow
nnoremap \ :Rg<space>
nnoremap <C-T> :Files
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>s :BLines

" Hack because Ctrl-i = tab = completion
nnoremap <C-l> <C-i>

" -- Coc settings --

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=1

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
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
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)


" -- Other settings --

" Navigation with vim sneak
let g:sneak#label = 1

" Watch file changes on filesystem
set autoread

" Coc global extensions
let g:coc_global_extensions = ["coc-json", "coc-prettier", "coc-tsserver", "coc-yaml",
                             \ "coc-tslint"]

" Colors
colorscheme gruvbox
" Fix SignColumn grey color
hi clear SignColumn

" Status bar settings
let g:airline_theme='gruvbox'
let g:airline#extensions#tabline#enabled = 1

" -- Keybinds --
:nnoremap <C-z> :bp<CR>
:nnoremap <C-x> :bn<CR>
:nnoremap <C-c> :bd<CR>
:nnoremap <Leader><space> :noh<CR>

" Explorer
:nnoremap <Leader>r :CocCommand explorer <CR>
autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif

" Files
nnoremap <C-p> :Files<CR>
nnoremap <Leader>o :ccl<CR>

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Set filetypes as typescript.tsx
" autocmd BufNewFile,BufRead *.ts,*js,*.tsx,*.jsx set filetype=typescript
" autocmd BufNewFile,BufRead *.ts,*.js set filetype=typescript
let g:jsx_ext_required = 0

let g:coc_disable_startup_warning = 1

" Setup
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Spaces and tabs
:set tabstop=2
:set softtabstop=2
:set shiftwidth=2
:set expandtab

" UI Config
:set relativenumber
:set mouse=a
:set number

" Live replace
:set inccommand=split

" Go params
let g:go_highlight_structs = 1
let g:go_highlight_methods = 1
let g:go_highlight_functions = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')

