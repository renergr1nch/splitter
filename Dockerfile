#
#              ###########################################
#              ##########                       ##########
#              ##########        SPLITTER       ##########
#              ##########       Ver: 0.2.4      ##########
#              ##########                       ##########
#              ###########################################
#
#       Created By: Rener Alberto (aka Gr1nch) - DcLabs Security Team
#       E-Mail: rener.silva@protonmail.com
#       PGP Key ID: 0x65f912ed59949f8e
#       PGP Key FingerPrint: 7B7A 8E83 82D3 DACD 4B3B  CFE0 65F9 12ED 5994 9F8E
#       PGP KEY Download: https://pgp.mit.edu/pks/lookup?op=get&search=0x65F912ED59949F8E
#
#       BSD License - Do whatever you want with this script, but take the responsibility!
#       You are responsible for your actions.
#       The creator assume no liability and is not responsible for any misuse or damage.

##################################
#####    SPLITTER v.0.2.4    #####
##################################
# 	== DEPENDENCIES:==
# 	1) tor 	 	 	       --> version 0.4.6.7 or earlier - https://www.torproject.org/ - https://github.com/torproject/tor
# 	2) privoxy 	 	     --> version 3.0.26  or earlier - http://www.privoxy.org/
# 	3) haproxy 	 	     --> version 2.0 or earlier - https://www.haproxy.org/
# 	4) proxychains-ng  --> version 4.13-4  or earlier - https://sourceforge.net/projects/proxychains/
# 	5) expect		       --> version 5.45	   or earlier - https://sourceforge.net/projects/expect/
#	  6) dnsdist 		     --> version 1.1.0   or earlier - https://dnsdist.org/index.html
#
#
# To build this file just use:
# docker build -t splitter:local .

# You can use the following to run the Docker Container:
# You need to replace the string '<docker_interface_ip>' by the IP of docker interface, that you would like to expose the ports.
# Warning! In docker, If you don't setup the IP of docker interface, it will be exposed to all interfaces.
#=============
# docker run -d -it --sysctl 'net.ipv4.ip_forward=1' -p <docker_interface_ip>:53:5353 -p <docker_interface_ip>:53:5353/udp -p 127.0.0.1:53:5353 -p 127.0.0.1:53:5353/udp -p <docker_interface_ip>:63536:63536 -p 127.0.0.1:63536:63536 -p <docker_interface_ip>:63537:63537 -p <127.0.0.1>:63537:63537 -p <docker_interface_ip>:63538:63538 -p 127.0.0.1:63538:63538 -p <docker_interface_ip>:63539:63539 -p 127.0.0.1:63539:63539 --cap-add=NET_ADMIN -v splitter_v.0.2.3/:/splitter --name splitter_v.0.2.3 splitter:local /bin/bash
#=============

FROM debian:bullseye

LABEL maintainer="Gr1nch - gr1nchdc@proton.me"

# Add debian backports repo for wireguard packages
RUN echo "deb http://deb.debian.org/debian/ bullseye-backports main" > /etc/apt/sources.list.d/backports.list

# Update the Debian
RUN apt clean && apt update && apt full-upgrade -y && apt autoremove -y && apt clean

# Install the SPLITTER dependencies already available on Debian Repositories,
RUN apt install -y \
privoxy \
haproxy \
proxychains-ng \
expect \
dnsdist \
wireguard-tools \
telnet \
iptables \
tmux \
wget \
curl \
dnsutils \
vim \
less \
nano \
net-tools \
procps \
openresolv \
apt-transport-https \
tor

RUN apt autoremove -y && apt clean

# Creating the local low privilege splitter user
RUN useradd -p splitter --create-home -s /bin/bash splitter

# Disabling the bash_history
RUN rm /home/splitter/.bash_history 2> /dev/null; ln -s /dev/null /home/splitter/.bash_history; \
 rm /root/.bash_history 2> /dev/null; ln -s /dev/null /root/.bash_history; \
 chown splitter:splitter /home/splitter/.bash_history

# Define the start script that will run the splitter with the best basic sintax
 WORKDIR /splitter/
 ENTRYPOINT ["/splitter/start_splitter.sh"]
