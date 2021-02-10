" LOAD PLUGIN FIRST
source $HOME/.config/nvim/vim-plug.vim


" LOAD NVIM SETTING
source $HOME/.config/nvim/settings/set.vim
source $HOME/.config/nvim/settings/keybind.vim
source $HOME/.config/nvim/settings/filetype.vim

" LOAD PLUGIN SETTING
source $HOME/.config/nvim/plugins/coc.vim
source $HOME/.config/nvim/plugins/indentLine.vim
source $HOME/.config/nvim/plugins/vim-gitgutter.vim
source $HOME/.config/nvim/plugins/barbar.vim

" LOAD LUA BASED PLUGIN SETING
lua require('treesitter')
lua require('galaxy_line')
lua require('nvim_tree')
"lua require('conf.lsp')
"lua require('conf.completion')
lua require('nvim_telescope')
lua require('nvim_web_devicon')
lua require'colorizer'.setup()


highlight BufferInactive guifg=#CDCFE0 guibg=#5A5576
highlight BufferCurrent guifg=#DBAFE7 guibg=#484461
highlight BufferTabPageFill guifg=#B1AFE7 guibg=#484461

