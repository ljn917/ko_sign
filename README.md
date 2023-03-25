# Generate a key and enroll it

The process is documented in `gen_key.sh`. `env.sh` needs to be created first. `KEY` and `CERT` are needed here. You are also recommended to change the `req_distinguished_name` section in `x509.genkey`.

# Sign kernel modules

Define modules to be signed in `env.sh`, where an example is `env.sh.example`. Then, run

```
sudo ./ko_sign.sh

# or interative mode
sudo ./ko_sign.sh -i
```

# Utility

## Check keys in use

```
sudo keyctl list %:.builtin_trusted_keys
sudo mokutil --db
sudo cat /proc/keys | grep asymmetri
```

## Check if secure-boot is enabled

```
sudo mokutil --sb-state
```

## Export certificates of all enrolled keys

```
sudo mokutil --export
```

## List enrolled keys

```
sudo mokutil --list-enrolled
```

## Delete a key (requires its der certificate)

```
mokutil --delete MOK-0001.der
```

## Delete all keys

```
sudo mokutil --reset
```

## Check if a kernel module is signed

```
sudo modinfo KO_NAME
```

# Auto-compiling tools

## akmods (`kmodgenca`)

- https://blog.monosoul.dev/2022/05/17/automatically-sign-nvidia-kernel-module-in-fedora-36/
- https://rpmfusion.org/Howto/Secure%20Boot

## DKMS

- https://wiki.debian.org/SecureBoot#Making_DKMS_modules_signing_by_DKMS_signing_key_usable_with_the_secure_boot

# Docs

- <https://docs.fedoraproject.org/en-US/fedora/f34/system-administrators-guide/kernel-module-driver-configuration/Working_with_Kernel_Modules/#sect-signing-kernel-modules-for-secure-boot>
- <https://www.kernel.org/doc/html/v5.8/admin-guide/module-signing.html>
