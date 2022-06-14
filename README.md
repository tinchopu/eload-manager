# eload-manager ⚡️☁️

Golang REST Service which calculates when the car battery will be loaded up to 80%

I'm using this to calculate when the Nissan Leaf (62 KW Battery) will be loaded at 80% with a loading current of 16A. For that I'm passing the actual load as a REST GET parameter.

Ideally I would like to see if https://mk.nissanconnect.eu/en-gb/Support/Quickstart provides a REST API for retrieving the current battery load percentage and if the wallbox https://my.wallbox.com/ provides an API into which the end time can be set automatically.
