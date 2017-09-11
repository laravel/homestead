#!/usr/bin/env bash

mkdir /etc/nginx/ssl 2>/dev/null

PATH_SSL="/etc/nginx/ssl"
PATH_CSR="${PATH_SSL}/${1}.csr"
PATH_req_CNF="${PATH_SSL}/${1}_req.cnf"
PATH_x509_CNF="${PATH_SSL}/${1}_x509.cnf"
PATH_KEY="${PATH_SSL}/${1}.key"
PATH_CRT="${PATH_SSL}/${1}.crt"

# Only generate a certificate if there isn't one already there.
if [ ! -f $PATH_req_CNF ] || [ ! -f $PATH_x509_CNF ] || [ ! -f $PATH_KEY ] || [ ! -f $PATH_CRT ]
then

    # Uncomment the global 'copy_extentions' OpenSSL option to ensure the SANs are copied into the certificate.
    sed -i '/copy_extensions\ =\ copy/s/^#\ //g' /etc/ssl/openssl.cnf

    # Generate an OpenSSL configuration file specifically for this certificate.
    if [ $# -gt 1 ]
    then
      block_req="
          [ req ]
          prompt = no
          default_bits = 2048
          default_md = sha256
          distinguished_name = req_distinguished_name

          [ req_distinguished_name ]
          O=Vagrant
          C=UN
          CN=$1
      "
      echo "$block_req" > $PATH_req_CNF

      block_x509="
          authorityKeyIdentifier=keyid,issuer
          basicConstraints=CA:FALSE
          keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
          subjectAltName = @alt_names

          [alt_names]
          DNS.1 = $1
      "
      echo "$block_x509" > $PATH_x509_CNF


      # First generate a new certificate request and private key
      openssl req -new -sha256 -nodes -out "$PATH_CSR" -newkey rsa:2048 -keyout "$PATH_KEY" -config $PATH_req_CNF 2>/dev/null
      # Finally generate and sign a new certificate
      openssl x509 -req -in "$PATH_CSR" -CA $2 -CAkey $3 -CAcreateserial -out "$PATH_CRT" -days 3650 -sha256 -extfile $PATH_x509_CNF 2>/dev/null
      rm $PATH_CSR
    else
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
      echo "$block" > $PATH_req_CNF

      openssl genrsa -out "$PATH_KEY" 2048 2>/dev/null
      openssl req -new -x509 -config "$PATH_req_CNF" -out "$PATH_CRT" -days 365 2>/dev/null
    fi

fi
