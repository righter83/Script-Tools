#!/bin/bash

for dom in `cat domains.txt`
do
	w=""
	echo "Checking $dom";

	# If the zone is a subdomain or a rDNS zone skip it
	sub=`echo $dom | grep -oP "\." | wc -l`
    if [ $sub -gt 1 ] && [[ "$dom" != *.co.uk ]] && [[ "$dom" != *.co.jp ]]
	then
		continue
	fi

	# get nameserver for specific TLDs
	out+="$dom "
	if [[ "$dom" == *.de ]]
	then
		w=`whois $dom | grep -i "Nserver:" | cut -d " " -f2`

	elif [[ "$dom" == *.com || "$dom" == *.net || "$dom" == *.org || "$dom" == *.biz ]]
    then
		sleep 1
        w=`whois $dom  | grep "Name Server:" | cut -d " " -f3`

	elif [[ "$dom" == *.ch ]]
	then
		sleep 1
		w=`whois $dom  | grep -A5 "Name servers:" | grep -v "Name servers:" | cut  -f1`

	elif [[ "$dom" == *.jp ]] && [[ "$dom" != *.co.jp ]]
	then
		w=`whois $dom  | grep "\[Name Server\]" | tr -s " " | cut -d " " -f3`

	elif [[ "$dom" ==  *.nl ]]
	then
		w=`whois $dom  | grep -A4 "Domain nameservers:" | grep "^ " | sed "s/\ //g"`

    elif [[ "$dom" == *.se || "$dom" == *.fr ]]
	then
		w=`whois $dom | grep -i "Nserver:" | tr -s " " | cut -d " " -f2`

    elif [[ "$dom" == *.eu ]]
    then
        w=`whois $dom | grep -A5 "\Name servers" | grep "^ " | tr -s " " | cut -d " " -f2`

    elif [[ "$dom" == *.co.uk ]]
    then
        w=`whois $dom | grep -A5 "\Name servers" | grep -e "\t" | grep -v WHOIS | tr -s " " | cut -d " " -f2`

	elif [[ "$dom" == *.co.jp ]]
	then
		w=`whois $dom  | grep "p. \[Name Server\]" | tr -s " " | cut -d " " -f4`

	# if the TLD is not configured above, drop an error
	else
		w="ERROR_no_Registry_found \n"
		out+="$w \n"
		continue
	fi

	# if we havent found a nameserver, check if the zone is registered
	if [ "$w" == "" ]
	then
		unreg=`whois $dom | egrep 'do not have an entry|NOT FOUND|No match|Status: AVAILABLE' | wc -l`
    	if [ "$unreg" == "1" ]
	    then
    		w="ERROR_Domain_not_registered \n"
			out+="$w \n"
		else
			out+="ERROR - nothing matched \n"
		fi

	# if its registred pull the nameserver in the output
	else
		out+="$w \n"
	fi
done

echo -e $out | column -t

