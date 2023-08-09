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
###################################################
# SPLITTER NETWORK - START SPLITTER DOCKER SCRIPT #
###################################################
#This script is used as start point for SPLITTER CONTAINER
#

# Set variables
TOR_INSTANCES="1"
COUNTRIES="10"
COUNTRY_LIST_CONTROLS="exit"

help()
{
   echo "Option:"
   echo "-i     Number of Tor instances per country. (Default: ${TOR_INSTANCES})"
   echo "-c     Number of Countries. (Default: ${COUNTRIES})"
   echo "-r     Country list control. (Default: ${COUNTRY_LIST_CONTROLS})"
   echo "-h     This Help."
}

# Get the options
while getopts ":i:c:r:h" option; do
   case $option in
      h) help; exit;;
      i) TOR_INSTANCES="${OPTARG}";;
      c) COUNTRIES="${OPTARG}";;
      r) COUNTRY_LIST_CONTROLS="${OPTARG}";;
     *) echo "Error: Invalid option"; exit;;
   esac
done

cd /splitter
#/bin/bash iptables_firewall.func

su -l splitter -c "cd /splitter; /bin/bash -c 'cd /splitter; /splitter/splitter.sh -i ${TOR_INSTANCES} -c ${COUNTRIES} -re ${COUNTRY_LIST_CONTROLS}'"
