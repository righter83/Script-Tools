#!/bin/bash
# v1.0 - intital - Righter

ns=(ns.hostpoint.ch ns2.hostpoint.ch)
error=0
first=0
echo ""

if [ "$1" == "" ];
then
	echo "ERROR no paramter given"
	echo "Usage: check_dns_entry.sh www.dom.ch"
	echo "Usage: check_dns_entry.sh dom.ch NS"
	exit
fi

echo "--- Checking $1 ---"

for i in "${ns[@]}";
do
	a1=`dig +short @$i $1 $2 | sort | tr '\n' ' '`
	if [ "$first" == "1" ]
	then
		if [ "$a1" != "$old" ]
		then
			error=1
		fi
	fi
	out+="$i: $a1\n"
	#printf '%s:\t %s\n' "$i" "$a1" | columns -w 12 -c 1
	first=1
	old=$a1
done

echo -e $out | column -t
echo ""
if [ "$error" == "1" ]
then
	echo "ERROR not all records are equal!"
	echo ""
fi
