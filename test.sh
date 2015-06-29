#!/bin/sh

rm -rf gnupg
mkdir -p gnupg

eval $(gpg-agent --verbose --daemon)


cat <<'__EOT__' >auto.txt
%echo Generating a basic OpenPGP key
Key-Type: DSA
Key-Length: 1024
Subkey-Type: ELG-E
Subkey-Length: 1024
Name-Real: Taylor Monacelli
Name-Comment: with stupid passphrase
Name-Email: taylormonacelli@gmail.com
Expire-Date: 1
Passphrase: abc
#%pubring pubring.gpg
#%secring secring.gpg
# Do a commit here, so that we can later print "done" :-)
%commit
%echo done
__EOT__

chmod -R go-rwx gnupg

gpg --gen-key --homedir=gnupg --batch auto.txt

# generage revoke.asc  manual
# gpg --output revoke.asc --gen-revoke tailor@u.washington.edu
# gpg --status-fd 2 --command-fd 0 --gen-revoke --homedir=gnupg --output revoke.asc tailor@u.washington.edu

# https://www.gnupg.org/gph/en/manual/x56.html
gpg --output taylor.gpg --export tailor@u.washington.edu
gpg --armor --export tailor@u.washington.edu
