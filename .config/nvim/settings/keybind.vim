"" Keybindings

"" Leader
let mapleader=','

"" Buffers {{{
noremap <A-j> :bp<cr>
noremap <A-k> :bn<cr>
noremap <A-L> :bl<cr>
noremap <A-H> :bf<cr>

" close buffer
noremap <leader>q :bp<cr>:bd #<cr>

" Autofomat
noremap <leader>f :Autoformat<CR>

" Nerd Tree
nnoremap <C-\> :NvimTreeToggle<CR>

" Easy align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
