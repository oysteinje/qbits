" Plugins will be downloaded under the specified directory.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'junegunn/seoul256.vim'
Plug 'Mofiqul/dracula.nvim'
Plug 'projekt0n/github-nvim-theme'
Plug 'arcticicestudio/nord-vim'
Plug 'pprovost/vim-ps1'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Theme
colorscheme nord

" Settings
set ignorecase
set number
set expandtab
set shiftwidth=2
"
"   NORWEGIAN KEYBOARD MODS
"

"NORMAL
"nnoremap ø (
"nnoremap æ )
"nnoremap Ø {
"nnoremap Æ }
"nnoremap å 0
"nnoremap Å $
"
"nnoremap <A-æ> æ
"nnoremap <A-ø> ø
"nnoremap <A-Æ> Æ
"nnoremap <A-Ø> Ø
"
""VISUAL
"vnoremap ø (
"vnoremap æ )
"vnoremap Ø {
"vnoremap Æ }
"vnoremap å \
"vnoremap Å `
"
"vnoremap <A-æ> æ
"vnoremap <A-ø> ø
"vnoremap <A-Æ> Æ
"vnoremap <A-Ø> Ø
"
""REPLACE
"lnoremap ø (
"lnoremap æ )
"lnoremap Ø {
"lnoremap Æ }
"lnoremap å \
"lnoremap Å `
"
""INSERT
"inoremap ø (
"inoremap æ )
"inoremap Ø {
"inoremap Æ }
"inoremap <A-æ> ]
"inoremap <A-ø> [
"inoremap å \
"inoremap Å `
"
"inoremap <A-e> æ
"inoremap <A-o> ø
"inoremap <A-E> Æ
"inoremap <A-O> Ø
"inoremap <A-a> å
"inoremap <A-A> Å
"
"inoremap <C-æ> æ
"inoremap <C-ø> ø
"inoremap <C-Æ> Æ
"inoremap <C-Ø> Ø
