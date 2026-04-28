local M = {}

-- Walk up from cwd to find the Obsidian vault containing Tasks/tasks/
local function tasks_dir()
  local root = vim.fs.find("Tasks", {
    upward = true,
    type = "directory",
    path = vim.fn.getcwd(),
    limit = 1,
  })[1]
  if not root then return nil end
  local dir = root .. "/tasks"
  return vim.fn.isdirectory(dir) == 1 and dir or nil
end

-- Collect main task entries. A task file is `T-XXXX-foo/T-XXXX-foo.md`
-- (filename matches its parent folder). Subtask folders nest inside parent
-- task folders and follow the same rule. _archive / _archive_on_hold are
-- only descended into when include_archived is true; entries from there
-- are flagged archived = true.
function M.find_files(include_archived)
  local root = tasks_dir()
  if not root then
    vim.notify("Tasks/tasks not found relative to cwd", vim.log.levels.WARN)
    return {}
  end

  local entries = {}
  local function scan(dir, archived)
    for name, kind in vim.fs.dir(dir) do
      if kind == "directory" then
        local path = dir .. "/" .. name
        local is_archive_dir = name == "_archive" or name == "_archive_on_hold"
        if is_archive_dir then
          if include_archived then scan(path, true) end
        elseif name:match("^T%-%d+%-") then
          local md = path .. "/" .. name .. ".md"
          if vim.fn.filereadable(md) == 1 then
            local id = name:match("^(T%-%d+)")
            local desc = name:gsub("^T%-%d+%-", "")
            local num = tonumber(name:match("^T%-(%d+)")) or 0
            table.insert(entries, {
              file = md,
              id = id,
              desc = desc,
              num = num,
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
  scan(root, false)

  -- Newest tasks (largest number) first; archived sink to bottom.
  table.sort(entries, function(a, b)
    if a.archived ~= b.archived then return not a.archived end
    return a.num > b.num
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
      { width = 4 },  -- tag: [归档] / 空
      { width = 7 },  -- T-XXXX
      { remaining = true },
    },
  })

  pickers.new({}, {
    prompt_title = include_archived and "All Task Files (incl. archive)"
        or "Active Task Files",
    finder = finders.new_table({
      results = entries,
      entry_maker = function(e)
        local tag = e.archived and "归档" or ""
        return {
          value = e.file,
          ordinal = (e.archived and "归档 " or "") .. e.id .. " " .. e.desc,
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
