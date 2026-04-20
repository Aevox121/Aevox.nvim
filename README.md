# Aevox.nvim

个人 LazyVim 配置，基于 [LazyVim](https://www.lazyvim.org/) starter 模板定制。

## 自研插件集成

| 插件 | 作用 | 主要键位 |
|---|---|---|
| [leap-pinyin.nvim](https://github.com/Aevox121/leap-pinyin.nvim) | 中文拼音跳转（默认小鹤双拼，`s`/`S` 同时匹配英文和中文） | `s` 前跳，`S` 后跳（`flash.nvim` 同名映射已禁用） |
| [ch-ime.nvim](https://github.com/Aevox121/ch-ime.nvim) | 进出 Insert 模式时自动切换 Windows 输入法 | `<leader>ui` 开关 |
| [four-claude](https://github.com/Aevox121/four-claude) | 终端内 4 分屏同时管理 Claude Code 会话 | `<leader>C` 开关、`<leader>cp` pin 侧栏 |
| [obsidian-link.nvim](https://github.com/Aevox121/obsidian-link.nvim) | 在 Markdown buffer 跟随 `[[wikilink]]` 跳转 | `:ObsidianFollow` |

## 其他定制

- **snacks picker** — `projects` 源扩展到 `D:/Projects` + `D:/Work`，选中自动 `tcd` 并恢复对应 persistence session
- **Python 栈** — `pyright`（LSP）+ `ruff`（nvim-lint 静态检查）+ `ruff_format`（conform.nvim 格式化）
- **Markdown** — `render-markdown.nvim` 编辑器内渲染，treesitter 安装 `markdown` / `markdown_inline` parser
- **Telescope** — 固定 `v0.2.1` + `fzf-native` 加速
- **mini.ai** — 扩展 text object

## 目录结构

```
lua/
  config/        LazyVim 标配：lazy / options / keymaps / autocmds
  plugins/       插件 spec，一个主题一个文件
init.lua         入口
lazy-lock.json   插件版本锁定
lazyvim.json     LazyVim extras 清单
```

## 相关仓库

本仓库引用的 4 个自研插件独立开源：

- <https://github.com/Aevox121/leap-pinyin.nvim>
- <https://github.com/Aevox121/ch-ime.nvim>
- <https://github.com/Aevox121/four-claude>
- <https://github.com/Aevox121/obsidian-link.nvim>

## License

与 LazyVim 保持一致，见 `LICENSE`。
