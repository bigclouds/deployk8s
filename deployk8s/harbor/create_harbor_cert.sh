#!/bin/bash

# ca
#openssl genrsa -out ca.key 2048
#openssl req -x509 -new -nodes -sha512 -days 3650 -subj "/C=CN/ST=BJ/L=BJ/O=example/OU=Personal/CN=myregistry.com" -key ca.key -out ca.crt

# key and cert
openssl genrsa -out myregistry.com.key 4096
openssl req -sha512 -new -subj "/C=CN/ST=BJ/L=BJ/O=example/OU=Personal/CN=myregistry.com" -key myregistry.com.key -out myregistry.com.csr
openssl x509 -req -sha512 -days 36500 -extfile v3.ext -CA ca.crt -CAkey ca.key -CAcreateserial -in myregistry.com.csr -out myregistry.com.crt
rm -f myregistry.com.csr ca.srl
