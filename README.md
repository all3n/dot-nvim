# All3n Vim/NeoVim Configs

## NeoVim Lua Full Package Install
```
git clone https://github.com/all3n/dot-nvim.git ~/.config/nvim
cd ~/.config/nvim
# for osx
cp configs/config-osx.template.json config.json

# for ubuntu
cp configs/config-ubuntu.template.json config.json
```
## global 
1. leader -> space

## init entrypoint
1. init.lua

## vim basic options configuration
1. lua/options.lua

## plugins configuration
1. lua/plugins.lua

## colorscheme
1. everforest

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
| leader + ;   |dashboard|n|
| leader + space |  toggle line/multi comment | n/v|
| leader + c     |close buf |n|
| leader + bo     |close others buffer |n|
| leader + w     |save |n|
| leader + lf   |  format file by lsp |n |
| leader + la   |lsp actions(useful)|n|
| leader + lc   |lsp change env,py|n|
| leader + li   |show lsp info|n|
| leader + lI   |show mason info|n|
| leader + e     |toggle nvim-tree |n|
| leader + g     |git actions |n|
| leader + d     |debug actions |n|
| leader + to    |toggle symbol outline|n|
| leader + th    |toggle header/source for c/c++|n|
| leader + hw    |hop jump by word|n|
| S-h,S-l        |buffer previous/next(useful)|n|
| c+w h,j,k,l    |windows jump|n|
| c+  h,j,k,l      |windows jump(useful)|n|
| ctrl + \       |toggle float terminal|n|
| leader + rr     |run file |n|
| leader + ra     |run by args |n|
| leader + st     |search text |n|
| leader + sf     |search file |n|
| leader + sr     |search recent file |n|
| leader + mt     |toggle markdown preview(md) |n|
| K     |show document, press K again cursor into document|n|


## LuaSnip
1. snippets dir



## JAVA (JdtLs)
### 1.Ubuntu set java 
```
cp ~/.config/nvim/configs/config-ubuntu.template.json ~/.config/nvim/config.json
bash ~/.config/nvim/bin/setup.sh
sudo apt-get install openjdk-17-jdk
```

### 2.Macos set java
default jdk is openjdk21
old jdk download from https://www.azul.com/downloads/?package=jdk#zulu
```
brew install openjdk
brew install openjdk@17
```

## distant
1. use musl libc for avoid glibc not support
1. curl -L https://sh.distant.dev | sh -s -- --distant-host 'x86_64-unknown-linux-musl'



## metals
```
mkdir -p ~/.local/bin
curl -fL https://github.com/VirtusLab/coursier-m1/releases/latest/download/cs-aarch64-apple-darwin.gz | gzip -d > ~/.local/bin/cs
chmod +x ~/.local/bin/cs
```
