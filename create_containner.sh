docker run -d --restart unless-stopped  \
      --name fileserver --privileged  \
      -p 53:53 -p 53:53/udp -p 88:88 -p 88:88/udp -p 135:135 -p 137-138:137-138/udp -p 139:139 -p 389:389 -p 389:389/udp -p 445:445 -p 464:464 -p 464:464/udp -p 636:636 -p 1024-1044:1024-1044 -p 3268-3269:3268-3269  -p 10000:10000 \
      -v /v01:/v01 -v /v02:/v02 \
      -e "REALM=xlab32.corp"  \
      -e "DOMAIN=XLAB32"         \
      -e "HOSTNAME=fileserver"   \
      clodoniltrigo/samba4-dc-webadmin


