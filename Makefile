.PHONY: update
update:
	nix flake update

.PHONY: system
system:
	sudo nixos-rebuild switch --flake .

.PHONY: home
home:
	home-manager switch --flake .
