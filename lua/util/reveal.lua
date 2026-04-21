-- Reveal an absolute file path in Windows Explorer, with the file selected.
--
-- Windows' foreground-activation rules normally leave the spawned Explorer
-- window behind nvim. Workaround: simulate a brief Alt keypress to reset
-- the foreground-lock timeout, then AllowSetForegroundWindow(-1) so the
-- next spawned process can take focus, then invoke explorer with /n,/select,
-- to force a fresh window.

local M = {}

local user32
do
  local ok, ffi = pcall(require, "ffi")
  if ok then
    local ok_load, u = pcall(ffi.load, "user32")
    if ok_load then
      pcall(ffi.cdef, [[
        int AllowSetForegroundWindow(unsigned long dwProcessId);
        void keybd_event(unsigned char bVk, unsigned char bScan, unsigned long dwFlags, unsigned long *dwExtraInfo);
      ]])
      user32 = u
    end
  end
end

local function unlock_foreground()
  if not user32 then return end
  -- VK_MENU (Alt) = 0x12; KEYEVENTF_KEYUP = 0x0002
  pcall(function()
    user32.keybd_event(0x12, 0, 0, nil)
    user32.keybd_event(0x12, 0, 0x0002, nil)
  end)
  pcall(function() user32.AllowSetForegroundWindow(0xFFFFFFFF) end)
end

function M.reveal(path)
  if not path or path == "" then return end
  path = vim.fn.fnamemodify(path, ":p"):gsub("/", "\\"):gsub("\\+$", "")
  unlock_foreground()
  local job = vim.fn.jobstart(
    { "cmd.exe", "/c", "start", "", "explorer", "/n,/select," .. path },
    { detach = true }
  )
  if job <= 0 then
    vim.notify("Failed to open Explorer: " .. path, vim.log.levels.ERROR)
  end
end

return M
