# Maintainer: Emil <emil@example.com>
pkgname=undo
pkgver=0.2.0
pkgrel=1
pkgdesc="Rückgängig für Linux-Befehle – zeichnet Filesystem-Änderungen auf und macht sie per interaktiver Abfrage rückgängig"
arch=('any')
url="https://github.com/anomalyco/undo"
license=('MIT')
depends=('bash' 'coreutils' 'findutils' 'grep' 'gawk')
optdepends=('fzf: interaktive Fuzzy-Auswahl beim Rückgängig machen')
# Für AUR: Quellen von GitHub Release – damit muss das Projekt NICHT lokal liegen
# Nach jedem Version-Bump: updpkgsums ausführen!
source=("$pkgname-$pkgver.tar.gz::https://github.com/anomalyco/undo/archive/refs/tags/v$pkgver.tar.gz")
sha256sums=('SKIP')

package() {
    cd "$srcdir/$pkgname-$pkgver"
    install -Dm755 undo "$pkgdir/usr/bin/undo"
    install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
    install -Dm644 README.md "$pkgdir/usr/share/doc/$pkgname/README.md"
}
