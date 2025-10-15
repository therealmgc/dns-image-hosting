# dns-image-hosting
Hosting images inside TXT records
TODO: evalute the term "hide" vs "host"

## Description

DNS TXT records can be used both as a covert channel to upload and exfiltrate data (including images), or as a method to download content (let’s say an image) to a host while bypassing firewalls and content filters, since DNS traffic is often less scrutinized. This constitutes a misuse of the protocol’s features and may be flagged as a potential security threat.

How it works:

- An image is converted to a string of text (often using Base64 encoding).

- This string is broken up into smaller chunks, with each chunk placed in a separate DNS TXT record.

- The size of each chunk is limited to a maximum size per TXT record 

- An attacker can then retrieve the records to reconstruct the image.


## Disclaimer
This repository is provided strictly for educational purposes in the field of information security, including but not limited to penetration testing, security research, and digital forensics.
Users assume full responsibility for any actions taken based on the information, techniques, or tools contained herein. Any unauthorized or unlawful use may constitute a violation of applicable laws and could result in severe legal consequences.


![Alice in Wonderland](images/alice-in-wonderland-276452_640.png)

## HowTo
```
# Start DNS Server
docker compose up -d

# DNS UI (credentials as per compose file
http://localhost:5380

# Upload image
cd code
chmod +x *.sh
./upload.sh ../images/alice-in-wonderland-276452_640.png

# Download image
cd code
chmod +x *.sh
./download.sh
 
```

## REFs
   https://hub.docker.com/r/technitium/dns-server
   https://github.com/TechnitiumSoftware/DnsServer/blob/master/APIDOCS.md
   https://stackoverflow.com/questions/296536/how-to-urlencode-data-for-curl-command


## Credits
Thanks to:
- The team at Technitium for their great work on popular open-source tools
- [Asher Falcon](https://github.com/ashfn) for the inspiration on [that](https://github.com/ashfn/dnsimg)
- azzy_roth from Pixabay for the "Wonderful" [picture](https://pixabay.com/users/azzy_roth-143196/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=276452)

## TODO

- scenario: description and image (firewall, rabbit hole (port 53)

- video

- profile image

- project -> public
