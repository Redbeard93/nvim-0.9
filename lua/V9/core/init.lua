require("V9.core.features")
require("V9.core.gadgets")
vim.schedule(function()
  require("V9.core.utils.pandoc").setup()
  require("V9.core.utils.maven").setup()

  vim.api.nvim_create_user_command("Date", "lua print(os.date())", {})
end)
