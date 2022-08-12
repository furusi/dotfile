syntax on
set nocompatible
filetype off

if filereadable(expand('~/.vimrc.plugin')) 
source ~/.vimrc.plugin 
endif 


"filetype on
filetype plugin on
autocmd Filetype perl,cgi :compiler perl
set incsearch
set hlsearch
set showmatch
set list

set cindent
"Insertモードを抜けるときにインデントを有効にする
"autocmd InsertLeave * set nopaste
"pasteモードをトグル
imap <F11> <nop>
set pastetoggle=<F11>

"eucを編集？
"set enc=utf-8
"set fenc=utf-8
"set fencs=iso-2022-jp,sjis,euc-jp,utf-8
"set fencs=ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932

"ステータスバーを表示
set laststatus=2
"コマンド補完
set wildmode=longest,list

set encoding=utf-8
set fenc=utf-8
set fileencodings=utf-8,cp932,sjis,euc-jp,iso-2022-jp
"set fileencodings=cp932,sjis,euc-jp,utf-8
set fileformats=unix,dos,mac

augroup PrevimSettings
autocmd!
autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END
autocmd BufNewFile,BufRead *.{aj} set filetype=java

if filereadable(expand('~/.vimrc.keybind'))
source ~/.vimrc.keybind
endif

if filereadable(expand('~/.vimrc.local'))
source ~/.vimrc.local
endif
" lazy method of appending this onto your .vimrc ":w! >> ~/.vimrc"

"spell check
set spell
set spelllang=en,cjk

"swpファイルのディレクトリを変更
set backupdir=$HOME/.tmp/vim/backup
let &directory = &backupdir
set undodir=$HOME/.tmp/vim/undo

set foldmethod=marker
set foldlevel=0
"set diffopt=filler,context:8

"カーソル位置記録
if has("autocmd")
augroup redhat
" In text files, always limit the width of text to 78 characters
autocmd BufRead *.txt set tw=78
" When editing a file, always jump to the last cursor position
autocmd BufReadPost *
\ if line("'\"") > 0 && line ("'\"") <= line("$") |
\   exe "normal! g'\"" |
\ endif
augroup END
endif

"ビジュアルモード選択範囲を検索
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
function! s:VSetSearch()
let temp = @s
norm! gv"sy
let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
let @s = temp
endfunction

set clipboard=unnamed
set tabstop=4
set autoindent
set expandtab
set shiftwidth=4
