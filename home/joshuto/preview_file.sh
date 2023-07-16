#!/usr/bin/env bash

IFS=$'\n'

# Security measures:
# * noclobber prevents you from overwriting a file with `>`
# * noglob prevents expansion of wild cards
# * nounset causes bash to fail if an undeclared variable is used (e.g. typos)
# * pipefail causes a pipeline to fail also if a command other than the last one fails
set -o noclobber -o noglob -o nounset -o pipefail

file_path=""
preview_width=10
preview_height=10

while [ "$#" -gt 0 ]; do
	case "$1" in
	"--path")
		shift
		file_path="$1"
		;;
	"--preview-width")
		shift
		preview_width="$1"
		;;
	"--preview-height")
		shift
		preview_height="$1"
		;;
	esac
	shift
done

handle_extension() {
	case "${file_extension_lower}" in
	## Archive
	zip)
		## Avoid password prompt by providing empty password
		unzip -l "${file_path}" && exit 0
		exit 1
		;;

		## PDF
	pdf)
		## Preview as text conversion
		pdftotext -l 10 -nopgbrk -q -- "${file_path}" - |
			fmt -w "${preview_width}" && exit 0
		exit 1
		;;
	esac
}

handle_mime() {
	local mimetype="${1}"

	case "${mimetype}" in
	## Text
	text/* | */xml | */json | */yaml)
		bat --color=always --paging=never \
			--style=plain \
			--terminal-width="${preview_width}" \
			"${file_path}" && exit 0
		cat "${file_path}" && exit 0
		exit 1
		;;

		## Image
	image/*)
		chafa "${file_path}" && exit 0
		exit 1
		;;
	esac
}

file_extension="${file_path##*.}"
file_extension_lower="$(printf "%s" "${file_extension}" | tr '[:upper:]' '[:lower:]')"
handle_extension
mimetype="$(file --dereference --brief --mime-type -- "${file_path}")"
handle_mime "${mimetype}"

exit 1
