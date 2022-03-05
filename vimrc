if !has('nvim')
	set ttymouse=sgr
endif

set termencoding=utf-8

set showcmd
set incsearch
set number
set relativenumber

set tabstop=4
set softtabstop=0 noexpandtab
set shiftwidth=4

autocmd InsertEnter * silent !echo -ne "\e[5 q"
autocmd InsertLeave * silent !echo -ne "\e[1 q"
