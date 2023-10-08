require("V9.lsp.lsp_ui").init()
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup({
  ensure_installed = {
    "lua_ls",
    "clangd",
    "gopls",
    "jdtls",
  },
})

-- { key: 语言 value: 配置文件 }
local server_configs = {
  lua_ls = require("V9.lsp.lua_ls"),
  clangd = require("V9.lsp.clangd"),
  pyright = require("V9.lsp.pyright"),
  rust_analyzer = require("V9.lsp.rust_analyzer"),
  gopls = require("V9.lsp.gopls"),
  jdtls = require("V9.lsp.java"),
  --metals = require("V9.lsp.metals"),
  --tsserver = require("V9.lsp.tsserver"),
  --html = require("V9.lsp.html"),
  --sqlls = require("V9.lsp.sqlls"),
  --kotlin_language_server = {},
  --vuels = {},
  --lemminx = require("V9.lsp.lemminx"),
  --gdscript = require("V9.lsp.gdscript"),
  --rime_ls = require("V9.lsp.rime_ls"),
}

local utils = require("V9.core.utils")

require("mason-lspconfig").setup_handlers({
  function(server_name)
    local lspconfig = require("lspconfig")
    -- tools config
    local cfg = utils.or_default(server_configs[server_name], {})
    -- 自定义启动方式
    if cfg.setup then
      return
    end

    -- lspconfig
    local scfg = utils.or_default(cfg.server, {})
    scfg.flags = {
      debounce_text_changes = 150,
    }
    scfg.capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
    lspconfig[server_name].setup(scfg)

   -- -- clangd_extensions
   -- if server_name == "clangd" then
   --   -- Initialize the LSP via clangd_extensions instead
   --   cfg.server = scfg
   --   require("clangd_extensions").setup(cfg)
   -- else
   --   lspconfig[server_name].setup(scfg)
   -- end
  end,
})

-- 自定义 LSP 启动方式
for _, value in pairs(server_configs) do
  if value.setup then
    value.setup({
      flags = {
        debounce_text_changes = 150,
      },
      capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    })
  end
end

-- LspAttach 事件
vim.api.nvim_create_augroup("LspAttach_keymap", {})
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspAttach_keymap",
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.name == "copilot" then
      return
    end
    -- 绑定快捷键
    require("V9.core.keybindings").maplsp(client, bufnr)
  end,
})

vim.api.nvim_create_augroup("LspAttach_inlay_hint", {})
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspAttach_inlay_hint",
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    vim.api.nvim_buf_create_user_command(bufnr, "InlayHint", function()
      vim.lsp.inlay_hint(0)
    end, {
      nargs = 0,
    })
    if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      vim.lsp.inlay_hint(bufnr, true)
    end
  end,
})

--vim.api.nvim_create_augroup("LspAttach_navic", {})
--vim.api.nvim_create_autocmd("LspAttach", {
--  group = "LspAttach_navic",
--  callback = function(args)
--    if not (args.data and args.data.client_id) then
--      return
--    end
--
--    local bufnr = args.buf
--    local client = vim.lsp.get_client_by_id(args.data.client_id)
--    if client.server_capabilities.documentSymbolProvider then
--      vim.opt_local.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
--      require("nvim-navic").attach(client, bufnr)
--    end
--  end,
--})
