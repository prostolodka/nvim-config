:set number
:set relativenumber
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a

call plug#begin()
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/preservim/nerdtree'
Plug 'https://github.com/ryanoasis/vim-devicons'
Plug 'https://github.com/tc50cal/vim-terminal'
Plug 'danilo-augusto/vim-afterglow'





call plug#end()

nnoremap <C-n> :NERDTree<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
let mapleader = " "
" Маленький вертикальный терминал
function! OpenSmallTerminal()
    :split
    :vertical resize 60
    :terminal
    startinsert
endfunction

" Маленький горизонтальный терминал  
function! OpenHorizontalSmallTerminal()
   :below split          " горизонтальное разделение
    :resize 10      " высота 10 строк (горизонтальный размер)
    :terminal
    startinsert
endfunction
" Горячие клавиши
nnoremap <leader>tv :call OpenSmallTerminal()<CR>
nnoremap <leader>ty :call OpenHorizontalSmallTerminal()<CR>
nnoremap <leader>tt :terminal<CR>  " полный размер
" Закрыть терминал из нормального режима
nnoremap <leader>cv :bdelete!<CR>
tnoremap <leader>cv <C-\><C-n>:bdelete!<CR> 

" Выход из терминального режима
tnoremap <Esc> <C-\><C-n>
" =============================================
" НАСТРОЙКИ ПЕРЕМЕЩЕНИЯ МЕЖДУ ОКНАМИ
" =============================================

" Простое перемещение между окнами (как в IDE)
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

" Перемещение ИЗ терминального режима
tnoremap <silent> <C-h> <C-\><C-n><C-w>h
tnoremap <silent> <C-j> <C-\><C-n><C-w>j
tnoremap <silent> <C-k> <C-\><C-n><C-w>k
tnoremap <silent> <C-l> <C-\><C-n><C-w>l

" Выход из терминального режима в нормальный
tnoremap <Esc> <C-\><C-n>

" Автоматически переходить в режим вставки при открытии терминала

autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif



inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

" Перемещение по словам
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-b> <Left>
inoremap <C-f> <Right>


