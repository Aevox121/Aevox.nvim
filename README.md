# Aevox.nvim

个人 LazyVim 配置，基于 [LazyVim](https://www.lazyvim.org/) starter 模板定制。

## 特色

- **[leap-pinyin.nvim](https://github.com/Aevox121/leap-pinyin.nvim)** — 中文拼音跳转（默认小鹤双拼），`s` 前跳、`S` 后跳；`flash.nvim` 的同名映射已禁用
- **[ch-ime.nvim](https://github.com/Aevox121/ch-ime.nvim)** — Normal/Insert 切换时自动切换 Windows 输入法
- **[four-claude](https://github.com/Aevox121/four-claude)** — 终端内 4 分屏管理 Claude Code 会话（`<leader>C` 开关、`<leader>cp` pin 到侧栏）
- **[obsidian-link.nvim](https://github.com/Aevox121/obsidian-link.nvim)** — 在 markdown buffer 里跟随 `[[wikilink]]` 跳转
- snacks picker 的 projects 源扩展到 `D:/Projects` + `D:/Work`，选中自动 `tcd` + 恢复 persistence session
- Python: pyright + ruff（nvim-lint）+ ruff format（conform.nvim）
- Markdown: render-markdown.nvim 编辑器内渲染

## 目录结构

```
lua/
  config/        LazyVim 标配：lazy / options / keymaps / autocmds
  plugins/       插件 spec，每个文件聚焦一个主题
init.lua         入口
lazy-lock.json   插件版本锁定
```

## 安装

这是个人配置，不是通用 starter。拉下来直接用的话：

```bash
git clone https://github.com/Aevox121/Aevox.nvim ~/AppData/Local/nvim   # Windows
git clone https://github.com/Aevox121/Aevox.nvim ~/.config/nvim          # macOS / Linux
```

其中 `lua/plugins/four-claude.lua` 与 `leap-pinyin.lua` 使用本地 `dir = "D:/..."` 路径，换机器需改成 `Aevox121/<repo>` 的远程形式。

## 同步工作流

仓库的实际工作副本不在仓库目录里，而是在 Neovim 的标准 config 路径（Windows 下的 `C:/Users/<you>/AppData/Local/nvim/`）。仓库提供 `sync.sh` 做双向同步：

```bash
# 把 AppData 改动拉进仓库，准备提交
bash sync.sh push
git add <files> && git commit && git push

# 拉到远端更新后写回 AppData
git pull && bash sync.sh pull
```

`sync.sh` 会跳过 `.git`、`.claude`、`sync.sh` 自身。

## License

与 LazyVim 保持一致，见 `LICENSE`。
