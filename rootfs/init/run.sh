#!/bin/sh

DNS_FORWARDER=${DNS_FORWARDER:-"208.67.220.220,208.67.222.222,141.1.1.1"}
WEB_PORT=${WEB_PORT:-"8000"}

config_file="/etc/dnsmasq.conf"

hosts=$(echo ${DNS_FORWARDER} | sed -e 's/,/ /g' -e 's/\s+/\n/g' | uniq)

forwarder=

if [ ! -z "${hosts}" ]
then

  for h in ${hosts}
  do
    echo "${h}"

    [ -n "${h}" ]

    echo "add forwarder '${h}'"

    forwarder="${forwarder}\nserver=${h}"

  done

fi

sed -i 's|%DNS_FORWARDING%|'${forwarder}'|g' ${config_file}

webproc --config ${config_file} --port ${WEB_PORT} -- dnsmasq --no-daemon
