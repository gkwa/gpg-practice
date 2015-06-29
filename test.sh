#!/bin/sh

rm -rf gnupg
mkdir -p gnupg

eval $(gpg-agent --verbose --daemon)

cat <<'__EOT__' >batch.txt
%echo Generating a basic OpenPGP key
Key-Type: DSA
Key-Length: 2048
Subkey-Type: ELG-E
Subkey-Length: 2048
Name-Real: M. Taylor Monacelli
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

gpg --gen-key --homedir=gnupg --batch batch.txt

# generage revoke.asc  manual
# gpg --output revoke.asc --gen-revoke taylormonacelli@gmail.com
gpg --status-fd 2 --command-fd 0 --gen-revoke --homedir=gnupg --output revoke.asc taylormonacelli@gmail.com

# https://www.gnupg.org/gph/en/manual/x56.html
gpg --homedir=gnupg --output taylor.gpg --export taylormonacelli@gmail.com
gpg --homedir=gnupg --armor --export taylormonacelli@gmail.com

gpg --homedir=gnupg --list-keys
