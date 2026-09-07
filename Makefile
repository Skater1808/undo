PREFIX ?= /usr
BINDIR ?= $(PREFIX)/bin
DATADIR ?= $(PREFIX)/share

install:
	install -Dm755 undo $(DESTDIR)$(BINDIR)/undo
	install -Dm644 LICENSE $(DESTDIR)$(DATADIR)/licenses/undo/LICENSE
	install -Dm644 README.md $(DESTDIR)$(DATADIR)/doc/undo/README.md

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/undo
	rm -rf $(DESTDIR)$(DATADIR)/licenses/undo
	rm -rf $(DESTDIR)$(DATADIR)/doc/undo

test:
	./tests/test.sh

.PHONY: install uninstall test
