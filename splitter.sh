#!/bin/bash
#              ###########################################
#              ##########                       ##########
#              ##########        SPLITTER       ##########
#              ##########       Ver: 0.0.1      ##########
#              ##########                       ##########
#              ###########################################
#
#	Created By: Rener Alberto (aka Gr1nch) - DcLabs Security Team
#	E-Mail: rener.silva@protonmail.com
#	PGP Key ID: 0x65f912ed59949f8e
#	PGP Key FingerPrint: 7B7A 8E83 82D3 DACD 4B3B  CFE0 65F9 12ED 5994 9F8E
#	PGP KEY Download: https://pgp.mit.edu/pks/lookup?op=get&search=0x65F912ED59949F8E
#
#       BSD License - Do whatever you want with this script, but take the responsibility!
#
#	We do not support who will use this script for illegal proposes. 
#	If you will use this script for any illegal propose I'm not responsible for your acts.
#
#	This script has been created to support people to protect themselves, their children and their dignity while using Internet.
#	Also to support you to keep your data safe, and confidential. The privacy is your right!
#	It was created to help Journalists, Activists, Military, Pentesters and people who deals with sensitive data every day during
#	exercise of their job activities.
#
#	This script has been created to help you to use the TOR NETWORK every single day, any time. 
#	Even to watch movies on-line in the Youtube in HIGH DEFINITION. Yes! Now it's possible even using the tor network.
#
#	Before you just run this script, I strongly recommend you to activate your ANONYMOUS VPN connection! Never connect straight to the TOR network!
#	Stay safe! Stay anonymous! Stay in the shadows!
#
#
#
#	== How it works? ==
#		
#	The idea behind this script is to stop the tracking of your actions on the "Internet" or inside the "DeepWeb" by difficulty 
#	the correlations of the events.
#	In another words, even that an adversary can control a TOR ENTRY NODE or a TOR EXIT NODE, this script will make the correlations
#	of events inside the TOR network almost impossible because it splits and send every request using different TOR circuit
#	running from different countries around.
#
#	By using the TOR GeoIP, this script allows you to create many TOR instances using different countries as TOR ENTRY and 
#   different countries as TOR EXIT nodes, performing the LOAD BALANCING and making sure that all your requests will hit the target.
#
#	The speed and stability has been considered for many people the huge problem of TOR NETWORK and now you can use it with the same speed of your 
#	"normal Internet connection". That's it!
#   Yes! We are talking about HIGH AVAILABILITY and HIGH SPEED even considering the TOR NETWORK which is being improved but still being considered a very unstable network.
#
#
# 	== DEPENDENCIES:== 
# 	1) tor 	 	 	--> version 0.3.3.6 or earlier - https://www.torproject.org/
# 	2) privoxy 	 	--> version 3.0.26  or earlier - http://www.privoxy.org/
# 	3) haproxy 	 	--> version 1.7.5-2 or earlier - https://www.haproxy.org/
# 	4) proxychains  --> version 3.1	 	or earlier - https://sourceforge.net/projects/proxychains/
# 	5) expect		--> version 5.45	or earlier - https://sourceforge.net/projects/expect/
#
#
#
#	== How to use: ==
#
#	1) Execute the splitter.sh script and wait until TOR finish the load process of all requested instances. Press CTRL+C to close the status screen.
#		Sintax:
#		$ /bin/bash splitter.sh -i <INSTANCES> -c <COUNTRIES> -re <RELAY ENFORCE MODE>
#
#		Sample: $ /bin/bash splitter.sh -i 2 -c 20 -re entry
#
#		It will select 20 different countries and create 2 TOR instances for each selected country. In summary you will have 40 TOR instances.
#		By default the script will select random countries to create the requested number of TOR INSTANCES.
#		The script will start a HTTP PROXY (MASTER PROXY) on port 3128 of the localhost.
# 		Every program that points their connections to this proxy will send and receive data spliting theis request between all requested TOR instances.
#		
#
#	2) Set the proxy 127.0.0.1:3128 in your brownser and enjoy your anonymous, secure and fast TOR connection.
# 
##########################################################################################


#Importing the functions and configurations

source func/settings.cfg                        #This is the mail configuration file.
source func/banner.func                    #The script banner.
source func/user_start_input.func          #Check the initial user input.
source func/help.func                      #The help message.
source func/loadbalancing_choice.func      #Defines the load balancing algorithm.
source func/killprevious_instances.func    #Kill previous running instances.
source func/pre_loading.func               #Prepares the environment to run.
source func/check_if_port_available.func   #Check if the port is available before bind it.
source func/random_country.func            #Select the random countries before start.
source func/boot_tor_per_country.func      #Boot the TOR instance based on the list of selected countries.
source func/boot_tor_instances.func        #Configures and start the TOR and PRIVOXY instances
##########################################################################################

#####################################################################################
#################################                   #################################
#################################  EXECUTION FLOW   #################################
#################################                   #################################
#####################################################################################

# 1) Start the script showing the banner
banner           

# 2) Check the initial user inputs and give instructions how to use.
user_start_input $1 $2 $3 $4 $5 $6     

# 3) Based on the user choice, defines the load balancing algorithm
loadbalancing_choice

# 4) Kill the previous instances running.
killprevious_instances

# 5) Creating the directories and initial service configuration
pre_loading             

# 6) Based on the list of accepted countries, start the TOR instances. 
if test "${MY_COUNTRY_LIST}" != "RANDOM" ; then
	#If you defined a specific list of countries put this countries in a
	#in a RANDOM order.
	MY_COUNTRY_LIST="$(echo ${MY_COUNTRY_LIST} | sed 's|,|\n|g' | sort -R)"
	boot_tor_per_country #Call the declared function
else
	#If you do not specify a list of countries. The script will select
	#random countries from your accepted countries list.
	MY_COUNTRY_LIST="FIRST_EXECUTION"
	random_country #Call the declared function
fi

# 7) After boot the TOR instances finish the configuration of the script
#which will force a new circuit for all running instances.
#Renew all TOR circuits using a ramdon order.
cat "temp_force_new_circuit.txt" | sort -R | sed -e 's|\.exp|\.exp\nsleep 1|g' >> force_new_circuit.sh
echo "done" >> force_new_circuit.sh
rm "temp_force_new_circuit.txt"

# 8) Adjusting the permissions of the speed tor temp folder.
chown -R ${USER_ID} "${TOR_TEMP_FILES}"
chmod 700 -R "${TOR_TEMP_FILES}"
#
sleep 3

# 9) Save the list of current countries. The whatdog script uses this
# list to select the instance which will change the country during the execution.
echo "${MY_COUNTRY_LIST}" > "${TOR_TEMP_FILES}/current_country_list.txt"
echo "${MY_COUNTRY_LIST}" > "${TOR_TEMP_FILES}/used_country_list.txt"

# 10) Put the TOR INSTANCES in a random order inside the load balancer farm.
# If you're running more than 1 instances per country.
# To put the TOR INSTANCES in the farm in a random order is necessary to avoid 
# a correlation based on the order of countries used to send the requests.
# This correlation become possible if your adversary controls the WEBSITE/TARGET.
# Your adversary could identify your traffic based on the sequence of requests,
# once the normal road-robin will put and use the TOR INSTANCES in order and we
# will have a sequence of requests without this.
# Your adversary could notice the sequence of requests comming from an specific
# country and sistematically changing to another country.
# By putting the TOR INSTANCES in a random order in the load balancer farm, you
# will difficult this correlation creating a confuse sequence of requests.
# However the correlation based on the sequence still possible and the function
# change_country_on_the_fly.func will complete the task of brake this correlation
# selecting a different country on the fly and changing the country of every TOR INSTANCE.
cat "${MASTER_PROXY_CFG}_tmp.txt" | sort -R >> "${MASTER_PROXY_CFG}"

# 11) Executing the MASTER PROXY
${HAPROXY_PATH} -f "${MASTER_PROXY_CFG}"&
rm "${MASTER_PROXY_CFG}_tmp.txt"

# 12) Setting proxy to the system
cat /home/${USER_ID}/.bashrc | grep -v "SPLITTER" | grep -v "no_proxy" | grep -v "all_proxy" | grep -v "http_proxy" | grep -v "https_proxy" | grep -v "ftp_proxy" | grep -v "rsync_proxy" > .bashrc_temp
echo "##### CREATED BY SPLITTER #####" >> .bashrc_temp
echo "export no_proxy=${DO_NOT_PROXY}" >> .bashrc_temp
echo "export all_proxy=http://127.0.0.1:${MASTER_PROXY_PORT}" >> .bashrc_temp
echo "export http_proxy=http://127.0.0.1:${MASTER_PROXY_PORT}" >> .bashrc_temp
echo "export https_proxy=https://127.0.0.1:${MASTER_PROXY_PORT}" >> .bashrc_temp
echo "export ftp_proxy=http://127.0.0.1:${MASTER_PROXY_PORT}" >> .bashrc_temp
echo "export rsync_proxy=http://127.0.0.1:${MASTER_PROXY_PORT}" >> .bashrc_temp
mv -f .bashrc_temp /home/${USER_ID}/.bashrc

# 13) Show the status screen while loading the TOR INSTANCES

banner # call the function to show the script banner.
echo "Tips:"
echo "     1) Wait until all yours (${TOR_CURRENT_INSTANCE}) requested TOR instances be ready."
echo " "
echo "     2) You can monitor the health of your TOR INSTANCES using the following link:"
echo "        URL:             http://127.0.0.1:${MASTER_PROXY_STAT_PORT}${MASTER_PROXY_STAT_URI}"
echo "        User ID:         ${USER_ID}"
echo "        Random Password: ${MASTER_PROXY_STAT_PWD}"
echo " "
echo "        DO NOT OPEN THIS FOR YOUR LOCAL NETWORK!"
echo " "
echo "     3) Set the HTTP proxy 127.0.0.1:${MASTER_PROXY_PORT} in your web brownser and enjoy!"
echo "=================================================================================================================="
echo "Number of countries        : ${COUNTRIES}"
echo "Instances per country      : ${TOR_INSTANCES}"
echo "Total of TOR instances     : ${TOR_CURRENT_INSTANCE}"
echo "TOR Relay is enforcing the : ${COUNTRY_LIST_CONTROLS}"
echo "-"
echo "The list of selected countries are:"
echo "${MY_COUNTRY_LIST}" | sed 's/$/,/g' | sed ':a;N;s/\n//g;ta'
echo "=================================================================================================================="

# 14) Updating the status of the TOR INSTANCE ready to use.
READY=0
while [ ${READY} -lt ${TOR_CURRENT_INSTANCE} ]; do READY=$(grep '100%' ${TOR_TEMP_FILES}/tor_log_* | wc -l); tput cup 36 0;echo -n "We have (${READY}) TOR instances READY to be used from total of (${TOR_CURRENT_INSTANCE}) requested instances. Please wait..."; sleep 3; done
echo " Done!"

# 15) Starting the script to force the new circuits in background.
/bin/bash "force_new_circuit.sh" 2>&1 > /dev/null &

# 16) Call the background function that changes the COUNTRY on the fly...
if [ "${CHANGE_COUNTRY_ONTHEFLY}" = "YES" ]; then
	cd func/ && /bin/bash change_country_on_the_fly.func& #Change the COUNTRY of the TOR INSTANCE running.
fi
exit 0
