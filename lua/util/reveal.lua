-- Reveal an absolute file path in the OS file manager, with the file selected.
--
-- Windows: spawning Explorer normally leaves its window behind nvim because
-- of foreground-activation rules. Workaround: simulate a brief Alt keypress
-- to reset the foreground-lock timeout, then AllowSetForegroundWindow(-1)
-- so the next spawned process can take focus, then invoke explorer with
-- /n,/select, to force a fresh window.
--
-- macOS: `open -R <path>` reveals the file in Finder. Finder doesn't have
-- Windows' foreground restrictions, so no unlock dance is needed.

local M = {}

local is_win = vim.fn.has("win32") == 1
local is_mac = vim.fn.has("mac") == 1

-- Windows foreground unlock via LuaJIT FFI.
local user32
if is_win then
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

local function unlock_foreground_win()
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
  path = vim.fn.fnamemodify(path, ":p")
  local job, target
  if is_win then
    path = path:gsub("/", "\\"):gsub("\\+$", "")
    unlock_foreground_win()
    job = vim.fn.jobstart(
      { "cmd.exe", "/c", "start", "", "explorer", "/n,/select," .. path },
      { detach = true }
    )
    target = "Explorer"
  elseif is_mac then
    path = path:gsub("/+$", "")
    job = vim.fn.jobstart({ "open", "-R", path }, { detach = true })
    target = "Finder"
  else
    vim.notify("Reveal not supported on this platform", vim.log.levels.WARN)
    return
  end
  if job <= 0 then
    vim.notify("Failed to open " .. target .. ": " .. path, vim.log.levels.ERROR)
  end
end

return M
