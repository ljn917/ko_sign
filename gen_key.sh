# https://www.kernel.org/doc/html/v5.8/admin-guide/module-signing.html
# https://ubuntu.com/blog/how-to-sign-things-for-secure-boot
# https://forums.fedoraforum.org/showthread.php?300228-Module-signing-with-a-custom-key-how-do-you-do-it

openssl req -new -nodes -utf8 -sha256 -days 36500 -batch -x509 -config x509.genkey -outform DER -out signing_key.x509 -keyout signing_key.priv

# secure your keys
chmod 0400 ${CERT} ${KEY}

# install key into shim
mokutil --root-pw --import signing_key.x509

# check staged key
mokutil -N

# reboot
sudo cat /proc/keys | grep asymmetri

# keyctl padd asymmetric "" [.builtin_trusted_keys-ID] <[key-file]
# keyctl padd asymmetric "" 0x223c7853 < kernel_key.x509
