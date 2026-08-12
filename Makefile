.PHONY: update
update:
	nix flake update

.PHONY: system
system:
	nh os switch

.PHONY: home
home:
	nh home switch

.PHONY: check
check:
	nix flake check

.PHONY: fmt
fmt:
	nix fmt

.PHONY: clean
clean:
	nh clean all --keep 5 --keep-since 14d
