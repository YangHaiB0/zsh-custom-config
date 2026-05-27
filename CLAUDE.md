# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是用户的 oh-my-zsh 自定义配置仓库（`~/.oh-my-zsh/custom`）。主要包含用户自用的 shell 脚本工具、别名配置、主题和插件。

## 代码结构

### 用户自建脚本（根目录）

这些 .zsh 文件由 oh-my-zsh 按字母顺序自动加载：

| 文件 | 用途 |
|------|------|
| `custom.zsh` | 别名（vim→nvim, colorls 替代 ls, zshrc 快捷操作等）和 zsh 历史配置 |
| `common.zsh` | 通用工具函数：`success/error/warn/info` 日志打印、`confirm` 确认、`check_command` 命令检查、`run_command` 执行、`write_to_file` 写入、`read_input` 读取用户输入 |
| `proxy.zsh` | 代理开关函数：`on()` / `off()`（Clash Verge）、`on_hd()`（横店代理）、`on_surge()` |
| `update_latest_images.zsh` | Docker latest 镜像批量更新函数 `update_latest_images` |
| `clean_mvn_repository.zsh` | Maven 仓库清理函数 `clean_mvn_repository`（支持选择清理 *.lastUpdated、*.part、空目录等） |
| `gen_docker_log_cmd.zsh` | Docker 日志查询命令生成器 `gen_docker_log_cmd`/`gen_docker_log_cmd_args`（交互式/非交互式） |

### 插件

- `plugins/zsh-autosuggestions/` — 第三方，命令自动建议
- `plugins/zsh-syntax-highlighting/` — 第三方，命令语法高亮
- `plugins/zsh-completions/` — 第三方，额外补全定义
- `plugins/orb/orb.plugin.zsh` — 用户修改版，为 Orbstack 添加命令补全
- `plugins/zsh-ollama-command/` — 自定义插件，接入 Ollama AI 命令补全

### 主题

- `themes/powerlevel10k/` — 第三方，完整克隆的 p10k 主题

## 设计约定

- 所有用户自定义的函数和别名都以用户体验为优先，支持交互式提示（`read_input` / `confirm`）
- 日志统一使用 `common.zsh` 中的色彩函数：绿色=成功，红色=错误，黄色=警告，青色=信息
- 函数命名：动词开头、小写+下划线（如 `clean_mvn_repository`、`gen_docker_log_cmd`）
- 代理函数名简短（`on`/`off`），作为日常快捷命令而非描述性名称

## 常用操作

- 重新加载配置：`source ~/.zshrc`
- 编辑自定义配置：`zshrc-custom-edit`（别名，对应 `nvim ~/.oh-my-zsh/custom/custom.zsh`）

## Git 说明

- 用户自建文件（根目录 .zsh）和自定义插件（如 zsh-ollama-command）受版本控制
- 第三方插件和主题作为 git submodule 或独立克隆管理，各有自己的 .git
