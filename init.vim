:set number
:set relativenumber
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a

" Автоустановка vim-plug если он не установлен
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Инициализация плагинов
call plug#begin('~/.local/share/nvim/plugged')

" === LSP (Language Server Protocol) ===
Plug 'neovim/nvim-lspconfig'              " Конфигурация LSP клиента

" === Mason - менеджер LSP серверов ===
Plug 'williamboman/mason.nvim'            " Установка/управление LSP серверами
Plug 'williamboman/mason-lspconfig.nvim'  " Интеграция mason с lspconfig

" === Система автодополнения ===
Plug 'hrsh7th/nvim-cmp'                   " Движок автодополнения
Plug 'hrsh7th/cmp-nvim-lsp'               " Источник для LSP
Plug 'hrsh7th/cmp-buffer'                 " Источник из текста в буфере
Plug 'hrsh7th/cmp-path'                   " Источник для путей файлов
Plug 'hrsh7th/cmp-cmdline'                " Источник для командной строки

" === Сниппеты ===
Plug 'L3MON4D3/LuaSnip'                   " Движок сниппетов
Plug 'saadparwaiz1/cmp_luasnip'           " Источник для сниппетов

" === Улучшенная подсветка синтаксиса ===
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " Парсер синтаксиса

" === Дополнительные улучшения для C/C++ ===
Plug 'p00f/clangd_extensions.nvim'        " Дополнительные функции для clangd
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

lua <<EOF
--[[
  ШАГ 1: Настройка Mason (менеджер LSP серверов)
  Mason позволяет устанавливать LSP серверы прямо из Neovim
--]]
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

require("mason-lspconfig").setup({
  ensure_installed = {"clangd"},  -- Автоматически установить clangd
  automatic_installation = true   -- Автоустановка LSP для поддерживаемых языков
})

--[[
  ШАГ 2: Настройка возможностей автодополнения
--]]
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Дополнительные улучшения для автодополнения
capabilities.textDocument.completion.completionItem = {
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    },
  },
}

--[[
  ШАГ 3: Настройка clangd для C/C++
  clangd - это LSP сервер от LLVM для C/C++
--]]
require('lspconfig').clangd.setup({
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--background-index",      -- Индексация в фоне
    "--clang-tidy",           -- Включить clang-tidy для статического анализа
    "--header-insertion=never", -- Не автоматически вставлять include
    "--completion-style=detailed", -- Подробные подсказки
    "--cross-file-rename=true",    -- Переименование между файлами
    "--all-scopes-completion",     -- Автодополнение из всех областей видимости
    "--suggest-missing-includes"   -- Предлагать недостающие include
  },
  single_file_support = true,
  on_attach = function(client, bufnr)
    -- Настройка ключевых комбинаций при подключении LSP к буферу
    local opts = { noremap = true, silent = true, buffer = bufnr }
    
    -- Переход к определению
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    
    -- Переход к объявлению
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    
    -- Показать информацию о функции
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    
    -- Перейти к реализации (если есть)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    
    -- Найти ссылки
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    
    -- Переименовать символ
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    
    -- Код действия (исправить ошибку и т.д.)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    
    -- Подпись функции
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  end,
})

--[[
  ШАГ 4: Настройка системы автодополнения (nvim-cmp)
--]]
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  
  -- Настройка клавиш для автодополнения
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),     -- Прокрутить документацию вверх
    ['<C-f>'] = cmp.mapping.scroll_docs(4),      -- Прокрутить документацию вниз
    ['<C-Space>'] = cmp.mapping.complete(),      -- Открыть автодополнение
    ['<C-e>'] = cmp.mapping.abort(),             -- Закрыть автодополнение
    ['<CR>'] = cmp.mapping.confirm({ 
      select = true 
    }),                                          -- Подтвердить выбор
    ['<Tab>'] = cmp.mapping.select_next_item(),  -- Следующий элемент
    ['<S-Tab>'] = cmp.mapping.select_prev_item() -- Предыдущий элемент
  }),
  
  -- Источники автодополнения (в порядке приоритета)
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },    -- LSP сервер
    { name = 'luasnip' }      -- Сниппеты
  }, {
    { name = 'buffer' },      -- Текст из текущего буфера
    { name = 'path' }         -- Пути файлов
  })
})

--[[
  ШАГ 5: Настройка Treesitter для улучшенной подсветки синтаксиса
--]]
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "c", 
    "cpp", 
    "lua", 
    "vim", 
    "vimdoc",
    "bash",
    "markdown"
  },
  
  sync_install = false,
  auto_install = true,
  
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  },
  
  indent = {
    enable = true
  }
}
EOF

" ==================== ОСНОВНЫЕ НАСТРОЙКИ РЕДАКТОРА ====================

set number                    " Показать номера строк
set relativenumber            " Относительные номера строк
set expandtab                 " Использовать пробелы вместо табов
set tabstop=4                 " Ширина табуляции 4 пробела
set shiftwidth=4              " Ширина автоотступа 4 пробела
set smartindent               " Умные отступы
set mouse=a                   " Включить мышь

set cursorline                " Подсветка текущей строки
set wrap                      " Перенос длинных строк
set linebreak                 " Перенос по словам

" Поиск
set ignorecase                " Игнорировать регистр при поиске
set smartcase                 " Учитывать регистр если есть заглавные
set incsearch                 " Инкрементальный поиск
set hlsearch                  " Подсветка результатов поиска

" Файлы
set encoding=utf-8            " Кодировка UTF-8
set fileencoding=utf-8
set swapfile                  " Создавать swap файлы
set undofile                  " Сохранять историю изменений

" Автодополнение в командной строке
set wildmenu
set wildmode=longest:list,full

" ==================== НАСТРОЙКИ ДЛЯ C/C++ ====================

" Автокоманды для C/C++ файлов
augroup c_cpp_settings
  autocmd!
  " Настройки для файлов C/C++
  autocmd FileType c,cpp setlocal commentstring=//\ %s
  autocmd FileType c,cpp setlocal foldmethod=syntax
  autocmd FileType c,cpp setlocal cindent
  autocmd FileType c,cpp setlocal cinoptions=g0,:0,N-s,(0
augroup END

" ==================== КЛАВИШИ ДЛЯ LSP ====================

" Навигация по диагностике (ошибкам/предупреждениям)
nnoremap <silent> [d <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> ]d <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <silent> <leader>e <cmd>lua vim.diagnostic.open_float()<CR>
nnoremap <silent> <leader>q <cmd>lua vim.diagnostic.setloclist()<CR>

" ==================== ПОДСВЕТКА ОШИБОК ====================

" Цвета для диагностики
highlight DiagnosticError ctermfg=red guifg=#ff0000
highlight DiagnosticWarn ctermfg=yellow guifg=#ffff00
highlight DiagnosticInfo ctermfg=blue guifg=#00ffff
highlight DiagnosticHint ctermfg=green guifg=#00ff00

" Значки для диагностики (если поддерживается)
sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=
sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=
sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=
sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=
