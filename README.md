# dns-image-hosting

Hiding images inside DNS TXT records


![Wonderland lab](images/wonderland-lab.png)


## Description

DNS TXT records can be used both as a covert channel to upload and exfiltrate data (including images), or as a method to download content (let’s say an image) to a host while bypassing firewalls and content filters, since DNS traffic is often less scrutinized. This constitutes a misuse of the protocol’s features and may be flagged as a potential security threat.

How it works:

- An image is converted to a string of text (using Base64 encoding).

- This string is broken up into smaller chunks with fixed maximum size

- Each chunk is placed in a separate DNS TXT record.

- The records can then be retrieved to reconstruct the originale image.

This repository provideis a fully functional environment for testing image uploads and downloads to and from a DNS server.

The same can be done with any binary file.


## Disclaimer

The information provided in this repository is for educational and informational purposes only. All content is published in good faith and is intended to support ethical learning, especially in cybersecurity and networking-related fields. Users assume full responsibility for any actions taken based on the information, techniques, or tools contained herein. Any unauthorized use may constitute a violation of applicable laws and could result in legal consequences.


## HowTo

Basically, a compose file is provided to setup the DNS server and two bash scripts implement the upload and download operations; they share the information about DNS server, domain and TXT records naming convention. Downloaded content is saved into image.bin file.

```
# Start DNS Server
docker compose up -d

# Upload image
cd code
chmod +x *.sh
./upload.sh ../images/whiterabbit.png

# Download image
cd code
chmod +x *.sh
./download.sh

# Checks
cksum ../images/whiterabbit.png image.bin

# The retrieved image is stored into 'image.bin' file
 
```


## DNS content overview

```
# DNS UI  - see compose file for (weak and in plan text) credentials
http://<myipaddress>:5380
```
![Begin](images/screen01.png)
[...]
![End](images/screen02.png)


## Use cases

```
victim host (pwned) -> upload   (exfiltrate data) 
victim host (fishing)  <- download (malware) 
```

## Limitations
TODO
DNS Propagation time vs binary size


## Mitigation
TODO

- Monitor DNS logs for unusual TXT record queries.

- Flag frequent or large TXT record requests.

- Correlate anomalous source IPs.

- DNSSEC

## REFs

   https://hub.docker.com/r/technitium/dns-server
   
   https://github.com/TechnitiumSoftware/DnsServer/blob/master/APIDOCS.md
   
   https://stackoverflow.com/questions/296536/how-to-urlencode-data-for-curl-command


## Credits

Thanks to:

- The team at Technitium for their great work on popular open-source tools

- [Asher Falcon](https://github.com/ashfn) for the inspiration on [that](https://github.com/ashfn/dnsimg)


## TODO

- scenario: description and image (firewall, rabbit hole (port 53)

- video

- profile image

- project -> public

- repo name??

- not for production (credentials)

