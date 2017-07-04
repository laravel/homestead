# Our Stack
This section will present the services and programs installed in our custom Homestead development environment. 

***

**Table of Content**

* [Services](#services)

* [Programs](#programs)

***

<a id="services"></a>
# Services

## ElasticSearch

ElasticSearch is installed and available on port `9200`. This port is also mapped to your host in `VagrantFile`.

You can call it from your within Guest or from your host:
```bash
curl -XGET http://localhost:9200
```

you should see something like:
```json
{
  "name" : "seplhBV",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "EZWNWgX3QH6xEOeWfA9BZw",
  "version" : {
    "number" : "5.4.2",
    "build_hash" : "929b078",
    "build_date" : "2017-06-15T02:29:28.122Z",
    "build_snapshot" : false,
    "lucene_version" : "6.5.1"
  },
  "tagline" : "You Know, for Search"
}
```

<a id="programs"></a>
# Programs

> Coming soon
