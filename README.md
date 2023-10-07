# nvim-0.9
lazy


when using neovim via windows wsl 2, telescope-fzf-native should be cmake manually go to '~\AppData\Local\nvim-data\lazy\telescope-fzf-native.nvim' then run this command 
```
cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build
```


if an error reported by treesitter, delete the config part of treesitter in lazy-nvim.lua


set api-key as OPENAI_API_KEY in Settings -> System Properties-> System variables for chatgpt.nvim then then config part: 'api_key_cmd = xxxx' in lazy-nvim.lua for chatgpt.nvim is not required 
