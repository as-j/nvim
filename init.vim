set encoding=utf-8
set fileencoding=utf-8
set termguicolors

lua require('plugins')
lua require('config')
lua require('feline-setup')

filetype plugin indent on
set nu
colo torte
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set mouse=a
set encoding=utf-8
set list
set ttyfast
set laststatus=2
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
set t_Co=256
set autoindent

command! Qbuffers call setqflist(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), '{"bufnr":v:val}'))

