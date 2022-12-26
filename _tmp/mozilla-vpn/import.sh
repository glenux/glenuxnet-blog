#!/bin/bash
#
# Wireguard importer script for NetworkManager
#
# Author: Glenn Y. Rolland
# SPDX-License-Identifier: MIT
#
# vim: set ts=2 sw=2 et:

set -ue

CNX_LIST="$(mktemp)"
CNX_DETAILS="$(mktemp)"
WIREGUARD_PROVIDER="${1:-}"
WIREGUARD_CONFIG_DIR="${2:-}"

mozimport_usage() {
  >&2 echo "Usage: $(basename "$0") PROVIDER CONFIG_DIR"
  >&2 echo ""
}

if [ -z "$WIREGUARD_PROVIDER" ]; then
  mozimport_usage
  >&2 echo "ERROR: missing PROVIDER argument!"
  >&2 echo ""
  exit 1
fi

if [ -z "$WIREGUARD_CONFIG_DIR" ]; then
  mozimport_usage
  >&2 echo "ERROR: missing CONFIG_DIR argument!"
  >&2 echo ""
  exit 1
fi

if [ ! -d "$WIREGUARD_CONFIG_DIR" ]; then
  mozimport_usage
  >&2 echo "ERROR: CONFIG_DIR must be a directory!"
  >&2 echo ""
  exit 1
fi

if ! $SHELL --version 2>&1 |grep -q '^GNU bash' ; then
  >&2 echo "ERROR: this script must be run with the GNU bash shell!"
  >&2 echo ""
  exit 1
fi

LANG=C nmcli --fields UUID,NAME connection show > "$CNX_LIST"
echo "import: built connection cache."

find /etc/wireguard -name "*.conf" -print0 | sort -z | while IFS= read -r -d '' file
do
  NAME="$(basename -s .conf "$file")"
  UUID=""
  UUID_COUNT=0
  IMPORT_ENABLE=0

  echo "$NAME: detecting connection..."
  if grep -q "$NAME" < "$CNX_LIST"; then
    UUID="$( awk "/$NAME/ { print \$1; }" < "$CNX_LIST" )"
    UUID_COUNT="$(echo "$UUID" |wc -l)"
  fi

  if [ "$UUID_COUNT" -gt "1" ]; then
    echo "$NAME: multiple connections found."
    for UUID_SINGLE in $UUID ; do
      nmcli connection delete uuid "$UUID_SINGLE" >/dev/null 2>&1
    done
    IMPORT_ENABLE=1
  elif [ "$UUID_COUNT" -eq "1" ]; then
    echo "$NAME: existing connection found: UUID=$UUID."
  else
    echo "$NAME: no connection found."
    IMPORT_ENABLE=1
  fi

  if [ "$IMPORT_ENABLE" -eq "1" ]; then
    UUID="$( LANG=C nmcli connection import type wireguard file "$file" 2>/dev/null \
             | sed 's/^.*(\(.*\)).*$/\1/' )"
    if [ -n "$UUID" ]; then
      echo "$NAME: imported configuration file as UUID=$UUID."
    else
      >&2 echo "ERROR: no UUID found!"
      exit 1
    fi
  fi

  LANG=C nmcli connection show uuid "$UUID" > "$CNX_DETAILS"
  echo "$NAME: cache & test connection details."
  if grep -q '^connection.autoconnect:.*yes' < "$CNX_DETAILS" ; then
    nmcli connection modify uuid "$UUID" connection.autoconnect 0
    echo "$NAME: modify: disabled autoconnect."
  fi

  if ! grep -q "^connection.id:  *$WIREGUARD_PROVIDER ($NAME)$"  < "$CNX_DETAILS" ; then
    nmcli connection modify uuid "$UUID" connection.id "$WIREGUARD_PROVIDER ($NAME)"
    echo "$NAME: modify: renamed connection to '$WIREGUARD_PROVIDER ($NAME)'."
  fi
  rm -f "$CNX_DETAILS"

  if nmcli --fields UUID,ACTIVE connection | grep -q "$UUID.*yes" ; then
    nmcli connection down uuid "$UUID" >/dev/null 2>&1
    echo "$NAME: disconnected."
  fi
done

rm -f "$CNX_LIST"
echo "import: done."

