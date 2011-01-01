#!/bin/sh

set -e

_DIRECTORY="${1:-/lib/live/config}"

if [ ! -e "${_DIRECTORY}" ]
then
	echo "E: ${_DIRECTORY} - not found."
	exit 1
fi

if [ ! -x "$(which lsb_release 2>/dev/null)" ]
then
	echo "E: lsb_release - command not found"
	echo "I: lsb_release can be optained from:"
	echo "I:   http://www.linux-foundation.org/en/LSB"
	echo "I: On Debian systems, lsb_release can be installed with:"
	echo "I:   apt-get install lsb-release"
	exit 1
fi

_DISTRIBUTION="$(lsb_release -is | tr [A-Z] [a-z])"
_RELEASE="$(lsb_release -cs | tr [A-Z] [a-z])"

echo "Removing unused scripts..."

case "${_DISTRIBUTION}" in
	debian|progress)
		# Removing ubuntu scripts
		rm -f "${_DIRECTORY}"/*-apport
		rm -f "${_DIRECTORY}"/*-ureadahead
		;;

	ubuntu)
		# Removing debian scripts
		rm -f "${_DIRECTORY}"/*-gdm3
		;;
esac

echo "Setting distribution specific defaults..."

case "${_DISTRIBUTION}" in
	debian)
		LIVE_HOSTNAME="debian"
		LIVE_USERNAME="user"
		LIVE_USER_FULLNAME="Debian Live user"
		;;

	progress)
		LIVE_HOSTNAME="progress"
		LIVE_USERNAME="user"
		LIVE_USER_FULLNAME="Progress Linux user"
		;;

	ubuntu)
		LIVE_HOSTNAME="ubuntu"
		LIVE_USERNAME="user"
		LIVE_USER_FULLNAME="Ubuntu Live user"
		;;
esac

sed -i  -e "s|^LIVE_HOSTNAME=.*$|LIVE_HOSTNAME=\"${LIVE_HOSTNAME}\"|" \
	-e "s|^LIVE_USERNAME=.*$|LIVE_USERNAME=\"${LIVE_USERNAME}\"|" \
	-e "s|^LIVE_USER_FULLNAME=.*$|LIVE_USER_FULLNAME=\"${LIVE_USER_FULLNAME}\"|" \
"$(dirname ${_DIRECTORY})/config.sh"
