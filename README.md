# nvim-0.9
lazy
when using neovim via windows, telescope-fzf-native should be cmake manually go to '~\AppData\Local\nvim-data\lazy\telescope-fzf-native.nvim' then run this command 
```
cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build
```
