#!/bin/bash

#
# $1: bin file
#

# Check if an argument was provided
if [ $# -lt 1 ] || [ ! -f "$1" ]; then
   echo "Usage: $0 <filename>"
   exit 1
fi

in_file=$1
echo "Input file is ${in_file}"

MYDIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "${MYDIR}/../config/conf.env" || (echo "FATAL: Configuration file not found"; exit 1)
source "${MYDIR}/../compose/.env" || (echo "FATAL: Secrets file not found"; exit 1)

# Uncomment following line to get log
# exec > >(tee "${MYDIR}/${_ME}".log) 2>&1


# __MAIN__

# Cleanup
if [ -d ${MYDIR}/${_WORKDIRUP}/ ]; then 
  \rm -fr ${MYDIR}/${_WORKDIRUP}
fi
mkdir -p ${MYDIR}/${_WORKDIRUP} 

# Copy input file into temporary dir
\cp -fa ${in_file} ${MYDIR}/${_WORKDIRUP}/$(basename $in_file)

# Encode - note -w0 option to have a single line
in_file64="${MYDIR}/${_WORKDIRUP}/$(basename $in_file).${_ENC}"
cat $in_file | base64 -w0 > $in_file64

# cd into temporary dir
pushd "${MYDIR}/${_WORKDIRUP}" > /dev/null || { echo "Directory not found: ${MYDIR}/${_WORKDIRUP}"; exit 1; }

# Split encoded file according to CHUNCKSIZE
split -b ${_CHUNKSIZE} $in_file64 ${_CHUNCKPREFIX}

# Get number of chunk
num_chunks=$( ls -1 ${_CHUNCKPREFIX}* | wc -l ) 
width=${#num_chunks}
echo "Number of chunks: $num_chunks"

# Rename chunks 
echo "Renaming chunks with $width digits progression"
for f in $( ls -1 ${_CHUNCKPREFIX}* ) ; do
  mv "$f" "$(printf "%s%0${width}d" "${_CHUNCKPREFIX}" "$n")"
  ((n++))
done

# Get auth token 
TOKEN=$(curl -s "http://${_DNSHOST}:${_DNSPORT}/api/user/login?user=${_DNSUSR}&pass=${_DNSPASS}" | jq -r .token)         
echo "TOKEN=$TOKEN"    
     
# Delete and create domain
curl -s --data-urlencode "token=$TOKEN" http://${_DNSHOST}:${_DNSPORT}/api/zones/delete?zone=${_DOMAIN} &>/dev/null
sleep 1 
curl -s --data-urlencode "token=$TOKEN" http://${_DNSHOST}:${_DNSPORT}/api/zones/create?zone=${_DOMAIN}&type=Primary

# Start the spinner 
echo -e "Uploading chunks... "
spinner "> " &
spinner_pid=$!

# Upload chunks
first=1
for mychunk in $( ls -1 "${_CHUNCKPREFIX}"* ); do
   SUB="${mychunk}.${_DOMAIN}"
   curl -s --data-urlencode "text=$(cat $mychunk)" "http://${_DNSHOST}:${_DNSPORT}/api/zones/records/add?token=$TOKEN&domain=$SUB&type=TXT&ttl=60" > /dev/null
   sleep 0.2
done 

# Store count with a special name to be used to retrieve chunks 
curl -s --data-urlencode "text=$(echo $num_chunks)" \
     "http://${_DNSHOST}:${_DNSPORT}/api/zones/records/add?token=$TOKEN&domain=${_SUBCOUNT}&type=TXT&ttl=60" > /dev/null

# return to main directory 
popd > /dev/null

# Stop the spinner
kill "$spinner_pid" 2>/dev/null
wait "$spinner_pid" 2>/dev/null

\rm -fr ${MYDIR}/${_WORKDIRUP} 
echo
exit

# DNS server stores TXT records as:
#
#b64-000	TXT	60
#(1m)	iVBORw0KGgoAAAANSUhEUgAAAoAAAAHfCAMAAAD3I5muAAADAFBMVEUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
#
#b64-001	TXT	60
#(1m)	AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
#
#[...]
#
#b64-count	TXT	60
#(1m)	780   <- This is the total number of chunks
#


