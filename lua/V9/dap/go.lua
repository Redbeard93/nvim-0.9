-- if not install delve via mason, do `pacman -S delve` or `go install github.com/go-delve/delve/cmd/dlv@latest`
-- Go 环境变量设置
--export GOROOT=/usr/lib/go -- go语言安装目录
--export GOPATH=~/Projects/go -- go语言工作区
--export GOBIN=$GOPATH/bin -- 存放go语言可执行文件目录
--export PATH=$PATH:$GOROOT/bin:$GOBIN --为了随地调用go语言命令和go编译后的可执行文件，可以将$GOROOT/bin和$GOBIN加入到PATH
local M= {}
M.setup = function ()
  local dap = require("dap")
  dap.adapters.go = {
        type = "server",
        port = "${port}",
        executable = {
          command = 'dlv',
          args = {'dap', '-l', '127.0.0.1:${port}'},
        },
  }
  dap.configurations.go =  {
    {
      type = "go",
      name = "Debug",
      request = "launch",
      program = "${file}"
    },
    {
      type = "go",
      name = "Debug test", -- configuration for debugging test files
      request = "launch",
      mode = "test",
      program = "${file}"
    },
    -- works with go.mod packages and sub packages
    {
      type = "go",
      name = "Debug test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}"
    }
  }
  return true
end
return M
