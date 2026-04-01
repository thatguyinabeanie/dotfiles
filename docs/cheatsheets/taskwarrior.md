# taskwarrior

**Feature-rich terminal todo list**—manage tasks with priorities, due dates, projects, tags, and AI integration.

## 🚀 TUI

| Key | Action |
|-----|--------|
| `Prefix + t` | Open Taskwarrior TUI in tmux popup |

### Inside taskwarrior-tui

| Key | Action |
|-----|--------|
| `j` / `k` | Navigate tasks |
| `a` | Add task |
| `d` | Mark done |
| `e` | Edit task |
| `u` | Undo |
| `q` | Quit |
| `/` | Filter |
| `?` | Show help |

## ⚡ CLI: Quick Add

| Command | Action |
|---------|--------|
| `task add Buy milk` | Add a task |
| `task add Buy milk due:tomorrow` | Add with due date |
| `task add Fix bug pri:H project:work` | Add with priority and project |
| `task add Call dentist +health` | Add with tag |

## 📋 Viewing Tasks

| Command | Action |
|---------|--------|
| `task` | List pending tasks (default view) |
| `task list` | All pending tasks |
| `task all` | All tasks including completed |
| `task next` | Highest priority tasks |
| `task project:work` | Tasks in a project |
| `task +health` | Tasks with a tag |
| `task due:today` | Tasks due today |

## ✅ Managing Tasks

| Command | Action |
|---------|--------|
| `task 1 done` | Complete task 1 |
| `task 1 delete` | Delete task 1 |
| `task 1 modify pri:H` | Change priority |
| `task 1 modify due:friday` | Set due date |
| `task 1 modify project:work` | Assign project |
| `task 1 annotate "note here"` | Add annotation |
| `task undo` | Undo last action |

## 🔢 Priorities

| Value | Meaning |
|-------|---------|
| `pri:H` | High |
| `pri:M` | Medium |
| `pri:L` | Low |
| *(none)* | No priority |

## 📁 Projects & Tags

| Syntax | Example |
|--------|---------|
| `project:NAME` | `project:work` |
| `+TAG` | `+health` |
| `-TAG` | Remove tag |
| `project:` | Remove project |

## 📅 Due Date Shortcuts

| Syntax | Meaning |
|--------|---------|
| `due:today` | Today |
| `due:tomorrow` | Tomorrow |
| `due:friday` | Next Friday |
| `due:eow` | End of week |
| `due:eom` | End of month |
| `due:2026-04-15` | Specific date |

## 💾 Backup & Restore

| Command | Action |
|---------|--------|
| `taskwarrior-backup` | Manual backup (export + push to GitHub) |
| `taskwarrior-restore` | Restore from latest GitHub backup |

Backups run automatically after every task command and weekly via launchd.
