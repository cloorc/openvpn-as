# syntax = docker/dockerfile:1.4.0
FROM ubuntu:22.10

WORKDIR /home/openvpn

RUN apt update && apt -y install ca-certificates wget net-tools gnupg systemctl
RUN wget https://as-repository.openvpn.net/as-repo-public.asc -qO /etc/apt/trusted.gpg.d/as-repository.asc
RUN echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/as-repository.asc] http://as-repository.openvpn.net/as/debian jammy main">/etc/apt/sources.list.d/openvpn-as-repo.list
RUN apt update && apt -y install openvpn-as

RUN echo '\
set -ex\n \
cat /usr/local/openvpn_as/init.log\n \
update-alternatives --set iptables /usr/sbin/iptables-legacy\n \
mkdir -p /dev/net\n \
mknod /dev/net/tun c 10 200\n \
chmod 600 /dev/net/tun\n \
systemctl start openvpnas\n \
tail -f /var/log/openvpnas.log\n \
' >> /entrypoint.sh

EXPOSE 1194 443 904-909 943 945

ENTRYPOINT [ "bash", "/entrypoint.sh" ]