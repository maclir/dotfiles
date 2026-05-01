.DEFAULT_GOAL := install

# Each top-level dir is a stow package — except direnv/ (targets live
# outside $HOME, see `direnv` below) and bin/ (scripts, not config).
PACKAGES := $(filter-out direnv/ bin/,$(sort $(dir $(wildcard */))))
DIRENV_FILES := $(shell find direnv -name '.envrc' 2>/dev/null)

.PHONY: install uninstall update pull bootstrap direnv brew dump-brew

install:
	stow -t ~ $(PACKAGES)

uninstall:
	stow -Dt ~ $(PACKAGES)

update: pull install

pull:
	git pull

bootstrap:
	./bin/bootstrap.sh

# Symlink direnv .envrc files into their real locations under ~/code/...
# (stow can't help — these targets live outside $HOME).
direnv:
	@for f in $(DIRENV_FILES); do \
	  target=$$HOME/$${f#direnv/}; \
	  mkdir -p $$(dirname $$target); \
	  ln -snf $(CURDIR)/$$f $$target; \
	  echo "linked $$target — run: direnv allow $$(dirname $$target)"; \
	done

brew:
	brew bundle --file ./Brewfile

dump-brew:
	brew bundle dump --force --describe --file ./Brewfile
