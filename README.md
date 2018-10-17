#                                              DcLabs SPLITTER

##				=== INTRODUCTION ===
 
  To exploit the common weakness of TOR related de-anonymization techniques, difficulty traffic-analysis,
correlation and statistically related attacks on the TOR network. [1, 2, 3, 4, 5, 6, 10, 20, 23, 28]

  I developed a free open-source TOR network based shell script called SPLITTER. This script configures and applies a
systematic chain of free open-source solutions, working together to difficult the TOR related de-anonymization
techniques and ensure a better performance for TOR network. The result is a better TOR user experience and a more
secure TOR network related connection approach.
The SPLITTER is licensed under the BSD - License and was created with an initial academic propose.[41]
The user accepts the total responsibility for his acts while using this tool.

For the best effectiveness of the theoretical approach behind the SPLITTER solution, a low-cost private VPS and
VPN networks chain should be considered. The idea behind this globally distributed network infrastructure is difficult
more specific traffic-analysis attacks and do not allow a direct association between the TOR network and the user. This
network approach will be called “SPLITTER NETWORK” and comprehends few VPS machines under the
control of the user running the SPLITTER script but using a public VPN service to connect in TOR network.

The bundle of linux open-source tools which compose the SPLITTER tool are:
* 1. HAPROXY Community Edition: “HAProxy is a free, very fast and reliable solution
offering high availability, load balancing, and proxying for TCP and HTTP-based applications.
It is particularly suited for very high traffic web sites and powers quite a number of the world's
most visited ones. Over the years it has become the de-facto standard opensource load
balancer, is now shipped with most mainstream Linux distributions, and is often deployed by
default in cloud platforms. Since it does not advertise itself, we only know it's used when the
admins report it.” [33]

* 2. PRIVOXY: “Privoxy is a non-caching web proxy with advanced filtering capabilities for
enhancing privacy, modifying web page data and HTTP headers, controlling access, and
removing ads and other obnoxious Internet junk. Privoxy has a flexible configuration and can
be customized to suit individual needs and tastes. It has application for both stand-alone
systems and multi-user networks.”[34]

* 3. TOR (standalone): The TOR network client.[35] 


###  == DEPENDENCIES:== 
    - 1. tor          --> version 0.3.3.6 or earlier - https://www.torproject.org/
    - 2. privoxy      --> version 3.0.26  or earlier - http://www.privoxy.org/
    - 3. haproxy      --> version 1.7.5-2 or earlier - https://www.haproxy.org/
    - 4. proxychains  --> version 3.1     or earlier - https://sourceforge.net/projects/proxychains/
    - 5. expect       --> version 5.45    or earlier - https://sourceforge.net/projects/expect/



#				=== SPLITTER overview ===
Each SPLITTER related tool is applied in a systematic sequence, driving the TCP packets from the
user browser or application, first to HAPROXY, second to PRIVOXY and the last step is the TOR
standalone which provide the connection with TOR network. After being routed through the current
active TOR circuit[8], the packet reaches the final destination. The answer for this TCP packet will
follow the reverse path.

![SPLITTER - TCP STREAM PATH](https://github.com/renersistemas/splitter/blob/master/01_TCP_STREAM_PATH.png)


The SPLITTER will create and handle with many TOR network connections. 
A single TOR standalone network connection is also called in this paper as “TOR INSTANCE” and comprehends a single and unique execution of TOR standalone running and administrating it’s own TOR network circuits.[8, 16, 21, 22, 24, 25, 26, 27]
The SPLITTER gives the user the opportunity to configure every single parameter related to the execution of HAPROXY, PRIVOXY, and TOR standalone. [27, 36, 37]
However, the most important aspect of this tool is the geolocation approach and how it selects the countries which will be enforced to compose the TOR circuit.[8, 16, 21, 22, 24, 26, 27, 29]
The user should define how many TOR instances per country and how many countries the SPLITTER can use. It’s possible for example to create a number “X” of instances using the same country, as ENTRY NODE or EXIT NODE.


## TOR instances load balance overview:

![SPLITTER - LOAD BALANCE OVERVIEW](https://github.com/renersistemas/splitter/blob/master/02_LOADBALANCE_OVERVIEW.png)

Considering a single TOR instance, by default the SPLITTER will never use the same country as TOR ENTRY NODE and TOR EXIT NODE. This rule forces the same adversary compromise TOR nodes in different countries to be able to capture and correlate the user data transmitted using the currently active and selected TOR circuit.

## Default “Anti-Correlation” rules:

1. Always select a random country, from the list of countries that user accepts use as TOR ENTRY node or TOR EXIT node depending on which TOR node the user decide to enforce. It means that all random TOR circuits created by this manipulated TOR instance have a great chance to have a unique geolocation oriented combination of TOR ENTRY NODE and TOR EXIT NODE. This feature can by default difficult the correlation of many de-anonymization techniques based on:

	A) The absence of adversary’s compromised TOR nodes or compromised network related
equipment in both randomly selected countries.[1, 2, 3, 4, 5, 6, 10, 20, 23, 28]

 B) The deliberated disturbed created by SPLITTER in the natural global network path for packets in transit between the user machine and the destination server. [1, 2, 3, 4, 5, 6, 10, 20, 23, 28]


2. Considering the natural random country selection of TOR algorithm[8] which inside the SPLITTER manipulated context, will compose the beginning or the end of the TOR circuit, depending on which node/relay the user decide to enforce.[8] 
The probability exists for future TOR circuits[8] created by this TOR instance, select once again the same previous combination of TOR ENTRY node and TOR EXIT used by this TOR instance in the past.
Aiming to reduce this risk, the SPLITTER also controls the life circle of the TOR instance, giving the user the control about how long time a TOR INSTANCE can remain alive enforced to use a specific country as ENTRY NODE or EXIT NODE. 

As result:

A) This rule affects the random geolocation[29] oriented combination of TOR ENTRY
NODE and TOR EXIT NODE.

B) This rule disturbs the lifetime of TCP streams interrupting the TCP streams associated with this TOR instance when longer than “X” minutes. The premature interruption of an established TCP stream can affect the ability of the adversary to transmitting the pattern depending on the de-anonymization technique. [1, 2, 3, 4, 5, 6, 10, 20, 23, 28]


### The life circle of a single TOR INSTANCE inside the SPLITTER context comprehends:

1. After selecting a random new country, the SPLITTER will write the TOR configuration file based on the TOR options[27] defined by the user. By default, the first SPLITTER’s rule will be always respected. However, there are two exceptions to the first default rule:

	A) When the user decides to work with SPLITTER SPEED MODE described later in this paper. In this context, the First SPLITTER rule approach will be modified but still being observed.

	B) When the TOR option “StrictNodes” is disabled and the TOR algorithm is not able to find a route and generate a TOR circuit using the current random combination of the ENTRY NODE, MIDDLE NODE, and EXIT NODE.[27] Under this circumstance, TOR algorithm can select a TOR node from the TOR “ExcludeNodes”[27] to compose the circuit and provide a valid route to the destination.


2. The SPLITTER starts the new TOR INSTANCE. This instance will create the TOR circuits always observing the first SPLITTER rule, according to RELAY ENFORCE MODE selected and others specific TOR options.[27]

3.The SPLITTER creates a random disturb in the interval of TOR circuit creation, aiming to avoid a natural time pattern in the systematic loop process of creation and utilization of TOR circuits.

4.When the instance lifetime, reach the time limit specified by the user, the SPLITTER kills the running process related with this TOR instance, delete the temporary and all configuration files related with it and restart the life circle.

![SPLITTER - TOR INSTANCE LIFE CIRCLE](https://github.com/renersistemas/splitter/blob/master/03_INSTANCE_LIFECIRCLE.png)


The total amount of simultaneous active TOR instances is calculated using:

**(_X_ * _Y_) = _Total amount of simultaneous active TOR instances_.**

Where **“_X_”** is the number of countries and **“_Y_”** the number of desired instances inside the same country.
 
 
 
## How the SPLITTER "*control*" the TOR NODE/RELAY:

The options for the **TOR NODE/RELAY enforcing** are:

- **ENTRY**: Sets a specific country as ENTRY NODE and will use a different country as EXIT relay. This mode provides the best security for the user and it’s considered the default enforcing mode inside the context of SPLITTER solution.[27]

The load balancing algorithm for HAPROXY in this mode is Round Robin.[36]
Considering a specific country is enforced for TOR ENTRY node, the SPLITTER will select another random country from the list of countries defined by the user as TOR
EXIT node, but never the same country already defined to be used as TOR ENTRY node.

By enforcing this rule, the SPLITTER is _controlling_ the TOR algorithm and its free random selection of countries which will compose the TOR circuit. [8, 27]



- **EXIT**: Sets a specific country as EXIT NODE and will use a different country as ENTRY relay. This option gives the user the control of the EXIT relays and could be used to bypass GeoIP protections.[29] 
For example, this option is very suitable when you need to make sure that each request will hit the destination through a different country or the same country, depending on the number of countries each TOR instance can use.
The load balancing algorithm for HAPROXY in this mode is Round Robin.[36]

**A more specific SPLITTER EXIT mode user case:**

A) To always hit the target with the same country: The user needs to include only the desired country in the list of countries available and set the number of simultaneous countries as 1 (one). The number of instances “_Y_” inside this same country should be adjusted according to the user’s stability and speed needs.

B) To hit the target using random countries: After defining the list of countries SPLITTER can use, the user should define the number of simultaneous countries as “_X_” and the number of instances inside each country as “_Y_” according to his stability and speed needs.



- **SPEED**: This option will enforce the TOR INSTANCE use the same country as ENTRY NODE, MIDDLE NODE, and EXIT NODE. The idea is to ensure the best transmission performance of a TOR circuit, considering the restricted geolocation area that packets should travel to cross the entire TOR circuit.[8]



# TOR Load balance with HAPROXY

In general, the stability and performance of many circuits from TOR network are not enough for High Definition media consuming like videos in 720p~1080p for example.

The TOR performance and stability related issues can compromise the user experience when trying to consume High Definition media over TOR.

The paper "Improving Tor using a TCP-over-DTLS Tunnel" from Joel Reardon and Ian Goldberg, provide a deep analysis of the TOR network performance and stability related issues. [42]

The SPLITTER is using HAPROXY to perform a health-check of the established TOR circuit before sending the user data. The user can specify a specific website and the interval of analyses. The HAPROXY will monitor the availability of the TOR circuit based on the HTTP answer. If the circuit does not answer or if the TOR EXIT node from the current circuit is not able to resolve the requested address the TOR instance is considered down.

The requests are forwarded to another TOR instance until a fast, stable and reliable circuit be created in the previous instance considered down. The user can specify how many errors are necessary to consider one TOR instance as down and how many successful requests are necessary to consider it up again.

To difficult the correlation, the SPLITTER is using a random order of TOR instances inside HAPROXY configuration file. The idea is to avoid that consecutive requests being sent through the same country when the users decide to use more than one tor instance per country. The interval between the checks can be random or fixed, the user will adjust it according to the speed which new TOR circuits are being and destroyed. By default, 12s is used as the fixed interval between the health-checks. However, we should consider that the health-check by its self can generate a pattern and the adversary can use this sequence of checks to track the user. In another hand, the health-check provide a better speed and stability allowing the user consume High Definition movies even using the TOR network.

![SPLITTER - HAPROXY HEALTH CHECK](https://github.com/renersistemas/splitter/blob/master/04_HAPROXY_HEALTH_CHECK.png)



# SPLITTER NETWORK

To difficult the natural correlation between the TOR network and the user, we mentioned the need to connect in a public VPN service before connecting in TOR network. This simple approach prevents that the internet provider is able to see that user is connected on TOR network.

This is considered the best approach for privacy because the natural correlation between the TOR network and the user has been broke.[38, 39, 40]

However, more sophisticated traffic analyses techniques can observe the natural traffic patterns and follow the path from the VPN provider until the user.[1]

To difficult even more this possibility of correlation, a low-cost VPS and VPN network should be considered.[38, 39, 40]

![SPLITTER NETWORK - TCP STREAM PATH](https://github.com/renersistemas/splitter/blob/master/05_SPLITTER_NETWORK_TCP_STREAM_PATH.png)


**1) The VPS will act as VPN SERVER and VPN CLIENT at the same time:**

- The user will connect to the VPS using a VPN service running in the VPS. This VPN assume the default gateway for the user machine and all data from the user machine will be forwarded to VPS. The user should point his browser to the exposed HAPROXY port. More details in following number 3.

- The VPS is also connected in a PUBLIC VPN service and all output traffic from the VPS is send using the public VPN connection. This way, when the VPS execute the SPLITTER script the TOR network connection will be established using the public VPN. [38, 39, 40]



**2) The VPS have a firewall to avoid leaks:**
The inbound traffic and the outbound traffic is controlled to avoid leaks and enforce the following:
- The only inbound traffic allowed is to VPN SERVER service running in the VPS. All others input traffic are blocked including inputs from docker network.

- The outbound traffic allowed is to resolve the DNS address from the PUBLIC VPN server, to connect to this public VPN service and to allow the VPS to connect into HAPROXY port exposed by the docker container. All others output traffic is blocked including traffic from the user connected in the VPN SERVER to the internet. The unique output route for the user connected to the VPN SERVER is using the TOR connection running inside the docker container.
 
 
**3) The VPS will execute a docker container with the SPLITTER solution:**

The SPLITTER solution will be executed inside a Docker container, and the connection with the public VPN service will be created in the VPS operating system and transferred to the docker container. It is necessary because the public VPN connection should assume the default gateway of the Docker container, but can not assume the default gateway from the VPS operating system.

With this docker container approach, we will ensure that the TOR network connection will be executed inside the container and use the public VPN service. The Docker container will expose only the HAPROXY port to the VPS and the user should connect on the VPS VPN SERVICE and point his browser to the HAPROXY port exposed to the VPS.[44, 45]

The container will provide an extra security layer. If the adversary is able to exploit any vulnerability and assume the control of the container, he is trapped inside the container context and the only output available is using the public VPN service. Following this scenario, the attacker will face more difficult to interact with the operating system of the VPS and interact with the user connected in the VPS due to the segregation of environments provided by Docker.[44, 45]


##The SPLITTER network in a global scale:

This low-cost network can be distributed around the globe using different VPS providers and different VPN providers. Each VPS will execute a docker container with the SPLITTER SOLUTION running inside, connected to a different VPN provider before connect to the TOR network, according demonstrated in the images 9, 10, 11 and 15.

Each VPS should have at least 1GB of memory RAM and will cost the average of $200,00 (two hundred dollars) per year to remain online. Usually, the public VPN plans will allow the client to have at least 3 simultaneous connections and the price for 1 year is $100,00 (one hundred dollars).

This scenario allows the user to create his own private combination of VPS, VPN, and TOR. The user can use the HAPROXY once again to perform the load balancing between all VPS running the SPLITTER solution. The result will be an even better global spread of the traffic, hopefully difficulting the correlation between the TOR network and the final user.

![SPLITTER NETWORK - OVERVIEW](https://github.com/renersistemas/splitter/blob/master/06_SPLITTER_NETWORK_OVERVIEW.png)


# REFERENCES

- [1] Sambuddho Chakravarty, Marco V. Barbera, Georgios Portokalidis, Michalis Polychronakis and Angelos D.
Keromytis - “**On the Effectiveness of Traffic Analysis Against Anonymity Networks Using Flow Records**”.

[Online] Available: https://mice.cs.columbia.edu/getTechreport.php?techreportID=1545&format=pdf


- [2] Nathan S. Evans, Roger Dingledine and Christian Grothoff - “**A Practical Congestion Attack on Tor Using Long Paths**”.

[Online] Available: https://www.usenix.org/legacy/event/sec09/tech/full_papers/evans.pdf


- [3] Matthew Wright, Micah Adler, Brian N. Levine and Clay Shields - “**An analysis of the degradation of anonymous protocols**”

[Online]. Available: http://people.cs.georgetown.edu/~clay/research/pubs/wright.ndss01.pdf


- [4] Nicholas Hopper, Eeugene Y. Vasserman, and Eric Chan-Tin - “**How Much Anonymity does Network Latency Leak?**”.

[Online] Available: https://www-users.cs.umn.edu/~hoppernj/tissec-latency-leak.pdf


- [5] Sebastian Zander and Steven J. Murdoch - “**An Improved Clock-skew Measurement Technique for Revealing Hidden Services**”.

[Online] Available: https://www.usenix.org/legacy/event/sec08/tech/full_papers/zander/zander.pdf


- [6] Kevin Bauer, Damon McCoy, Dirk Grunwald, Tadayoshi Kohno and Douglas Sicker - “**Low-Resource Routing Attacks Against Anonymous Systems**“

[Online] Available: http://www.cs.colorado.edu/department/publications/reports/docs/CU-CS-1025-07.pdf


- [7] TOR project official web site. [Online] Available: https://www.torproject.org/


- [8] TOR project overview. [Online] Available: https://www.torproject.org/about/overview.html.en


- [9] “Statistical Analysis Handbook”. [Online] Available: http://www.statsref.com/StatsRefSample.pdf


- [10] Steven J. Murdoch and George Danezis - "**Low-Cost Traffic Analysis of Tor**".

[Online] Available: https://murdoch.is/papers/oakland05torta.pdf


- [11] FBI Official web site - “Dozens of Online ‘Dark Markets’ Seized Pursuant to Forfeiture Complaint Filed in
Manhattan Federal Court in Conjunction with the Arrest of the Operator of Silk Road 2.0”.

[Online] Available: https://www.fbi.gov/contact-us/field-offices/newyork/news/press-releases/dozens-of-online-dark-markets-seized-pursuant-to-forfeiture-complaint-filed-in-manhattan-federal-court-in-conjunction-with-the-arrest-of-the-operator-of-silk-road-2.0


- [12] FBI Official web site - “Operator of Silk Road 2.0 Website Charged in Manhattan Federal Court” 

[Online]. Available: https://www.fbi.gov/contact-us/field-offices/newyork/news/press-releases/operator-of-silk-road-2.0-website-charged-in-manhattan-federal-court


- [13] FBI Special Agent: Thomas M. Dalton report about the hoax bomb in Harvard University resulting in the prison of Eldo Kim.

[Online] Available: https://cbsboston.files.wordpress.com/2013/12/kimeldoharvard.pdf


- [13.1] FBI Official web site - “Harvard Student Charged with Bomb Hoax”. 

[Online] Available: https://archives.fbi.gov/archives/boston/press-releases/2013/harvard-student-charged-with-bomb-
hoax


- [14] FBI Official web site - “Six Hackers in the United States and Abroad Charged for Crimes Affecting Over One Million Victims”. 

[Online] Available: https://archives.fbi.gov/archives/newyork/press-releases/2012/six-hackers-in-the-united-states-and-abroad-charged-for-crimes-affecting-over-one-million-victims


- [15] Adrian Crenshaw - “**Dropping Docs on Darknets: How People Got Caught - Defcon 22**”

[Online] Available: https://www.youtube.com/watch?v=7G1LjQSYM5Q


- [16] TOR Official Project web site - Metrics about TOR network.

[Online] Available: https://metrics.torproject.org/networksize.html


- [17] TOR Official Project web site - “Tor: Onion Service Protocol”.

[Online] Available: https://www.torproject.org/docs/onion-services.html.en


- [18] Steven J. Murdoch - “**Hot or Not: Revealing Hidden Services by their Clock Skew**”.

[Online] Available: https://murdoch.is/papers/ccs06hotornot.pdf


- [19] TOR Official Project web site - “Who Uses Tor?”.

[Online] Available: https://www.torproject.org/about/torusers.html.en

- [20] Rob Jansen, Marc Juarez, Rafa Gálvez, Tariq Elahi and Claudia Diaz - "**Inside Job: Applying Traffic Analysis to Measure Tor from Within**".

[Online] Available: https://www.robgjansen.com/publications/insidejob-ndss2018.pdf


- [21] TOR project official web site - FAQ: "What are Entry Guards?".

[Online] Available: https://www.torproject.org/docs/faq#EntryGuards


- [22] TOR project offical blog - "Improving Tor's anonymity by changing guard parameters".

[Online] Available: https://blog.torproject.org/improving-tors-anonymity-changing-guard-parameters


- [23] **Free Haven – Online Anonymity Papers Library**.

[Online] Available: https://www.freehaven.net/anonbib/


- [24] TOR project offical blog - "Research problem: better guard rotation parameters"
[Online] Available: https://blog.torproject.org/research-problem-better-guard-rotation-parameters


- [25] Nick Mathewson - "Cryptographic Challenges in and around Tor".

[Online] Available: https://crypto.stanford.edu/RealWorldCrypto/slides/tor.pdf


- [26] TOR project official web site – FAQ: “How often does Tor change its paths?”

[Online] Available: https://www.torproject.org/docs/faq#ChangePaths


- [27] TOR project official web site – TOR MANUAL

[Online] Available: https://www.torproject.org/docs/tor-manual.html.en


- [28] Milad Nasr, Amir Houmansadr and Arya Mazumdar - "**Compressive Traffic Analysis:A New Paradigm for Scalable Traffic Analysis**".

[Online] Available: https://people.cs.umass.edu/~milad/papers/compress_CCS.pdf


- [29] ISACA - “Geolocation: Risk, Issues and Strategies”.

[Online] Available: https://www.isaca.org/Groups/Professional-English/wireless/GroupDocuments/Geolocation_WP.pdf


- [30] Eugene Gorelik - “Cloud Computing Models”

[Online] Available: https://web.mit.edu/smadnick/www/wp/2013-01.pdf


- [31] Alexa Huth and James Cebula - “The Basics of Cloud Computing”

[Online] Available: https://www.us-cert.gov/sites/default/files/publications/CloudComputingHuthCebula.pdf


- [32] Jason A. Donenfeld - “WireGuard: Next Generation Kernel Network Tunnel”

[Online] Available: https://www.wireguard.com/papers/wireguard.pdf


- [33] HAPROXY – Official Web Site.

[Online] Available: https://www.haproxy.org/


- [34] Privoxy – Official Web Site

[Online] Available: http://www.privoxy.org/


- [35] TOR Standalone Linux version Download Page.

[Online] Available: https://www.torproject.org/download/download-unix.html.en


- [36] HAPROXY - Documentation.

[Online] Available: https://www.haproxy.org/#docs


- [37] PRIVOXY - Official User Manual.

[Online] Available: http://www.privoxy.org/user-manual/index.html


- [38] King, Kevin, “Personal Jurisdiction, Internet Commerce, and Privacy: The Pervasive Legal Consequences of Geolocation Technologies,” Albany Law Journal of Science and Technology, January 2011

- [39] Viviane Reding - "Digital Sovereignty: Europe at a Crossroads"

[Online] Available: http://institute.eib.org/wp-content/uploads/2016/01/Digital-Sovereignty-Europe-at-a-Crossroads.pdf


- [40] Tim Maurer, Robert Morgus, Isabel Skierka, Mirko Hohmann - "**Technological Sovereignty: Missing the Point?**"

[Online] Available: http://www.digitaldebates.org/fileadmin/media/cyber/Maurer-et-al_2014_Tech-Sovereignty-Europe.pdf


- [41] BSD License Definition

[Online] Available: http://www.linfo.org/bsdlicense.html


- [42] Joel Reardon and Ian Goldberg - "Improving Tor using a TCP-over-DTLS Tunnel"

[Online] Available: https://www.usenix.org/legacy/event/sec09/tech/full_papers/reardon.pdf


- [43] TOR Metrics – Official WebSite.

[Online] Available: https://metrics.torproject.org/rs.html#search/country:ES%20flag:exit


- [44] Docker – Official Documentation


[Online] Available: https://docs.docker.com/


- [45] Docker – Official Documentation “Expose (incoming ports)”

[Online] Available: https://docs.docker.com/engine/reference/run/#expose-incoming-ports
