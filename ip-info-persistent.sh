#!/bin/bash

while getopts "vhxs:" OPT; do
    case ${OPT} in
	v)
	    VERBOSE=true
	    ;;
	x)
	    set -x
	    ;;
	s)
	    SLEEP_SECS=${OPTARG}
	    ;;

	h)
	    less ${0}
	    exit 0
	esac
done


HOST=${HOST:-"127.0.0.1"}
PORT=${PORT:-"21201"}
SLEEP_SECS=${SLEEP_SECS:-.9}

LOGFN="/var/log/ip-memcachedb.db"
MEMCACHEDB_CMD="sudo memcachedb -H ${LOGFN} -l ${HOST} -u root -d -p ${PORT}"

#SELFD=$(readlink -f $(pwd))
SELFD=$(dirname $(readlink -f $0))
API_KEY_FN="${SELFD}/api-key"
API_KEY=$(cat "${API_KEY_FN}")

if test -z "${API_KEY}"; then
    echo "no api key found in ${API_KEY_FN}"
    exit ${LINENO}
fi

function ip_to_url	{
	IP=$1 && shift
	echo "http://ip-api.com/json/${IP}"
}
VERBOSE=${VERBOSE:-false}


function test_port	{
    HOST="${1}"
    PORT="${2}"
    # http://stackoverflow.com/questions/9609130/quick-way-to-find-if-a-port-is-open-on-linux
    # echo -e "GET / HTTP/1.0\n" >&6
    # cat <&6
    exec 6<>/dev/tcp/"${HOST}/${PORT}"
}

function maybe_start_or_install	{
    if ! test_port "${HOST}" "${PORT}"; then
	if ! command -v memcachedb; then
	    echo "installing memcached"
	    sudo apt-get install memcachedb -y
	fi
	echo "starting memcached server"
	${MEMCACHEDB_CMD}
    fi
}

function memcached_send	{
    echo -en "${1}\r\n" | nc "${HOST}" "${PORT}" -q 1
}

function ip_set	{
    KEY="${1}"
    VAL="${2}"
    LEN="${#VAL}"
    memcached_send "set ${KEY} 0 0 ${LEN}\r\n${VAL}"
    # memcached_send 
}
function ip_get_cache	{
       memcached_send "get $*" | grep -v '^\(VALUE\|END\)'
       # memcached_send "get $*"
}


function ip_get_network	{
    IP="${1}"
    URL=$(ip_to_url ${IP})
    RESP=$(curl -s ${URL})
    if ! test ${SLEEP_SECS} = 0; then
	sleep ${SLEEP_SECS}
    fi
    echo "${RESP}"
}
function ipdb_get_set	{
    IP="${1}"
    RESP=$(ip_get_network ${IP})
    ip_set "${IP}" "${RESP}"
}

function ip_get	{
    IP="${1}"
    RESP=$(ip_get_cache ${IP})
    if test -z "${RESP}" || test -n "$(echo ${RESP} | grep 'ERROR')" ; then
	test "${VERBOSE}" = true && echo "CACHE MISS. MAKING NETWORK REQUEST" >&2
	RESP=$(ip_get_network ${IP})
	ip_set "${IP}" "${RESP}"
	echo "${RESP}"
    else
	#test "${VERBOSE}" = true && echo "CACHE HIT" >&2
	true
    fi
    echo "${RESP}"
}

    
maybe_start_or_install

# http://stackoverflow.com/questions/31218391/read-line-by-line-from-standard-input-bash
while IFS='$\n' read -r IP; do
    echo $(ip_get "${IP}")
done

# maybe_start_or_install
# echo $(test_port)
# exit 

# memcachedb -H /tmp/caca.db -l localhost -V
# sudo memcachedb -H /var/log/ip.db -l localhost -u root -d
# ip_set 45.55.140.195 "PRUEBA"
# ipdb_get 45.55.140.195


# Local Variables:
# compile-cmd: "echo 45.55.140.195 | ip-info-persistent.sh "
# End:

