#!/bin/bash
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
#
#	This script was created to help Journalists, Activists, Military, Pentesters and people who deals with sensitive data
# every day during the exercise of their job activities.
#
#	The intent of this script is provide you a better experience while using TOR NETWORK,
#	Even to watch movies on-line in the Youtube in HIGH DEFINITION. Yes! Now it's possible even using the tor network.
#
#	Before you just run this script, I strongly recommend you to activate your ANONYMOUS VPN connection!
# Never connect straight to the TOR network!
#
#Check if SPLITTER DOCKER IMAGE is avaialble
INSTALLED=$(docker image ls | grep 'splitter' > /dev/null;echo $?)
if [ "${INSTALLED}" == "0" ]; then
    #Stop and Remove previous splitter docker container:
    docker container stop splitter_v.0.2.4 > /dev/null 2&>1
    docker container rm splitter_v.0.2.4 > /dev/null 2&>1
    #
    #Start the new container
    docker run -it -p 53:5353 -p 53:5353/udp -p 63536:63536 -p 63537:63537 -p 63539:63539 --cap-add=NET_ADMIN -v $(pwd):/splitter --name splitter_v.0.2.4 splitter:local /bin/bash

else # IF THE SPLITTER DOCKER IMAGE NOT FOUND
     #Compile the Docker IMAGE
     docker build -t splitter:local .

     #Stop and Remove previous splitter docker container:
     docker container stop splitter_v.0.2.4 > /dev/null 2&>1
     docker container rm splitter_v.0.2.4 > /dev/null 2&>1
     #
     #Start the new container
     docker run -it -p 53:5353 -p 53:5353/udp -p 63536:63536 -p 63537:63537 -p 63539:63539 --cap-add=NET_ADMIN -v $(pwd):/splitter --name splitter_v.0.2.4 splitter:local /bin/bash
fi
