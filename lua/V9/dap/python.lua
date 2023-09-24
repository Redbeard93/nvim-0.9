-- python3 -m pip install debugpy
local M ={}
local utils = require("V9.core.utils")

M.extension_path = (function()
  if require("mason-registry").has_package("debugpy") then
    return require("mason-registry").get_package("debugpy"):get_install_path() .. "/venv"
  end
end)()

M.debugpy_path = (function()
  if M.extension_path then
    if utils.is_win then
      return vim.fn.glob(M.extension_path .. "/Scripts/python")
    else
      return vim.fn.glob(M.extension_path .. "/bin/python")
    end
  end
end)()

M.setup =  function ()
  if not M.extension_path then
    vim.notify("debugpy not found", vim.log.levels.WARN)
    return false
  end

  local dap = require("dap")
  dap.adapters.python = {
    type = "executable",
    command = M.debugpy_path,
    args = {"-m", "debugpy.adapter"},
    options = {
      source_filetype = 'python',
    },
  }
  dap.configurations.python = {
    {
      type = "python",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      pythonPath = function()
        return M.debugpy_path
      end
    }
  }
  return true
end
return M
