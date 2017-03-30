#!/usr/bin/env bash

mkdir /etc/nginx/ssl 2>/dev/null

PATH_SSL="/etc/nginx/ssl"
PATH_CNF="${PATH_SSL}/${1}.cnf"
PATH_KEY="${PATH_SSL}/${1}.key"
PATH_CRT="${PATH_SSL}/${1}.crt"

# Only generate a certificate if there isn't one already there.
if [ ! -f $PATH_CNF ] || [ ! -f $PATH_KEY ] || [ ! -f $PATH_CRT ]
then

    # Uncomment the global 'copy_extentions' OpenSSL option to ensure the SANs are copied into the certificate.
    sed -i '/copy_extensions\ =\ copy/s/^#\ //g' /etc/ssl/openssl.cnf

    # Generate an OpenSSL configuration file specifically for this certificate.
    block="
        [ req ]
        prompt = no
        default_bits = 2048
        default_keyfile = $PATH_KEY
        encrypt_key = no
        default_md = sha256
        distinguished_name = req_distinguished_name
        x509_extensions = v3_ca

        [ req_distinguished_name ]
        O=Vagrant
        C=UN
        CN=$1

        [ v3_ca ]
        basicConstraints=CA:FALSE
        subjectKeyIdentifier=hash
        authorityKeyIdentifier=keyid,issuer
        keyUsage = nonRepudiation, digitalSignature, keyEncipherment
        subjectAltName = @alternate_names

        [ alternate_names ]
        DNS.1 = $1
    "
    echo "$block" > $PATH_CNF

    # Finally, generate the private key and certificate.
    openssl genrsa -out "$PATH_KEY" 2048 2>/dev/null
    openssl req -new -x509 -config "$PATH_CNF" -out "$PATH_CRT" -days 365 2>/dev/null
fi
