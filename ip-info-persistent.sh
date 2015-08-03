#!/bin/bash -x

HOST=${HOST:-"127.0.0.1"}
PORT=${PORT:-"21201"}
LOGFN="/var/log/ip-memcachedb.db"

MEMCACHEDB_CMD="sudo memcachedb -H ${LOGFN} -l ${HOST} -u root -d -p ${PORT}"
SELFD=$(readlink -f $(pwd))
API_KEY_FN="${SELFD}/api-key"
API_KEY=$(cat "${API_KEY_FN}")

if test -z "${API_KEY}"; then
    echo "no api key found in ${API_KEY_FN}"
    exit ${LINENO}
fi
PRE_URL="http://api.ipinfodb.com/v3/ip-city/?key=${API_KEY}"

# VERBOSE=true
VERBOSE=false

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

function sendmemcached	{
    echo -en "${1}\r\n" | nc "${HOST}" "${PORT}" -w 1
}

function memset	{
    KEY="${1}"
    VAL="${2}"
    LEN="${#VAL}"
    sendmemcached "set ${KEY} 0 0 ${LEN}\r\n${VAL}"
    # sendmemcached 
}
function memget	{
       sendmemcached "get $*" | grep -v '^\(VALUE\|END\)'
       # sendmemcached "get $*"
}


function ipdb_get	{
    IP="${1}"
    if test "${VERBOSE}" = true; then
	echo "CACHE MISS. MAKING NETWORK REQUEST" >&2
    fi
    URL="${PRE_URL}&ip=${IP}"
    RESP=$(curl -s "${URL}")
    echo "${RESP}"
}
function ipdb_get_set	{
    IP="${1}"
    RESP=$(ipdb_get ${IP})
    memset "${IP}" "${RESP}"
}

function get_ip	{
    IP="${1}"
    RESP=$(memget ${IP})
    if test -z "${RESP}"; then
	RESP=$(ipdb_get ${IP})
	memset "${IP}" "${RESP}"
    elif test "${VERBOSE}" = true; then
	echo "CACHE HIT" >&2
    fi
    echo "${RESP}"
}

    
maybe_start_or_install
while IFS='$\n' read -r IP; do
    echo $(get_ip "${IP}")
done

# maybe_start_or_install
# echo $(test_port)
# exit 

# memcachedb -H /tmp/caca.db -l localhost -V
# sudo memcachedb -H /var/log/ip.db -l localhost -u root -d
# memset 162.228.201.6 "CACA"
# ipdb_get 162.228.201.6


# Local Variables:
# compile-cmd: "echo 162.228.201.6 | ip-info-persistent.sh "
# End:

