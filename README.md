# dns-image-hosting
Hiding images inside TXT records

TODO: repo name?


![Wonderland lab](images/wonderland-lab.png)

## Description

DNS TXT records can be used both as a covert channel to upload and exfiltrate data (including images), or as a method to download content (let’s say an image) to a host while bypassing firewalls and content filters, since DNS traffic is often less scrutinized. This constitutes a misuse of the protocol’s features and may be flagged as a potential security threat.

How it works:

- An image is converted to a string of text (often using Base64 encoding).

- This string is broken up into smaller chunks, with each chunk placed in a separate DNS TXT record.

- The size of each chunk is limited to a maximum size per TXT record 

- An attacker can then retrieve the records to reconstruct the image.

This repository provideis a fully functional environment for testing image uploads and downloads to and from a DNS server.

## Disclaimer

The information provided in this repository is for general educational and informational purposes only. All content is published in good faith and is intended to support ethical learning, especially in cybersecurity and networking-related fields. Users assume full responsibility for any actions taken based on the information, techniques, or tools contained herein. Any unauthorized use may constitute a violation of applicable laws and could result in severe legal consequences.



## HowTo
```
# Start DNS Server
docker compose up -d

# DNS UI (credentials as per compose file
http://localhost:5380

# Upload image
cd code
chmod +x *.sh
./upload.sh ../images/whiterabbit.png

# Download image
cd code
chmod +x *.sh
./download.sh

# The retrieved image is stored into 'image.bin' file
 
```

## REFs
   https://hub.docker.com/r/technitium/dns-server
   
   https://github.com/TechnitiumSoftware/DnsServer/blob/master/APIDOCS.md
   
   https://stackoverflow.com/questions/296536/how-to-urlencode-data-for-curl-command


## Credits
Thanks to:
- The team at Technitium for their great work on popular open-source tools
- [Asher Falcon](https://github.com/ashfn) for the inspiration on [that](https://github.com/ashfn/dnsimg)
- azzy_roth from Pixabay for the "Wonderland" [picture](https://pixabay.com/users/azzy_roth-143196/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=276452)

## TODO

- scenario: description and image (firewall, rabbit hole (port 53)

- video

- profile image

- project -> public

- repo name

