#!/bin/bash

#
# No input params
#

MYDIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "${MYDIR}/../config/conf.env" || (echo "FATAL: Configuration file not found"; exit 1)

# Uncomment following line to get log
# exec > >(tee "${MYDIR}/${_ME}".log) 2>&1


# __MAIN__

# Get number of chunks
count=$( dig @${_DNSHOST} +short TXT ${_SUBCOUNT} | tr -d '" \n' )
width=${#count}   
echo "chunk to be restored: $count; using $width digitrms names"

# Cleanup
> ${MYDIR}/image.${_ENC}
> ${MYDIR}/restored.image  
if [ -d ${MYDIR}/${_WORKDIRDWN}/ ]; then  
   \rm -fr ${MYDIR}/${_WORKDIRDWN}
fi    
mkdir -p ${MYDIR}/${_WORKDIRDWN}/.

# Start the spinner
echo -e "\nDownloading chunks... "
spinner "> " &
spinner_pid=$!

# Restore from chunks 
for ((ii=0; ii<count; ii++)); do
   SUB="$(printf "%s%0${width}d" "${_CHUNCKPREFIX}" "$ii").${_DOMAIN}"
   txt=$( dig @${_DNSHOST} +short TXT $SUB | tr -d '" \n' )
   echo $txt >> ${MYDIR}/image.${_ENC}
   echo -n $txt > ${MYDIR}/${_WORKDIRDWN}/$SUB 
done 

# Stop the spinner
kill "$spinner_pid" 2>/dev/null
wait "$spinner_pid" 2>/dev/null

# Decode
cat ${MYDIR}/image.${_ENC} |  base64 -d > ${MYDIR}/restored.image                    
ret=$? 
\rm -f ${MYDIR}/image.${_ENC}
\rm -fr ${MYDIR}/${_WORKDIRDWN}

echo
echo "Exit value is $ret"
echo
exit $(( ret % 256 ))

