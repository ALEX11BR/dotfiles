set mouse=a

set showcmd
set incsearch
set number
set relativenumber

set tabstop=4
set softtabstop=0 noexpandtab
set shiftwidth=4

set list
set listchars=tab:>=,trail:.

autocmd InsertEnter * silent !echo -ne "\e[5 q"
autocmd InsertLeave * silent !echo -ne "\e[1 q"
