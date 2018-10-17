#                                              DcLabs SPLITTER

# 				=== INTRODUCTION ===
 
  To exploit the common weakness of TOR related de-anonymization techniques, difficulty traffic-analysis,
correlation and statistically related attacks on the TOR network. [1, 2, 3, 4, 5, 6, 10, 20, 23, 28]
  I developed a free open-source TOR network based script called SPLITTER. This script configures and applies a
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


#  == DEPENDENCIES:== 
    * 1. tor          --> version 0.3.3.6 or earlier - https://www.torproject.org/
    * 2. privoxy      --> version 3.0.26  or earlier - http://www.privoxy.org/
    * 3. haproxy      --> version 1.7.5-2 or earlier - https://www.haproxy.org/
    * 4. proxychains  --> version 3.1     or earlier - https://sourceforge.net/projects/proxychains/
    * 5. expect       --> version 5.45    or earlier - https://sourceforge.net/projects/expect/



# 				=== SPLITTER overview ===
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

TOR instances load balance overview:
