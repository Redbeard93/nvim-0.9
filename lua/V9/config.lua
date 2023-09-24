local M = {}
local utils = require("V9.core.utils")
local home = vim.loop.os_homedir()

M.extension_path =home .. "/.local/share/nvim/mason/packages/debugpy/venv"
M.debugpy_path = (function()
  if M.extension_path then
    if utils.is_win then
      return vim.fn.glob(M.extension_path .. "/Scripts/python")
    else
      return vim.fn.glob(M.extension_path .. "/bin/python")
    end
  end
end)()

M.env = {
  py_bin = vim.env["PY_BIN"] or M.debugpy_path,
  rime_ls_bin = vim.env["RIME_LS_BIN"],
}
M.plugin = {
  copilot = {
    enable = vim.env["COPILOT_ENABLE"] == "Y" and true or false,
  },
}
return M
