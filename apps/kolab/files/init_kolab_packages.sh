#!/bin/bash

function die {
  echo 1>&2 "${1}"
  exit 1
}

if dpkg -l kolab > /dev/null 2>&1 ; then
  echo "$0: kolab already installed, returning"
  exit 0
fi

apt-get update
apt-get install -y expect haveged

BASE=$(cd $(dirname $0) && pwd)

if [[ ! -f "~/.gnupg/pubring.gpg" || $(stat "~/.gnupg/pubring.gpg" -c '%s') == "0" ]] ; then

  gpg --batch --gen-key <<EOF
%echo Generating a basic OpenPGP key
Key-Type: DSA
Key-Length: 1024
Subkey-Type: ELG-E
Subkey-Length: 1024
Name-Real: kolab
Expire-Date: 0
%commit
%echo done
EOF

fi

${BASE}/kolab_gpg.sh || die "Error running kolab_gpg.sh"

gpg --export --armor devel@lists.kolab.org | apt-key add - || die "Error exporting Kolab GPG key"

echo "deb http://obs.kolabsys.com/repositories/Kolab:/3.4/Ubuntu_14.04/ ./
deb http://obs.kolabsys.com/repositories/Kolab:/3.4:/Updates/Ubuntu_14.04/ ./" \
  > /etc/apt/sources.list.d/kolab.list

echo "Package: *
Pin: origin obs.kolabsys.com
Pin-Priority: 501" \
  > /etc/apt/preferences.d/kolab

export DEBIAN_FRONTEND=noninteractive

apt-get update
