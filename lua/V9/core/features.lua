local config = require("V9.config")
-- vim.g.python_host_prog='/opt/homebrew/bin/python3'
vim.g.python3_host_prog = config.env.py_bin

-- shell options
--vim.opt.shell = vim.fn.executable "pwsh" and "pwsh" or "powershell"
--vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
--vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
--vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
--vim.opt.shellquote = ""
--vim.opt.shellxquote = ""

--if vim.fn.has("wsl") == 1 then
--  vim.g.clipboard = {
--    name = "win32yank-wsl",
--    copy = {
--      ["+"] = "win32yank.exe -i --crlf",
--      ["*"] = "win32yank.exe -i --crlf",
--    },
--    paste = {
--      ["+"] = "win32yank.exe -o --lf",
--      ["*"] = "win32yank.exe -o --lf",
--    },
--    cache_enabled = 0,
--  }
--end

-- Netrw 
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_winsize = 25

-- Hide statusline by setting laststatus and cmdheight to 0.
--vim.o.ls = 0
--vim.o.ch = 0

-- Set the winbar to the statusline.
--vim.o.stl = vim.o.wbr

-- With vertical splits, the statusline would still show up at the
-- bottom of the split. A quick fix is to just set the statusline
-- to empty whitespace (it can't be an empty string because then
-- it'll get replaced by the default stline).
--vim.o.stl = " "

-- global statusLine
vim.o.laststatus = 3

----fat cursor
vim.opt.guicursor = ""

-- 文件编码格式
vim.opt.fileencoding = "utf-8"

-- 显示行号
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2
vim.opt.ruler = false

-- show cursorline & cursorcolumn
vim.opt.cul = true
vim.opt.cuc = true

-- tab=4个空格
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

local autocmd = vim.api.nvim_create_autocmd
autocmd("FileType", {
  pattern = {
    "lua",
    "javascript",
    "json",
    "css",
    "html",
    "xml",
    "yaml",
    "http",
    "markdown",
    "lisp",
    "sh",
    "dart",
  },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.expandtab = true

vim.opt.wrap = false

-- 是否特殊显示空格等字符
vim.o.list = true

--在处理未保存或制度文件的时候，弹出确认
vim.o.confirm = true

-- No backup but can undo from days ago
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

--vim.opt.undodir = "/tmp"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 3
vim.opt.pumheight = 20

vim.opt.signcolumn = "auto"
vim.opt.isfname:append("@-@")

-- 设定在无操作时，交换文件刷写到磁盘的等待毫秒数（默认为 4000）
vim.opt.updatetime = 50

-- 设定等待按键时长的毫秒数 leader key is ' ', so when you insert space it lags
vim.opt.timeout = true
vim.opt.timeoutlen = 200
vim.opt.mouse = "a"
-- 去掉NonText和EndOfBuffer的~标志nvim only
vim.opt.fillchars = { eob = ' ', fold = ' ', vert = '|' }

vim.opt.colorcolumn = "80"

vim.opt.wildmenu = true
vim.opt.wildmode = { 'longest:list', 'full' }

vim.opt.suffixesadd = ".java"

vim.opt.clipboard = "unnamedplus"

--智能大小写
vim.opt.smartcase = true

vim.opt.ignorecase = true

-- 当文件被外部程序修改时，自动加载
vim.o.autoread = true
vim.bo.autoread = true

vim.opt.foldcolumn = "0"
vim.opt.foldenable = true

-- 默认不要折叠
-- https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99

vim.opt_global.completeopt = "menu,menuone,noselect"
vim.opt_global.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt_global.grepformat = "%f:%l:%c:%m,%f:%l:%m"

vim.opt.title = true

-- UI highlight
vim.api.nvim_set_hl(0, "Cursor", { bg = "#9E619E", fg = "#619E9E" })
vim.api.nvim_set_hl(0, "ModeMsg", { bg = "NONE", fg = "#619E9E" })
vim.api.nvim_set_hl(0, "Search", { bg = "#619E9E", fg = "#9E619E" })
vim.api.nvim_set_hl(0, "IncSearch", { bg = "#9E619E", fg = "#619E9E" })
vim.api.nvim_set_hl(0, "WildMenu", { bg = "#9E619E", fg = "#619E9E" })
vim.api.nvim_set_hl(0, "Normal", { ctermbg = "NONE", bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { ctermbg = "NONE", bg = "NONE" })
vim.api.nvim_set_hl(0, "Pmenu", { cterm = {bold = true}, bold = true, ctermbg = "NONE", bg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLine", { ctermbg = "NONE", bg = "NONE", fg = "#9E9E9E" })
vim.api.nvim_set_hl(0, "StatusLineNC", { ctermbg = "NONE", bg = "#100D23", fg = "#9E619E" })
vim.api.nvim_set_hl(0, "TabLineSel", { ctermbg = "NONE", bg = "NONE", fg = "#9E9E9E" })
vim.api.nvim_set_hl(0, "TabLineFill", { ctermbg = "NONE", bg = "NONE", fg = "NONE" })
vim.api.nvim_set_hl(0, "TabLine", { ctermbg = "NONE", bg = "NONE", fg = "#616161" })
vim.api.nvim_set_hl(0, "LineNrBelow", { cterm = {italic = true}, ctermbg = "NONE", ctermfg = "DarkMagenta", italic = true, bg = "none", fg = "#619E9E" })
vim.api.nvim_set_hl(0, "LineNrAbove", { cterm = {italic = true}, ctermbg = "NONE", ctermfg = "DarkCyan", italic = true, bg = "none", fg = "#9E619E" })
vim.api.nvim_set_hl(0, "CursorLineNr", { cterm = {bold = true}, ctermbg = "NONE", ctermfg = "LightYellow", bold = true, bg = "none", fg = "#9D9D61" })
vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = "Black", bg = "#616161" })
vim.api.nvim_set_hl(0, "SignColumn", { ctermbg = "NONE", ctermfg = "NONE", bg = "NONE", fg = "NONE" })
vim.api.nvim_set_hl(0, "CursorLine", { cterm = {bold = true}, ctermbg = "NONE", bold = true, bg = "NONE", fg = "NONE" })
vim.api.nvim_set_hl(0, "CursorColumn", { cterm = {bold = true}, ctermbg = "NONE", bold = true, bg = "NONE", fg = "NONE" })
vim.api.nvim_set_hl(0, "VertSplit", { fg = "#9E9E61" })
vim.api.nvim_set_hl(0, "DiffAdd", {cterm = {bold = true}, ctermfg = "LightGreen", ctermbg = "NONE", bold = true, fg = "#619E61", bg = "NONE"})
vim.api.nvim_set_hl(0, "DiffChange",{cterm = {bold = true}, ctermfg = "LightBlue", ctermbg = "NONE", bold = true, fg = "#61619E", bg = "NONE"})
vim.api.nvim_set_hl(0, "DiffDelete",{cterm = {bold = true}, ctermfg = "LightGrey", ctermbg = "NONE", bold = true, fg = "#9E9E9E", bg = "NONE"})
vim.api.nvim_set_hl(0, "DiffChangeDelete",{cterm = {bold = true}, ctermfg = "LightRed", ctermbg = "NONE", bold = true, fg = "#9E6161", bg = "NONE"})
vim.api.nvim_set_hl(0, "Whitespace", {ctermfg = "DarkGrey", fg = "#616161"})
vim.api.nvim_set_hl(0, "NonText", {ctermfg = "DarkGrey", fg = "#616161"})
vim.api.nvim_set_hl(0, "Title", {ctermfg = "DarkMagenta", fg = "#F38BA8"})

-- Indent-Blankline Catppuccin highlight
vim.api.nvim_set_hl(0, "IndentBlanklineIndent1", { fg ="#F38BA8", bg = "NONE"})
vim.api.nvim_set_hl(0, "IndentBlanklineIndent2", { fg ="#FAB387", bg = "NONE"})
vim.api.nvim_set_hl(0, "IndentBlanklineIndent3", { fg ="#F9E2AF", bg = "NONE"})
vim.api.nvim_set_hl(0, "IndentBlanklineIndent4", { fg ="#A6E3A1", bg = "NONE"})
vim.api.nvim_set_hl(0, "IndentBlanklineIndent5", { fg ="#94E2D5", bg = "NONE"})
vim.api.nvim_set_hl(0, "IndentBlanklineIndent6", { fg ="#89B4FA", bg = "NONE"})
vim.api.nvim_set_hl(0, "IndentBlanklineIndent7", { fg ="#C6A0F6", bg = "NONE"})

-- Fidget highlight
vim.api.nvim_set_hl(0, "FidgetTitle", {ctermfg = "DarkGrey", fg = "#9E9E9E"})
vim.api.nvim_set_hl(0, "FidgetTask", {ctermfg = "DarkGrey", fg = "#9E9E9E"})
