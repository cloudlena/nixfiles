.PHONY: update
update:
	nix flake update

.PHONY: system
system:
	nh os switch

.PHONY: home
home:
	nh home switch

.PHONY: clean
clean:
	nh clean all --keep 5 --keep-since 14d
