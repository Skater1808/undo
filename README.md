# undo

Automatically tracks filesystem changes from shell commands and lets you undo them.

> Run any command → `undo` → pick which one to reverse.

**No prefix needed.** Just add `eval "$(undo --hook)"` to your shell config.

## Setup

```bash
# Add to ~/.bashrc or ~/.zshrc:
eval "$(undo --hook)"

# Or for zsh:
echo 'eval "$(undo --hook)"' >> ~/.zshrc
```

Then restart your shell or run `source ~/.bashrc`.

## Usage

```bash
# Just use your shell normally — commands are tracked automatically
rm important.txt
mv file /tmp/
cp -r backup/ /home/

# See what happened and undo
undo              # shows last 10 commands, pick one to undo
undo 3            # undo command #3 directly
undo --last       # undo the last command
undo list 20      # show last 20 commands
undo clear        # clear history
```

## Install

```bash
# Direct install
curl -sL https://github.com/Skater1808/undo/releases/download/v0.2.0/undo -o ~/.local/bin/undo
chmod +x ~/.local/bin/undo

# Or symlink
ln -sf "$PWD/undo" ~/.local/bin/undo
```

## Examples

```bash
# Oops, deleted the wrong file
rm -rf ~/projects/important/
undo               # see "rm -rf ~/projects/important/", pick #1, done

# Moved a file to the wrong place
mv ~/docs/report.pdf /tmp/
undo               # file is back

# Multiple mistakes
rm file1.txt
mv file2.txt /tmp/
cp -r data/ /tmp/backup/
undo               # pick which one to undo
```

## How it works

1. **Before each command**: snapshot the working directory + backup all file contents
2. **After each command**: compare snapshots, detect changes (CREATE/DELETE/MODIFY)
3. **`undo` command**: restore from backups — deleted files reappear, created files are removed, modified files revert

All data stored in `~/.undo/` (configurable via `UNDO_DIR`).

## Limitations

- Tracks changes in the current working directory (recursive, depth 8)
- Very large directories may slow down the snapshot
- `~/.undo/` is excluded from snapshots (no self-referential changes)
- Works with bash and zsh

## Version

```
undo --version
```
