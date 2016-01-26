# dynamic_dns
A Dynamic DNS Widget

This is a simple Sinatra app, backed by something ActiveRecord can talk to, which builds a zonefile from an ERB template and stored resource record definitions. Updates are POSTed to the app as JSON, using HTTP Basic Auth to authenticate. The zone file can be retrieved via HTTP GET.

BIND compatible zone files are generated, so anything that reads BIND files can use the results. I wrote this app targeting [NSD](https://www.nlnetlabs.nl/projects/nsd/). I use NSD on several embedded router/firewall machines due to its low memory and CPU consumption, and wanted a way to do dynamic updates, including reverse zones. As such, this app runs on a server separate from the DNS servers in my deployment cases, and the DNS server periodically checks the app to see if there are updates.

### Updating records

POST some JSON to `/update` -- the format is documented in [the JSON schema](config/short_form_update.json). HTTP Basic Auth is required. The following cURL command will POST an update:

``` 
curl --user user:pass -H "Content-Type: application/json" -X POST -d '{"name":"yourhost","a":"1.2.3.4","aaaa":"2001:db8:1"}' https://ddnshost.com/update
```

Keep in mind that, while cURL is great for a quick "client," your command will be visible in `ps aux` to anyone else logged in to the system. We're using HTTP Basic Auth here, so you'd better be using TLS (formerly known as SSL) on your server!

### Getting the zonefile

Do a HTTP GET to `/zone/your.fqdn.com`. You can set `If-None-Match` in the request header to the version of the zone you currently have -- if there have been no updates since that serial, you'll get a `304 Not Modified`. You'll get a `200` and the zone if:

* The serial is less than the version in the DB
* There have been resource record updates since the last generation of the zonefile
* You don't send `If-None-Match` in the request

Here's a cURL request with the zone serial:

```
curl --header 'If-None-Match: "2016012607"' https://ddnshost.com/zone/your.fqdn.com
```

Or, "just get the zonefile":

```
curl https://ddnshost.com/zone/your.fqdn.com
```