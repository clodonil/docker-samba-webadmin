FROM centos:latest
MAINTAINER Clodonil Trigo <clodonil@nisled.org>

#Pre-requisito
RUN yum update -y 
RUN yum install -y attr bind-utils docbook-style-xsl gcc gdb krb5-workstation \
       libsemanage-python libxslt perl perl-ExtUtils-MakeMaker \
       perl-Parse-Yapp perl-Test-Base pkgconfig policycoreutils-python \
       python-crypto gnutls-devel libattr-devel keyutils-libs-devel \
       libacl-devel libaio-devel libblkid-devel libxml2-devel openldap-devel \
       pam-devel popt-devel python-devel readline-devel zlib-devel systemd-devel wget


# webadmin
COPY webadmin.repo /etc/yum.repos.d/webmin.repo
RUN wget http://www.webmin.com/jcameron-key.asc
RUN rpm --import jcameron-key.asc
RUN yum -y install webmin


#ajustando o fstab
#RUN sed 's/defaults/defaults,xattr/' /etc/fstab > /etc/fstab-old
#RUN mv /etc/fstab-old /etc/fstab

#Compilacao do samba4
RUN curl https://download.samba.org/pub/samba/stable/samba-4.7.0.tar.gz | tar -xzv

RUN cd samba-4.7.0/ && ./configure --prefix=/samba4  && make && make install
RUN rm -rf samba-4.7.0*


#variavel
ENV DNS_FORWARD 8.8.8.8
ENV REALM fileserver.corp
ENV DOMAIN FILESERVER
ENV HOSTNAME samba4


#Volume
VOLUME ["/samba4", "/v01"]


#Copiando o script
COPY entrypoint.sh /samba4/entrypoint.sh
RUN chmod +x /samba4/entrypoint.sh

ENTRYPOINT [ "/samba4/entrypoint.sh" ]

CMD [ "app:start" ]

