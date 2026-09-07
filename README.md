# undo

Ein Linux-Command-Line-Tool, das die Filesystem-Änderungen eines Befehls aufzeichnet, damit sie per **`undo` mit interaktiver Abfrage** rückgängig gemacht werden können.

> `undo run <befehl>` → `undo` → auswählen welcher Befehl rückgängig gemacht werden soll.

## Installation

### AUR (Arch Linux / Omarchy)

```bash
# mit yay
yay -S undo

# mit paru
paru -S undo

# manuell aus diesem Repo
makepkg -si
# oder: makepkg --printsrcinfo > .SRCINFO  # für AUR-Upload
```

Paket: [`PKGBUILD`](PKGBUILD) – hängt nur von `bash`, `coreutils`, `findutils` ab, optional `fzf` für Fuzzy-Auswahl.

### Flatpak

```bash
# lokal bauen & installieren (erfordert flatpak-builder)
flatpak-builder --user --install build-dir flatpak/io.github.anomalyco.undo.json

# danach als CLI nutzen (braucht host-Zugriff):
flatpak run --filesystem=host io.github.anomalyco.undo run rm -rf /tmp/mydir
flatpak run --filesystem=host io.github.anomalyco.undo
# Alias empfohlen:
alias undo='flatpak run --filesystem=host io.github.anomalyco.undo'
```

Oder aus Flathub (nach Veröffentlichung):
```bash
flatpak install flathub io.github.anomalyco.undo
```

### Manuell / ohne Paketmanager

```bash
sudo make install          # nach /usr/bin
# oder
ln -sf "$PWD/undo" ~/.local/bin/undo
```

## Verwendung

```bash
undo run <befehl>   # Befehl ausführen und Änderungen verfolgen
undo                # interaktive Abfrage: welchen Befehl rückgängig machen?
undo --last         # direkt den letzten Befehl rückgängig (ohne Abfrage)
undo 2              # direkt Nr. 2 aus der Liste rückgängig
undo list           # Verlauf anzeigen
undo clear          # Verlauf löschen
undo --version      # Version
undo -h             # Hilfe
```

### Interaktive Abfrage

Rufst du `undo` ohne Argumente auf, siehst du:

```
Welchen Befehl rückgängig machen?

  [1] 2026-09-07 14:30:00  rm -rf /tmp/mydir  (5 change(s))  <- neuester
  [2] 2026-09-07 14:28:12  mv file.txt /tmp/   (2 change(s))
  [3] 2026-09-07 14:27:05  cp backup/ /tmp/    (1 change(s))

Auswahl [1-3, q=Abbruch, Enter=1]: 2
Wirklich rückgängig machen? [j/N]: j
  restoring deleted: file.txt
Done.
```

- Mit **`fzf`** installiert: Fuzzy-Finder statt nummerierter Liste (automatisch erkannt).
- Ohne `fzf`: nummerierte Liste mit `read`.
- Per Pipe / Script: `printf '2\n' | undo` oder `undo --last` für Automation.

## Beispiele

```bash
# Löschen → interaktiv wiederherstellen
undo run rm -rf /tmp/mydir
undo   # -> Abfrage, auswählen

# Mehrere Befehle, gezielt einen rückgängig
undo run rm /tmp/a.txt
undo run cp -r data/ /tmp/backup/
undo run mv file.txt /tmp/
undo list
# [1] mv file.txt /tmp/
# [2] cp -r data/ /tmp/backup/
# [3] rm /tmp/a.txt
undo 2   # nur den cp rückgängig

# Schnell letzten rückgängig ohne Abfrage
undo --last
```

## Funktionsweise

1. **Vorher-Snapshot** der betroffenen Verzeichnisse + Backup aller Dateien.
2. **Befehl ausführen**.
3. **Nachher-Snapshot** + Differenz (CREATE / DELETE / MODIFY).
4. **Undo-Eintrag** in `~/.undo/` (per `UNDO_DIR` überschreibbar).
5. Bei `undo` wird je nach Auswahl: neue Dateien entfernt, modifizierte zurückgesetzt, gelöschte wiederhergestellt.

## Einschränkungen

- Tiefe 10 unter den betroffenen Pfaden.
- Absolute Pfade werden bevorzugt verfolgt; relative über das CWD.
- Sehr breites Tracking (z. B. `/tmp` direkt) erfasst viele Änderungen – gezielte Unterverzeichnisse angeben.
- Eigenes State-Verzeichnis (`~/.undo/`) wird von Snapshots ausgeschlossen.
