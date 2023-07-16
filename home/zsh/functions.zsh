# Create a directory and enter it
mkcd() {
	mkdir --parents "$@" && cd "$_" || exit
}

# Checkout Git branches or tags using fuzzy search
fco() {
	local tags branches target
	tags=$(
		git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}'
	) || return
	branches=$(
		git branch --all | grep -v HEAD |
			sed "s/.* //" | sed "s#remotes/[^/]*/##" |
			sort -u | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}'
	) || return
	target=$(
		(
			echo "$tags"
			echo "$branches"
		) |
			fzf-tmux -l30 -- --no-hscroll --ansi +m -d "\t" -n 2
	) || return
	git checkout "$(echo "$target" | awk '{print $2}')"
}

# Kill any process with fuzzy search
fkill() {
	local pid
	if [ "$UID" != "0" ]; then
		pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
	else
		pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
	fi

	if [ "x$pid" != "x" ]; then
		echo "$pid" | xargs kill "-${1:-9}"
	fi
}

# Git commit browser with fuzzy search
fshow() {
	git log --graph --color=always \
		--format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
		fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
			--bind "ctrl-m:execute:
            (grep -o '[a-f0-9]\{7\}' | head -1 |
            xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
            {}
FZF-EOF"
}

# Update project dependencies
depu() {
	# Git submodules
	if [ -e .gitmodules ]; then
		printf "Updating Git submodules for %s...\n\n" "${PWD##*/}"
		git submodule update --init --remote --rebase --recursive
	fi

	# npm
	if [ -e package-lock.json ]; then
		printf "Updating npm dependencies for %s...\n\n" "${PWD##*/}"
		npm update
		npm outdated
	fi

	# Go
	if [ -e go.mod ]; then
		printf "Updating Go dependencies for %s...\n\n" "${PWD##*/}"
		go get -t -u ./...
		go mod tidy
	fi

	# Rust
	if [ -e Cargo.toml ]; then
		printf "Updating Cargo dependencies for %s...\n\n" "${PWD##*/}"
		cargo update
	fi

	# Python
	if [ -e poetry.lock ]; then
		printf "Updating Python dependencies for %s...\n\n" "${PWD##*/}"
		poetry update
		poetry show --outdated
	fi

	# Terraform
	if [ -e .terraform.lock.hcl ]; then
		printf "Updating Terraform dependencies for %s...\n\n" "${PWD##*/}"
		terraform init -upgrade
	fi
}
