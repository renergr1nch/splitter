        ############################################
        ##########                        ##########
        ##########         SPLITTER       ##########
        ##########        Ver: 0.2.4      ##########
        ##########                        ##########
        ############################################

#	Created By: Rener Alberto (aka Gr1nch) - DcLabs Security Team
#	E-Mail: rener.silva@protonmail.com
#	PGP Key ID: 0x65f912ed59949f8e
#	PGP Key FingerPrint: 7B7A 8E83 82D3 DACD 4B3B  CFE0 65F9 12ED 5994 9F8E
#	PGP KEY Download: https://pgp.mit.edu/pks/lookup?op=get&search=0x65F912ED59949F8E
#
#       BSD License - Do whatever you want with this script, but take the responsibility!
#       You are responsible for your actions.
#       The creator assume no liability and is not responsible for any misuse or damage.
#
#	It was created to help Journalists, Activists, Military, Pentesters and people who deals with sensitive data every day during the exercise of their job activities.
#
#	The intent of this script is provide you a better experience while using TOR NETWORK
#	Before you just run this script, I strongly recommend you to activate your ANONYMOUS VPN connection! Never connect straight to the TOR network!
#
#	== How it works? ==
#
#	The idea behind this script is to stop the tracking of your actions on the "Internet" or inside the "TOR NETWORK" by difficulty the correlations of the events.
#	In another words, even that an adversary can control a TOR ENTRY NODE or a TOR EXIT NODE, this script will make the correlations
#	of events inside the TOR network more difficult because it splits and send every request using different TOR circuit
#	running from different countries around the world.
#
#	By using the TOR GeoIP, this script allows you to create many TOR instances using different countries as TOR ENTRY and
#   different countries as TOR EXIT nodes, performing the LOAD BALANCING and making sure that all your requests will hit the target.
#
#
# 	== DEPENDENCIES:==
# 	1) tor 	 	 	       --> version 0.4.6.7 or earlier  - https://www.torproject.org/ - https://github.com/torproject/tor
# 	2) privoxy 	 	     --> version 3.0.26  or earlier  - http://www.privoxy.org/
# 	3) haproxy 	 	     --> version 2.0 or earlier      - https://www.haproxy.org/
# 	4) proxychains-ng  --> version 4.13-4  or earlier  - https://sourceforge.net/projects/proxychains/
# 	5) expect		       --> version 5.45	   or earlier  - https://sourceforge.net/projects/expect/
#	  6) dnsdist 		     --> version 1.1.0   or earlier  - https://dnsdist.org/index.html

================================================================================

Instructions about how to SETUP the SPLITTER environment:

0) Make sure to connect on YOUR SECURE VPN before run SPLITTER.

================================================================================

1) Compiling the DOCKER IMAGE:
# After decompress go to inside the SPLITTER source code foder and run:
# docker build -t splitter:local .

This process will compile and create the DOCKER IMAGE of SPLITTER.

================================================================================

2) START THE SPLITTER DOCKER CONTAINER:
Considering that your SPLITTER folder is: splitter_v.0.2.4

# You can use the following to run the Docker Container:
docker container stop splitter_v.0.2.4 2> /dev/null
docker container rm splitter_v.0.2.4 2> /dev/null
docker run -it -p 53:5353 -p 53:5353/udp -p 63536:63536 -p 63537:63537 -p 63539:63539 --cap-add=NET_ADMIN -v $(pwd)/splitter_v.0.2.4/:/splitter --name splitter_v.0.2.4 splitter:local /bin/bash

#PS: Adjust the line above fixing the path were you save the SPLITTER source code.

================================================================================

3) Setting up you browser to use SPLITTER.

Just point you browser to the IP of DOCKER at PORT 63537.
All request from port 63537 will be redirected and split inside TOR network according to the number of tor instances you select to run.

================================================================================

4) Using SPLITTER as DNS Load Balancer
SPLITTER will listen the local port 53/UDP for resolve the DNS request.
It will do the load balance between all TOR connections created by SPLITTER and will difficult the DNS resolution correlation.
It's recommended you setup your DNS SERVER to the IP OF SPLITTER DOCKER CONTAINER.

echo "nameserver <YOUR_SPLITTER_IP_DOCKER_CONTAINER_HERE>" > /etc/resolv.conf
