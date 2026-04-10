-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- 仅在Windows系统下生效，设置默认shell为PowerShell
if vim.fn.has("win32") == 1 then
  -- 核心：将默认shell设置为powershell.exe
  vim.o.shell = "powershell.exe"

  -- PowerShell启动参数：
  -- -NoLogo：不显示启动logo
  -- -NoProfile：不加载用户配置文件（加快启动，避免冲突）
  -- -ExecutionPolicy RemoteSigned：解决脚本执行权限问题
  -- 编码设置：避免中文乱码
  vim.o.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"

  -- 处理命令输出重定向（确保编码和退出码正确）
  vim.o.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"

  -- 禁用不必要的引号处理，适配PowerShell语法
  vim.o.shellquote = ""
  vim.o.shellxquote = ""
end
