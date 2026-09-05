local M = {}

-- Walk up from cwd to find the Obsidian vault root (the dir containing Tasks/).
local function vault_root()
  local tasks = vim.fs.find("Tasks", {
    upward = true,
    type = "directory",
    path = vim.fn.getcwd(),
    limit = 1,
  })[1]
  if not tasks then return nil end
  return vim.fs.dirname(tasks)
end

-- Collect main task entries from Tasks/tasks/. A task file is
-- `T-XXXX-foo/T-XXXX-foo.md` (filename matches its parent folder). Subtask
-- folders nest inside parent task folders and follow the same rule.
-- _archive / _archive_on_hold are only descended into when include_archived
-- is true; entries from there are flagged archived = true.
local function find_tasks(root, include_archived)
  local dir = root .. "/Tasks/tasks"
  if vim.fn.isdirectory(dir) ~= 1 then return {} end

  local entries = {}
  local function scan(d, archived)
    for name, kind in vim.fs.dir(d) do
      if kind == "directory" then
        local path = d .. "/" .. name
        local is_archive_dir = name == "_archive" or name == "_archive_on_hold"
        if is_archive_dir then
          if include_archived then scan(path, true) end
        elseif name:match("^T%-%d+%-") then
          local md = path .. "/" .. name .. ".md"
          if vim.fn.filereadable(md) == 1 then
            table.insert(entries, {
              file = md,
              id = name:match("^(T%-%d+)"),
              desc = name:gsub("^T%-%d+%-", ""),
              num = tonumber(name:match("^T%-(%d+)")) or 0,
              kind = "task",
              archived = archived,
            })
          end
          scan(path, archived) -- recurse for subtasks
        else
          scan(path, archived)
        end
      end
    end
  end
  scan(dir, false)
  return entries
end

-- Collect requirement entries from Dev/<Project>/requirements/. A requirement
-- file is named `<PREFIX>-NN-标题.md` (e.g. BOD-01-...). The REQUIREMENTS.md
-- index and unnumbered design notes don't match the pattern and are skipped.
-- The archived-project pile Dev/_archive/ is never descended into.
local function find_requirements(root)
  local dev = root .. "/Dev"
  if vim.fn.isdirectory(dev) ~= 1 then return {} end

  local entries = {}
  for proj, pkind in vim.fs.dir(dev) do
    if pkind == "directory" and proj ~= "_archive" then
      local reqdir = dev .. "/" .. proj .. "/requirements"
      if vim.fn.isdirectory(reqdir) == 1 then
        for fname, fkind in vim.fs.dir(reqdir) do
          local id = fkind == "file" and fname:match("^(%u+%-%d+)%-")
          if id then
            table.insert(entries, {
              file = reqdir .. "/" .. fname,
              id = id,
              desc = (fname:gsub("^%u+%-%d+%-", ""):gsub("%.md$", "")),
              proj = proj,
              kind = "req",
              archived = false,
            })
          end
        end
      end
    end
  end
  return entries
end

-- Active task files plus every Dev requirement; optionally include archived tasks.
function M.find_files(include_archived)
  local root = vault_root()
  if not root then
    vim.notify("Tasks/ not found relative to cwd", vim.log.levels.WARN)
    return {}
  end

  local entries = find_tasks(root, include_archived)
  vim.list_extend(entries, find_requirements(root))

  -- Active tasks first (newest number first), then requirements (by id),
  -- archived tasks sink to the bottom.
  table.sort(entries, function(a, b)
    if a.archived ~= b.archived then return not a.archived end
    if a.kind ~= b.kind then return a.kind == "task" end
    if a.kind == "task" then return a.num > b.num end
    return a.id < b.id
  end)
  return entries
end

function M.picker(include_archived)
  local entries = M.find_files(include_archived)
  if #entries == 0 then return end
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local entry_display = require("telescope.pickers.entry_display")

  local displayer = entry_display.create({
    separator = "  ",
    items = {
      { width = 4 },  -- tag: 归档 / 需求 / 空
      { width = 7 },  -- id: T-XXXX / PREFIX-NN
      { remaining = true },
    },
  })

  pickers.new({}, {
    prompt_title = include_archived
        and "Tasks (incl. archive) & Dev Requirements"
        or "Active Tasks & Dev Requirements",
    finder = finders.new_table({
      results = entries,
      entry_maker = function(e)
        local tag = e.archived and "归档" or (e.kind == "req" and "需求" or "")
        return {
          value = e.file,
          -- ordinal also carries the project name so `BOD`/项目名 narrows reqs
          ordinal = tag .. " " .. (e.proj or "") .. " " .. e.id .. " " .. e.desc,
          display = function()
            return displayer({
              { tag, "Comment" },
              { e.id, "Identifier" },
              e.desc,
            })
          end,
          filename = e.file,
          path = e.file,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = conf.file_previewer({}),
  }):find()
end

return M
