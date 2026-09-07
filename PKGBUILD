# Maintainer: skater1808 <skater1808@github.com>
pkgname=undo
pkgver=0.2.0
pkgrel=1
pkgdesc="Rückgängig für Linux-Befehle – zeichnet Filesystem-Änderungen auf und macht sie per interaktiver Abfrage rückgängig"
arch=('any')
url="https://github.com/skater1808/undo"
license=('MIT')
depends=('bash' 'coreutils' 'findutils' 'grep' 'gawk')
optdepends=('fzf: interaktive Fuzzy-Auswahl beim Rückgängig machen')
# Für AUR: Quellen von GitHub Release – damit muss das Projekt NICHT lokal liegen
# Nach jedem Version-Bump: updpkgsums ausführen!
source=("$pkgname-$pkgver.tar.gz::https://github.com/skater1808/undo/archive/refs/tags/v$pkgver.tar.gz")
sha256sums=('08b9916411fd9fec1b0f688abbe0eea63b7e7129e53f7febeaf2fab11339f2d0')

package() {
    cd "$srcdir/$pkgname-$pkgver"
    install -Dm755 undo "$pkgdir/usr/bin/undo"
    install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
    install -Dm644 README.md "$pkgdir/usr/share/doc/$pkgname/README.md"
}
