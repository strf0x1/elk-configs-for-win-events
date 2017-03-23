ELK (Elasticsearch stack) for Windows Event Logs

These are configs we use for an ELK stack that supports windows event logs. You can use this stack as an aggregator for your Windows servers. Some details like data.path might need to be changed.

## Installation

Install Elasticsearch and Kibana from https://www.elastic.co/downloads. When the install is complete, make sure services are stopped before copying over the configs.

```
service kibana stop
service elasticsearch stop
cp elasticsearch/elasticsearch.yml /etc/elasticsearch/
cp kibana/kibana.yml /etc/kibana/kibana.yml
service kibana start
service logstash start
service elasticsearch start
```

## Winlogbeat and Post-Install Configuration

On your Windows servers, download and install the latest Winlogbeat, the log shipper that will be sending data to the elk stack. Install the service so it always runs, copy over the included config file winlogbeat.yml and start the service to start shipping logs.

To install the included dashboards, open powershell and navigate to your winlogbeat directory.

```powershell
scripts\import_dashboards.exe -es http://192.168.100.5:9200
```

## Snapshots

We backup our configs to Amazon S3 using the following commands:

Create a new repository

```json
PUT http://logs.intra.bombbomb.com:9200/_snapshot/my_s3_repository

{
  "type": "s3",
  "settings": {
    "bucket": "your_bucket_no_slash",
    "region": "us-east-1",
    "access_key": "your_access_key",
    "secret_key": "your_secret_key"
  }
}
```

Use the included service script to regularly create new snapshots by adding it to your crontab:

```bash
chmod +x backup_es_to_s3.sh
cp backup_es_to_s3.sh /usr/local/bin

crontab -e

#!/bin/bash
00 00 * * * sh /usr/local/bin/backup_es_to_s3.sh
```
