# All3n NeoVim Configs
## Install
```
git clone https://github.com/all3n/dot-nvim.git ~/.config/nvim
```
## global 
1. leader -> space

## init entrypoint
1. init.lua

## vim basic options configuration
1. lua/options.lua

## plugins configuration
1. lua/plugins.lua


## plugins details configuration
1. lua/plugins/alpha.lua
    1. welcome page definition
1. lua/plugins/nvim-cmp.lua
    1. lsp complations support
1. lua/plugins/nvim-treesitter.lua
    1. lsp syntax 
1. lua/plugins/which_key.lua
    1. quick key support
# dot-nvim


| keymap   |      description      |  mode |
|----------|:-------------:|------:|
| leader + space |  toggle current line comment | -|
| leader + lf   |  format file by lsp |- |
| leader + e     |toggle nvim-tree |-|
| leader + to    |toggle symbol outline|-|
| S-h,S-l        |buffer previous/next|-|
| c+w h,j,k,l    |windows jump|-|
| ctrl + \       |toggle float terminal|-|


## LuaSnip
1. snippets dir



## Ubuntu set java dev
```
cp ~/.config/nvim/configs/config-ubuntu.template.json ~/.config/nvim/config.json
bash ~/.config/nvim/bin/setup.sh
sudo apt-get install openjdk-17-jdk
```



## distant
1. curl -L https://sh.distant.dev | sh -s -- --distant-host 'x86_64-unknown-linux-musl'
