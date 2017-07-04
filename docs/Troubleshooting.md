# Troubleshooting
This section will present some common issues and how to sort them out. 

***

**Table of Content**

* [Box Name Conflict](#box-name-conflict)

* [ElasticSearch Not Available](#elastic-search-not-available)

***

<a id="box-name-conflict"></a>
# Box Name Conflict

If you see something like:
```text
A VirtualBox machine with the name '<someName>' already exists.
Please use another name or delete the machine with the existing name, and try again.
```

then you'll need to destroy your previous homestead box before running this one.

<a id="elastic-search-not-available"></a>
# ElasticSearch Not Available

If you can't call ElasticSearch from either host or guest, or if you see something like:

```text
curl: (7) Failed to connect to localhost port 9200: Connection refused
```
The port is not mapped properly or ElasticSearch is down.

Or if you see something like: 
```text
curl: (52) Empty reply from server
```
The port is not mapped properly.

then you should try and reprovision the box.

> Always make sure you have an updated `master` branch before doing it.

Then run the following from the homestead folder:
```bash
./init.sh && homestead <up/reload> --provision && homestead ssh
```

> Choose `up` if the box doesn't exist or has been destroyed, or `reload` if the box already exists
