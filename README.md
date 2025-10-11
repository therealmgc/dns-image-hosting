# dns-image-hosting
Hosting images inside TXT records

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
