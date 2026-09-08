# undo

Automatically tracks filesystem changes from shell commands and lets you undo them.

> `rm important.txt` → `undo` → file is back.

## Install

```bash
bash <(curl -sL https://raw.githubusercontent.com/Skater1808/undo/master/install.sh)
```

This downloads `undo` to `~/.local/bin/` and adds the hook to your shell config.

Then restart your shell:

```bash
source ~/.bashrc   # or ~/.zshrc
```

### What the installer does

- Downloads `undo` to `~/.local/bin/undo`
- Adds `eval "$(undo --hook)"` to your `.bashrc` or `.zshrc`
- No sudo required

## Usage

```bash
# Just use your shell normally — everything is tracked
rm important.txt
mv file /tmp/
cp -r backup/ /home/

# Undo something
undo              # show last 10 commands, pick one
undo 3            # undo #3 directly
undo --last       # undo last command
undo list 20      # show last 20 commands
undo clear        # clear history
```

## Examples

```bash
# Deleted the wrong file
rm -rf ~/projects/important/
undo               # pick #1, file is back

# Moved a file to the wrong place
mv ~/docs/report.pdf /tmp/
undo               # file restored

# Multiple mistakes
rm file1.txt
mv file2.txt /tmp/
cp -r data/ /tmp/backup/
undo               # pick which one to undo
```

## Smart undo (command-aware)

For known commands, `undo` uses the idiomatic rollback instead of raw file restore:

| command                | undo does                                       |
|------------------------|-------------------------------------------------|
| `git commit`           | `git reset --soft HEAD~1`; if the commit is already pushed: menu (local reset / force-push / `git revert`) |
| `pacman/yay -S …`      | `pacman -Rns <pkgs>` (upgrades like `-Syu` are left to generic) |
| `apt/dnf install …`    | `apt/dnf remove -y <pkgs>`                      |
| `pip install …`        | `pip uninstall -y <pkgs>`                       |
| `npm/pnpm/yarn add …`  | `npm/pnpm/yarn uninstall <pkgs>`                |
| `systemctl enable/…`   | inverse action (`disable`, `stop`, `unmask`, …) |
| everything else        | generic file restore (default)                  |

All destructive handler actions ask for confirmation; force-push refuses when there is no terminal. Disable smart undo with `UNDO_SMART=0 undo …`.

## How it works

1. **Before each command**: snapshot working directory + backup all file contents
2. **After each command**: compare snapshots, detect changes (CREATE/DELETE/MODIFY)
3. **`undo`**: restore from backups — deleted files reappear, created files removed, modified files revert

Data stored in `~/.undo/` (configurable via `UNDO_DIR`).

## Requirements

- bash or zsh
- `curl` (for install only)
- Optional: `fzf` for fuzzy finder UI

## License

MIT
