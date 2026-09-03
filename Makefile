.PHONY: snapshot check bootstrap restore restore-gnome repos

snapshot:
	./scripts/snapshot.sh

check:
	./scripts/check-secrets.sh

bootstrap:
	./scripts/bootstrap.sh

restore:
	./scripts/restore-dotfiles.sh

restore-gnome:
	./scripts/restore-gnome.sh

repos:
	./scripts/clone-repos.sh
