#!/bin/bash

set -e

opcao=$1
SETUP_LOCK_FILE="/samba4/.setup.lock.do.not.remove"


samba4_setup () {
   rm -rf /etc/krb5.conf
   #create domain
   /samba4/bin/samba-tool domain provision --server-role=dc --use-rfc2307 --dns-backend=SAMBA_INTERNAL --realm=$REALM --domain=$DOMAIN  --host-name=samba4 --adminpass=Passw0rd

   #Copiando arquivo de hosts
   yes | cp -rf /samba4/private/krb5.conf /etc/krb5.conf


    # resolv.conf
    ip=$(cat /etc/hosts | tail -n 1 | awk '{print $1}')

    echo "nameserver $ip" > /etc/resolv.conf
    echo "domain $REALM" >> /etc/resolv.conf

    # Mark samba as setup
    touch "${SETUP_LOCK_FILE}"

}

samba4_start () {
   /etc/init.d/webmin start
   /samba4/sbin/samba -D
   tail -f /samba4/var/log.samba
}


if [ "$opcao" == "app:start" ]; then
   echo "Verificando Setup..."
   if [ ! -f "${SETUP_LOCK_FILE}" ]; then
       samba4_setup
   fi
  echo 'Rodando o Samba'
  samba4_start
fi

