-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Shorten function name
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
local M = {}

--Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "


                     ------- BASIC NEOVIM -------

M.setup = function()

  -- space will do nothing but leader key
  keymap("", "<Space>", "<Nop>", opts)

  -- Normal --

  -- Cancel search highlight
  keymap("n", "<Leader><CR>", ":nohlsearch<CR>", opts)

  -- Pairs
  keymap("i","{","{}<ESC>i",opts)
  keymap("i","[","[]<LEFT>",opts)
  keymap("i","(","()<LEFT>",opts)
  keymap("i","<c-d>","<DELETE>",opts)
  keymap("i","]","<c-r>=SkipSquarebrackets()<CR>",opts)
  keymap("i",")","<c-r>=SkipParentheses()<CR>",opts)
  keymap("i","}","<c-r>=SkipCurlybrackets()<CR>",opts)

  vim.cmd([[
  func SkipParentheses()
      if getline('.')[col('.') - 1] == ')'
          return "\<ESC>la"
      else
          return ")"
      endif
  endfunc

  func SkipCurlybrackets()
      if getline('.')[col('.') - 1] == '}'
          return "\<ESC>la"
      else
          return "}"
      endif
  endfunc

  func SkipSquarebrackets()
      if getline('.')[col('.') - 1] == ']'
          return "\<ESC>la"
      else
          return "]"
      endif
  endfunc
  ]])

  -- Netrw
  keymap("n","<leader>e",":call ToggleNetrw()<CR>", opts)

  -- Better window navigation
  keymap("n", "<C-h>", "<C-w>h", opts)
  keymap("n", "<C-j>", "<C-w>j", opts)
  keymap("n", "<C-k>", "<C-w>k", opts)
  keymap("n","<C-l>","<C-w>l", opts)
  -- Fix <C-l> acting weird from netrw to window
  vim.cmd([[
  augroup netrw_mapping
    autocmd!
    autocmd filetype netrw call NetrwMapping()
  augroup END

  function! NetrwMapping()
    nnoremap <buffer> <c-l> :wincmd l<cr>
  endfunction
  ]])
  -- Resize with arrows
  keymap("n", "<C-Up>", ":resize +2<CR>", opts)
  keymap("n", "<C-Down>", ":resize -2<CR>", opts)
  keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
  keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

  -- Naviagate buffers
  keymap("n", "<S-l>", ":bnext<CR>", opts)
  keymap("n", "<S-h>", ":bprevious<CR>", opts)

  -- Move text up and down
  keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
  keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)
  keymap("n", "[e", ":<c-u>execute 'move -1-'. v:count1<cr>", opts)
  keymap("n", "]e", ":<c-u>execute 'move +'. v:count1<cr>", opts)

  -- Visual --
  -- Stay in indent mode
  keymap("v", "<", "<gv", opts)
  keymap("v", ">", ">gv", opts)

  -- Move text up and down
  keymap("v", "<A-j>", ":m .+1<CR>==", opts)
  keymap("v", "<A-k>", ":m .-2<CR>==", opts)
  keymap("v", "p", '"_dP', opts)

  -- Visual Block --
  -- Move text up and down
  keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
  keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
  keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
  keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

  -- Terminal --
  keymap("n", "<leader>s", ":bo 12new<CR>:terminal<CR>", opts)

  -- MarkdownPreview
  keymap("n", "<leader>mp",":MarkdownPreview<CR>",opts)
  keymap("n", "<leader>ms",":MarkdownPreviewStop<CR>",opts)
  keymap("n", "<leader>gl",":Glow<CR>",opts)
  -- 命令行历史
  keymap('c', '<c-n>','<down>', opts)
  keymap('c', '<c-p>','<up>', opts)

  -- excutable
  keymap('n', '<leader>x', '<cmd>!chmod +x %<CR>', opts)
  
  -- inlay_hint
  vim.keymap.set("n", "<leader>ih", function () vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)


                      ------- plugins -------

  -- buffer %bd 删除所有缓冲区, e# 打开最后一个缓冲区, bd# 关闭[No Name]
  vim.api.nvim_create_user_command("BufferCloseOther", function()
    require("V9.core.utils").close_other_bufline()
  end, {})

  keymap("n", "<Leader>w", ":bd<CR>", opts)
  keymap("n", "<Leader>W", ":%bd<CR>",opts)

  -- buffer
  keymap("n", "<leader>n", ":BufferLineCycleNext <CR>", opts)
  keymap("n", "<leader>p", ":BufferLineCyclePrev <CR>", opts)

  -- symbols-outline.nvim
  keymap("n", "<leader>S", ":<C-u>SymbolsOutline<CR>", opts)

  -- Telescope
  keymap("n", "<leader>tf", "<cmd>Telescope find_files<cr>", opts)
  vim.keymap.set("v", "<leader>tf", function()
    local tb = require("telescope.builtin")
    local text = require("V9.core.utils").get_visual_selection()
    tb.find_files({ default_text = text })
  end, opts)
  keymap("n", "<leader>tg", "<cmd>Telescope live_grep<cr>", opts)
  vim.keymap.set("v", "<leader>tg", function()
    local tb = require("telescope.builtin")
    local text = require("V9.core.utils").get_visual_selection()
    tb.live_grep({ default_text = text })
  end, opts)
  keymap("n", "<leader>tb", "<cmd>Telescope buffers<cr>", opts)
  keymap("n", "<leader>th", "<cmd>Telescope help_tags<cr>", opts)

  -- ToggleTask
  --keymap("n", "<leader>ts", "<cmd>Telescope toggletasks spawn<cr>", opts)

  -- dap
  keymap("n", "<leader>B", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
  keymap("n", "<leader>lp", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", opts)
  keymap("n", "<leader>o", "<cmd>lua require'dap'.repl.open()<CR>", opts)
  -- 打断点
  keymap("n", "<leader>b", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
  -- 开启调试或到下一个断点处
  keymap("n", "<F6>", "<cmd>lua require'dap'.continue()<CR>", opts)
  -- 单步进入执行（会进入函数内部，有回溯阶段）
  keymap("n", "<F7>", "<cmd>lua require'dap'.step_into()<CR>", opts)
  -- 单步跳过执行（不进入函数内部，无回溯阶段）
  keymap("n", "<F8>", "<cmd>lua require'dap'.step_over()<CR>", opts)
  -- 步出当前函数
  keymap("n", "<F9>", "<cmd>lua require'dap'.step_out()<CR>", opts)
  -- 重启调试
  keymap("n", "<F10>", "<cmd>lua require'dap'.run_last()<CR>", opts)
  -- 退出调试（关闭调试，关闭 repl，关闭 ui，清除内联文本）
  keymap( "n", "<F11>", "<cmd>lua require'dap'.close()<CR><cmd>lua require'dap.repl'.close()<CR><cmd>lua require'dapui'.close()<CR><cmd>DapVirtualTextForceRefresh<CR>", opts)
  -- nvim-dap-ui
  keymap( "n", "<F5>", "<cmd>lua require'dapui'.float_element(vim.Nil, { enter = true})<CR>", opts)

  -- bufferline.nvim
 -- keymap("n","<A-1>","<Cmd>BufferLineGoToBuffer 1 <CR>", opts)
 -- keymap("n","<A-2>","<Cmd>BufferLineGoToBuffer 2 <CR>", opts)
 -- keymap("n","<A-3>","<Cmd>BufferLineGoToBuffer 3 <CR>", opts)
 -- keymap("n","<A-4>","<Cmd>BufferLineGoToBuffer 4 <CR>", opts)
 -- keymap("n","<A-5>","<Cmd>BufferLineGoToBuffer 5 <CR>", opts)
 -- keymap("n","<A-6>","<Cmd>BufferLineGoToBuffer 6 <CR>", opts)
 -- keymap("n","<A-7>","<Cmd>BufferLineGoToBuffer 7 <CR>", opts)
 -- keymap("n","<A-8>","<Cmd>BufferLineGoToBuffer 8 <CR>", opts)
 -- keymap("n","<A-9>","<Cmd>BufferLineGoToBuffer 9 <CR>", opts)

  -- nvim-spectre
  keymap("n", "<leader>R", "<cmd>lua require('spectre').open()<CR>", opts)

  -- search current word
  keymap("n", "<leader>fr", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", opts)
  keymap("v", "<leader>fr", "<esc>:lua require('spectre').open_visual()<CR>", opts)

  -- search in current file
  -- keymap("n", "<leader>fp", "viw:lua require('spectre').open_file_search()<cr>", opts)
  -- run command :Spectre

  -- camel_case
  require("V9.core.utils").camel_case_init()

  -- start language server
  keymap("n", "<leader>i", "<cmd>LspStart<CR>", opts)

  -- todo-comments
  vim.keymap.set("n", "]t", function()
    require("todo-comments").jump_next()
  end, { desc = "Next todo comment" })

  vim.keymap.set("n", "[t", function()
    require("todo-comments").jump_prev()
  end, { desc = "Previous todo comment" })
end


-- lsp 回调函数快捷键设置
M.maplsp = function(client, buffer)
  vim.api.nvim_buf_set_keymap(buffer, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  -- rename
  vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  -- mapbuf('n', '<leader>rn', '<cmd>lua require("lspsaga.rename").rename()<CR>', opts)
  -- code action
  vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  vim.api.nvim_buf_set_keymap(buffer, "v", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  -- mapbuf('n', '<leader>ca', '<cmd>lua require("lspsaga.codeaction").code_action()<CR>', opts)
  -- diagnostic
  vim.api.nvim_buf_set_keymap(buffer, "n", "go", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  vim.api.nvim_buf_set_keymap(buffer, "n", "[g", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  vim.api.nvim_buf_set_keymap(buffer, "n", "]g", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  vim.api.nvim_buf_set_keymap(
    buffer,
    "n",
    "[e",
    "<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>",
    opts)
  vim.api.nvim_buf_set_keymap(
    buffer,
    "n",
    "]e",
    "<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })<CR>",
    opts)

  vim.keymap.set("n", "<leader>=", function()
    local bfn = vim.api.nvim_get_current_buf()
    vim.lsp.buf.format({
      bufnr = bfn,
      filter = function(c)
        return require("V9.lsp.utils").filter_format_lsp_client(c, bfn)
      end,
    })
  end, opts)
  vim.api.nvim_buf_set_keymap(
    buffer,
    "v",
    "<leader>=",
    '<cmd>lua require("V9.lsp.utils").format_range_operator()<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>xw", "<cmd>Telescope diagnostics<CR>", opts)
  vim.api.nvim_buf_set_keymap(
    buffer,
    "n",
    "<leader>xe",
    "<cmd>lua require('telescope.builtin').diagnostics({ severity = vim.diagnostic.severity.ERROR })<CR>",
    opts
  )

  -- go xx
  -- mapbuf('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(buffer, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  vim.api.nvim_buf_set_keymap(buffer, "n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)

  if client.supports_method("textDocument/definition") then
    vim.api.nvim_buf_set_keymap(buffer, "n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
  else
    vim.api.nvim_buf_set_keymap(buffer, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  end

  vim.api.nvim_buf_set_keymap(buffer, "n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  vim.api.nvim_buf_set_keymap(buffer, "n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  vim.api.nvim_buf_set_keymap(buffer, "n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
  vim.api.nvim_buf_set_keymap(
    buffer,
    "n",
    "gr",
    "<cmd>lua require('telescope.builtin').lsp_references({jump_type='never'})<CR>",
    opts
  )
  vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>fs", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", opts)
  vim.keymap.set("v", "<leader>fs", function()
    local tb = require("telescope.builtin")
    local text = require("V9.core.utils").get_visual_selection()
    tb.lsp_workspace_symbols({ default_text = text, query = text })
  end, opts)

  vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>fo", "<cmd>Telescope lsp_document_symbols<CR>", opts)
  -- >= 0.8.x
  if client.server_capabilities.documentHighlightProvider then
    vim.cmd(string.format("au CursorHold  <buffer=%d> lua vim.lsp.buf.document_highlight()", buffer))
    vim.cmd(string.format("au CursorHoldI <buffer=%d> lua vim.lsp.buf.document_highlight()", buffer))
    vim.cmd(string.format("au CursorMoved <buffer=%d> lua vim.lsp.buf.clear_references()", buffer))
  end
  vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>cr", "<Cmd>lua vim.lsp.codelens.refresh()<CR>", opts)
  vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>ce", "<Cmd>lua vim.lsp.codelens.run()<CR>", opts)
end

--M.luasnip = function()
--  -- <c-k> is my expansion key
--  -- this will expand the current item or jump to the next item within the snippet.
--  vim.keymap.set({ "i", "s" }, "<leader>l", function()
--    if ls.expand_or_jumpable() then
--      ls.expand_or_jump()
--    end
--  end, { silent = true })
--
--  -- <c-j> is my jump backwards key.
--  -- this always moves to the previous item within the snippet
--  vim.keymap.set({ "i", "s" }, "<leader>h", function()
--    if ls.jumpable(-1) then
--      ls.jump(-1)
--    end
--  end, { silent = true })
--
--  -- <c-l> is selecting within a list of options.
--  -- This is useful for choice nodes (introduced in the forthcoming episode 2)
--  vim.keymap.set("i", "<tab>", function()
--    if ls.choice_active() then
--      ls.change_choice(1)
--    end
--  end)
--
--  vim.keymap.set("i", "<leader>u", require "luasnip.extras.select_choice")
--
--  -- shorcut to source my luasnips file again, which will reload my snippets
--  vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>")
--end


-- nvim-cmp 自动补全
M.cmp = function(cmp)
  local luasnip = require("luasnip")
  local neogen = require("neogen")
  local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
      return false
    end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end
  return {
    -- 上一个
    -- ['<C-k>'] = cmp.mapping.select_prev_item(),
    -- 下一个
    -- ['<Tab>'] = cmp.mapping.select_next_item(),
    -- ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    -- ['<Esc>'] = cmp.mapping.close(),
    -- 确认
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      -- select = true,
    }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
     -- elseif luasnip.expand_or_jumpable() then
     --   luasnip.expand_or_jump()
      elseif neogen.jumpable() then
        neogen.jump_next()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s"}),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
     -- elseif luasnip.jumpable(-1) then
     --   luasnip.jump(-1)
      elseif neogen.jumpable(true) then
        neogen.jump_prev()
      else
        fallback()
      end
    end, { "i", "s"}),

    ["<leader>l"] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }, { silent = true }),

    ["<leader>h"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {"i", "s" }, { silent = true }),
  }
end

return M
                      ------按键映射 end  ------
