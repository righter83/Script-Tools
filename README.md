# Script-Tools
Some little Scripts which maybe others can use

### check_dns_entry.sh
Bash Script to check if DNS entries are synced to all DNS Server.

#### Usage
Just configure your DNS Servers in the script and then run:
```
./check_dns_entry.sh www.dom.ch
```

or for specific record
```
./check_dns_entry.sh dom.ch NS
```

### check_whois_records.sh
Bash Script to Check a list of domains, what NS are in the whois records.

#### Usage
Just configure your domainlist at the top
```
./check_whois_records.sh
```


