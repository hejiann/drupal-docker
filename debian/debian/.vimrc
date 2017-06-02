syntax on

set number
set hlsearch
filetype indent on
set fileencodings=ucs-bom,utf-8,gbk,default,latin1
set encoding=utf-8
colorscheme desert

set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent

" pathogen
execute pathogen#infect()

" NERDTree
map <C-n> :NERDTreeToggle<CR>
" Tagbar
nmap <F8> :TagbarToggle<CR>

" Airline
set laststatus=2
"let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>+ <Plug>AirlineSelectNextTab

