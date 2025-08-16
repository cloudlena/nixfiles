.PHONY: update
update:
	nix flake update

.PHONY: system
system:
	nh os switch

.PHONY: home
home:
	nh home switch
