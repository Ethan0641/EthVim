#!/bin/bash
clear
echo "============================================="
echo "       EthVim 开发环境一键自动部署脚本 "
echo "============================================="

# 1. 更新并安装系统依赖
sudo apt update -y
sudo apt install -y \
  vim git gcc g++ make python3 python3-pip \
  sdcc binutils xz-utils curl wget unzip glow

# 2. 安装 vim-plug 插件管理器
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# 3.安装nodejs依赖
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
node -v && npm -v
# 3. 写入完整 vimrc 配置
cat > ~/.vimrc << 'EOF'
" ===================== 基础设置 =====================
set nocompatible
set fenc=utf-8
set matchtime=2
set showmatch
set ts=4
set sw=4
set smartindent
set expandtab
set nobackup
set langmenu=zh_CN.UTF-8
language message zh_CN.UTF-8
set history=100
set ruler
set number
set ai
set tags=tags;/
set encoding=utf-8
set cul
set shortmess=atI
set noswapfile
syntax enable
syntax on
set clipboard=unnamedplus

"==================== 括号/引号自动补全 ==================
inoremap ( ()<ESC>i
inoremap [ []<ESC>i
inoremap ' ''<ESC>i
inoremap " ""<ESC>i
inoremap {{ {<CR>}<ESC>kA<Tab><CR>
inoremap { {}<ESC>i

" 鼠标支持
set mouse=a
set mousemodel=popup
set ttymouse=sgr

" ===================== 插件管理器 =====================
call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/taglist.vim'
Plug 'vim-syntastic/syntastic'
Plug '907th/vim-auto-save'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'luochen1990/rainbow'
call plug#end()

" ===================== gruvbox主题 =====================
set background=dark
colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_contrast_light = 'soft'
let g:gruvbox_italic = 1

" ===================== NERDTree设置 =====================
nnoremap <silent> ;n :NERDTreeToggle<CR>
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeWinSize = 30
let g:NERDTreeWinPos = 'left'
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeStatusline = 0
let g:NERDTreeMouseMode = 2
nnoremap <buffer> <2-LeftMouse> :NERDTreeLocateFile<CR>

" ==============================================
" Vim Airline 状态栏美化配置
" ==============================================
let g:airline_theme='bubblegum'
let g:airline_symbols = {}
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
set showtabline=2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline_symbols.left_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline_symbols.right_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#hunks#enabled = 1
let g:airline_powerline_fonts = 1

" ===================== Taglist函数大纲 =====================
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1
let Tlist_Sort_Type = "name"
let Tlist_Auto_Highlight_Tag = 1
let Tlist_File_Fold_Auto_Close = 1
nnoremap ;m :TlistToggle<CR>

" ===================== 自动编译快捷键 =====================
autocmd filetype python nnoremap <F2> :w <bar> exec '!python3 '.shellescape('%')<CR>
autocmd filetype c nnoremap <F2> :w<CR>:exec '!gcc '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>
autocmd filetype cpp nnoremap <F2> :w<CR>:exec '!mkdir -p ./bin && g++ --std=c++17 -finput-charset=UTF-8 -fexec-charset=UTF-8 '.shellescape('%').' -o ./bin/'.shellescape('%:r').' && ./bin/'.shellescape('%:r')<CR>
autocmd Filetype java nnoremap <F2> :w <bar> exec '!javac -d ./bin '.shellescape('%')<CR>
autocmd filetype java nnoremap <F3> :w <bar> exec '!java -cp ./bin '.shellescape('%:r')<CR>
nnoremap <F6> :!sdcc -mmcs51 --model-small % && packihx %:r.ihx > %:r.hex && rm -f %:r.asm %:r.lk %:r.lst %:r.map %:r.mem %:r.rel %:r.rst %:r.sym %:r.ihx<CR>

" ===================== 文件头自动插入 ==================
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java,*.go exec ":call SetTitle()"
func SetTitle()
    if &filetype == 'sh'
        call setline(1,"#########################################################################")
        call append(line("."),   "# File Name:    ".expand("%"))
        call append(line(".")+1, "# Author:       程序员Ethan064")
        call append(line(".")+2, "# mail:         tli568227@gmail.com ")
        call append(line(".")+3, "# Created Time: ".strftime("%Y-%m-%d %H:%M:%S"))
        call append(line(".")+4, "#########################################################################")
        call append(line(".")+5, "#!/bin/bash")
        call append(line(".")+6, "")
    else
        call setline(1, "/* ************************************************************************")
        call append(line("."),   "* File Name:     ".expand("%"))
        call append(line(".")+1, "* Author:        程序员Ethan064")
        call append(line(".")+2, "* mail:          tli568227@gmail.com")
        call append(line(".")+3, "* Created Time:  ".strftime("%Y-%m-%d %H:%M:%S"))
        call append(line(".")+4, "* Description:   ")
        call append(line(".")+5, " ************************************************************************/")
        call append(line(".")+6, "")
    endif
endfunc
autocmd BufNewFile * normal G

" ========== vim-auto-save 配置 ==========
let g:auto_save = 1
let g:auto_save_silent = 1
let g:auto_save_events = ['InsertLeave', 'TextChanged', 'FocusLost']
let g:auto_save_no_updatetime = 1
let g:auto_save_ignore_patterns = ['*.log', '*.tmp', '*.swp', '*.bak']

" F5 打开底部终端
nnoremap <F5> :terminal bash<CR>

" ==========================================
" Syntastic 语法检查
" ==========================================
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
nnoremap <Leader>p :SyntasticToggleMode<CR> :w<CR>
let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" ================= Coc.nvim 配置 =================
set completeopt=menu,menuone,noselect
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<S-TAB>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
let g:coc_global_extensions = [
    \ 'coc-json',
    \ 'coc-clangd',
    \ 'coc-java',
    \ 'coc-snippets',
    \ 'coc-sh',
    \ 'coc-python',
    \ 'coc-html',
    \ 'coc-css',
    \ 'coc-tsserver',
    \ ]
set statusline^=%{coc#status()}%{coc#async_status()}

" ========== Rainbow 彩虹括号配置 ==========
let g:rainbow_active = 1
let g:rainbow_conf = {
\   'guifgs': ['#5fd7ff', '#ff8700', '#5fd700', '#ff5f5f', '#d787ff'],
\   'ctermfgs': ['69', '208', '71', '196', '171'],
\   'extended_mode': 1,
\   'operators': 1,
\   'max_level': 15
\}
hi MatchParen ctermfg=white ctermbg=236 guifg=white guibg=#303030

"=========Markdown glow 终端预览========================
" F6：临时退出 Vim，用 glow 预览当前文件，按回车返回
nnoremap <F6> :execute "silent !glow " . shellescape(expand('%:p')) . "; echo '按回车返回 Vim...'; read"<CR>
EOF

# 4. 自动安装所有 Vim 插件
vim +PlugInstall +qall

echo -e "\n===================================================== "
echo "   ________    __   __         _____                 "
echo "  |   __|  |  |  |  \  \      /  (__)__ ____  _____  "
echo "  |  |__|  |__|  |___\  \    /  /|  |  \__  \ __   \\"
echo "  |  ___|  ___|   ___ \  \  /  / |  |  |  |  |  |  | "
echo "  |  |__|  |__|  |   | \  \/  /  |  |  |  |  |  |  | "
echo "  |_____|\____|__|   |_|\____/   |__|__|  |__|  |__| "
echo ""
echo "                 ***** 安装完成！*****"
echo "====================================================="
echo " 快捷键："
echo " ;n     → NERDTree 文件树"
echo " ;m    → 函数大纲"
echo " F2    → 编译运行"
echo " F5    → 打开终端"
echo " p     → 开启/关闭语法检查"
echo "====================================================="
