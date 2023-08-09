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
#	== How it works? ==
#
#	The idea behind this script is to stop the tracking of your actions on the "Internet" or inside the "DeepWeb" by difficulty
#	the correlations of the events.
#	In another words, even that an adversary can control a TOR ENTRY NODE or a TOR EXIT NODE, this script will make the correlations
#	of events inside the TOR network almost impossible because it splits and send every request using different TOR circuit
#	running from different countries around the world.
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
# 	1) tor 	 	 	       --> version 0.4.6.7 or earlier  - https://www.torproject.org/ - https://github.com/torproject/tor
# 	2) privoxy 	 	     --> version 3.0.26  or earlier  - http://www.privoxy.org/
# 	3) haproxy 	 	     --> version 2.0 or earlier      - https://www.haproxy.org/
# 	4) proxychains-ng  --> version 4.13-4  or earlier  - https://sourceforge.net/projects/proxychains/
# 	5) expect		       --> version 5.45	   or earlier  - https://sourceforge.net/projects/expect/
#	  6) dnsdist 		     --> version 1.1.0   or earlier  - https://dnsdist.org/index.html
#
#
#
#	== How to use: ==
#
#	1) Execute the splitter.sh script and wait until TOR finish the load process of all requested instances. Press CTRL+C to close the status screen.
#		Sintax:
#		$ /bin/bash splitter.sh -i <INSTANCES> -c <COUNTRIES> -re <RELAY ENFORCE MODE>
#
#		Sample: $ /bin/bash splitter.sh -i 1 -c 10 -re exit
#
#		It will select 10 different countries and create 1 TOR instances for each selected country. In summary you will have 40 TOR instances.
#		By default the script will select random countries to create the requested number of TOR INSTANCES.
#		The script will start a HTTP PROXY (MASTER PROXY) on port 3128 of the localhost.
# 		Every program that points their connections to this proxy will send and receive data spliting theis request between all requested TOR instances.
#
#
#	2) Set the proxy 127.0.0.1:63537 in your brownser and you will be ready to start surfing.
#
##########################################################################################


#Importing the functions and configurations

source settings.cfg                   #This is the main configuration file.
source banner.func                    #The script banner.
source user_start_input.func          #Check the initial user input.
source help.func                      #The help message.
source loadbalancing_choice.func      #Defines the load balancing algorithm.
source killprevious_instances.func    #Kill previous running instances.
source pre_loading.func               #Prepares the environment to run.
source check_if_port_available.func   #Check if the port is available before bind it.
source random_country.func            #Select the random countries before start.
source boot_tor_per_country.func      #Boot the TOR instance based on the list of selected countries.
source boot_tor_instances.func        #Configures and start the TOR and PRIVOXY instances
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

# 4) Kill the previous instances running. Start Firewall Rules
killprevious_instances > /dev/null

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
cat "${TOR_TEMP_FILES}/temp_force_new_circuit.txt" | sort -R | sed -e 's|\.exp|\.exp\nsleep 1|g' >> "${TOR_TEMP_FILES}/force_new_circuit.sh"
echo "done" >> "${TOR_TEMP_FILES}/force_new_circuit.sh"
rm "${TOR_TEMP_FILES}/temp_force_new_circuit.txt"

# 8) Adjusting the permissions of splitter temp folder.
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
#
#HTTP
cat "${TOR_TEMP_FILES}/haproxy_TOR_HTTP_PROXY.txt" >> "${MASTER_PROXY_CFG}"
cat "${TOR_TEMP_FILES}/haproxy_http_backend.txt" >> "${MASTER_PROXY_CFG}"
rm "${TOR_TEMP_FILES}/haproxy_TOR_HTTP_PROXY.txt"
rm "${TOR_TEMP_FILES}/haproxy_http_backend.txt"
#
#Socks
cat "${TOR_TEMP_FILES}/haproxy_TOR_SOCKS_PROXY.txt" >> "${MASTER_PROXY_CFG}"
cat "${TOR_TEMP_FILES}/haproxy_socks_backend.txt" >> "${MASTER_PROXY_CFG}"
rm "${TOR_TEMP_FILES}/haproxy_TOR_SOCKS_PROXY.txt"
rm "${TOR_TEMP_FILES}/haproxy_socks_backend.txt"

# 11) Executing the MASTER PROXY
${HAPROXY_PATH} -f "${MASTER_PROXY_CFG}" > /dev/null 2>&1 &


# 12) Setting the roudrobin or leastOutstanding as default policy for DNSDIST
# https://dnsdist.org/guides/serverselection.html
#echo "setServerPolicy(roundrobin)" >> "${TOR_TEMP_FILES}/dnsdist.conf"
echo "setServerPolicy(leastOutstanding)" >> "${TOR_TEMP_FILES}/dnsdist.conf"

# 13) Setting proxy to the system
cat /home/${USER_ID}/.bashrc | grep -v "SPLITTER" | grep -v "no_proxy" | grep -v "all_proxy" | grep -v "http_proxy" | grep -v "https_proxy" | grep -v "ftp_proxy" | grep -v "rsync_proxy" > .bashrc_temp
echo "##### CREATED BY SPLITTER #####" >> "${TOR_TEMP_FILES}/.bashrc_temp"
#echo "export no_proxy=${DO_NOT_PROXY}" >> "${TOR_TEMP_FILES}/.bashrc_temp"
echo "export all_proxy=http://127.0.0.1:${MASTER_PROXY_SOCKS_PORT}" >> "${TOR_TEMP_FILES}/.bashrc_temp"
echo "export http_proxy=http://127.0.0.1:${MASTER_PROXY_SOCKS_PORT}" >> "${TOR_TEMP_FILES}/.bashrc_temp"
echo "export https_proxy=https://127.0.0.1:${MASTER_PROXY_SOCKS_PORT}" >> "${TOR_TEMP_FILES}/.bashrc_temp"
echo "export ftp_proxy=http://127.0.0.1:${MASTER_PROXY_SOCKS_PORT}" >> "${TOR_TEMP_FILES}/.bashrc_temp"
echo "export rsync_proxy=http://127.0.0.1:${MASTER_PROXY_SOCKS_PORT}" >> "${TOR_TEMP_FILES}/.bashrc_temp"
mv -f "${TOR_TEMP_FILES}/.bashrc_temp" /home/${USER_ID}/.bashrc


# 14) Show the status screen while loading the TOR INSTANCES

banner # call the function to show the script banner.
echo "Tips:"
echo "     1) Wait until all yours (${TOR_CURRENT_INSTANCE}) requested TOR instances be ready."
echo " "
echo "     2) You can monitor the health of your TOR INSTANCES using the following link:"
echo "        URL:             http://127.0.0.1:${MASTER_PROXY_STAT_PORT}${MASTER_PROXY_STAT_URI}"
echo "        User ID:         ${USER_ID}"
echo "        Random Password: ${MASTER_PROXY_STAT_PWD}"
#echo "        Password:        splitter"
echo " "
echo "        DO NOT OPEN THIS FOR YOUR LOCAL NETWORK!"
echo " "
echo "     3) Set the Proxy in your browser:"
echo "        SOCKSv5:    127.0.0.1:${MASTER_PROXY_SOCKS_PORT}"
echo "        HTTP/HTTPS: 127.0.0.1:${MASTER_PROXY_HTTP_PORT}"
echo "=================================================================================================================="
if [ "${COUNTRY_LIST_CONTROLS}" != "none" ];then
  echo "Number of countries        : ${COUNTRIES}"
  echo "Instances per country      : ${TOR_INSTANCES}"
  echo "Total of TOR instances     : ${TOR_CURRENT_INSTANCE}"
  echo "TOR Relay is enforcing the : ${COUNTRY_LIST_CONTROLS}"
  echo "-"
  echo "The list of selected countries are:"
  echo "${MY_COUNTRY_LIST}" | sed 's/$/,/g' | sed ':a;N;s/\n//g;ta' | rev | cut -d "," -f 2-9999 | rev
  echo "=================================================================================================================="
else
  echo "Total of TOR instances     : ${TOR_CURRENT_INSTANCE}"
  echo "No ENTRY node or EXIT node is being enforced. The TOR protocol is controling it."
  echo "All contries in your ACCEPTED_COUNTRIES list will be used and ENTRY node or EXIT node."
  echo "=================================================================================================================="
fi


# 15) Starting the script to force the new circuits in background.
#/bin/bash "${TOR_TEMP_FILES}/force_new_circuit.sh" > /dev/null 2>&1 &

# 16) Call the background function that changes the COUNTRY on the fly...
#echo "TOR_INSTANCES=(${TOR_INSTANCES}) CHANGE_COUNTRY_ONTHEFLY=(${CHANGE_COUNTRY_ONTHEFLY}) MY_COUNTRY_LIST=(${MY_COUNTRY_LIST}) COUNTRIES=(${COUNTRIES})"
if [ "${CHANGE_COUNTRY_ONTHEFLY}" == "YES" ] && [ "${COUNTRIES}" -gt 5 ] && [ "$(cat settings.cfg | grep "^MY_COUNTRY_LIST" | cut -d "=" -f 2 | sed 's|"||g')" == "RANDOM" ]; then
	#sleep 20
	/bin/bash change_country_on_the_fly.func > /dev/null 2>&1 & #Change the COUNTRY of the TOR INSTANCE running.
	echo "The SPLITTER will force a new country for each TOR Instance after every (${CHANGE_COUNTRY_INTERVAL}) seconds."
fi

# 17) Run the STATUS instance
if [ "${SHOW_STATUS}" == "yes" ]; then
		/bin/bash status.func &
fi

# 18) Leave the DNS Load balance process running
echo "Boot finished. Next status report in ${CHANGE_COUNTRY_INTERVAL} seconds. Please wait..."
/bin/bash dnsloadbalance.func > /dev/null 2>&1

# 19) If the user press CTRL+C to finish the script kill all process and leave
killprevious_instances > /dev/null
exit 0
