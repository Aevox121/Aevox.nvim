# Aevox.nvim

跨平台 LazyVim 配置，支持 Windows 和 macOS。

## 快速开始

### 1. 克隆配置

```bash
# Windows
git clone https://github.com/Aevox121/Aevox.nvim.git "$env:LOCALAPPDATA\nvim"

# macOS
git clone https://github.com/Aevox121/Aevox.nvim.git ~/.config/nvim
```

### 2. 必须手动配置的部分

以下文件包含 `[MANUAL]` 标记，需要根据你的本地环境修改：

#### `lua/config/options.lua` — GUI 字体

取消注释并设置你安装的字体：

```lua
vim.o.guifont = "CodeNewRoman Nerd Font Mono:h14"
```

#### `lua/plugins/snacks.lua` — 项目扫描目录

修改 `dev` 数组为你本地的项目目录：

```lua
-- Windows
dev = { "D:/Projects", "D:/Work" },

-- macOS
dev = { "~/Projects", "~/Work" },
```

#### `lua/plugins/ch-ime.lua` — 输入法标识符

设置你系统的输入法 ID：

```lua
-- Windows
normal_im = "1033",
insert_im = "2052",

-- macOS
normal_im = "com.apple.keylayout.ABC",
insert_im = "com.apple.inputmethod.SCIM.ITABC",
```

## 从远端同步更新（不覆盖本地配置）

**核心原则：不要用 `git pull` 直接覆盖，用 `git stash` 保护本地改动。**

### 方法一：stash + pull + stash pop（推荐）

```bash
# 1. 暂存你的本地修改
git stash

# 2. 拉取远端更新
git pull

# 3. 恢复你的本地修改（会自动合并）
git stash pop
```

如果出现冲突，Git 会标记冲突文件，手动解决即可。冲突通常只会出现在你手动配置过的文件里（`options.lua`、`snacks.lua`、`ch-ime.lua`）。

### 方法二：查看差异后手动合并

```bash
# 只看远端有什么变化，不做任何修改
git fetch origin
git diff HEAD..origin/main

# 确认后再合并
git merge origin/main
```

### 方法三：对手动配置的文件使用 `--skip-worktree`

如果你不想每次 pull 都处理冲突，可以让 Git 忽略对特定文件的本地修改：

```bash
# 告诉 Git 忽略这些文件的本地变更
git update-index --skip-worktree lua/config/options.lua
git update-index --skip-worktree lua/plugins/snacks.lua
git update-index --skip-worktree lua/plugins/ch-ime.lua
```

之后 `git pull` 不会触碰这些文件。如果需要恢复跟踪：

```bash
git update-index --no-skip-worktree lua/config/options.lua
```

## 插件列表

| 插件 | 用途 |
|------|------|
| telescope.nvim | 模糊搜索 |
| snacks.nvim | 项目切换器（含会话恢复） |
| render-markdown.nvim | 编辑器内 Markdown 渲染 |
| which-key.nvim | 快捷键提示 |
| mini.nvim | 图标等实用工具 |
| ch-ime.nvim | 中英文输入法自动切换 |
| four-claude.nvim | 多窗口 Claude CLI |
| opencode.nvim | OpenCode AI 集成 |
| persistence.nvim | 会话管理（LazyVim 内置） |
