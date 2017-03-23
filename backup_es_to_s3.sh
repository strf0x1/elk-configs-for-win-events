#!/bin/bash
TS=$(date +%s)
curl -XPUT "http://your.server.domain.com:9200/_snapshot/my_s3_repository/snapshot_$TS?wait_for_completion=true"
if [ $? -ne 0 ]; then
    #do something, in our case send an alert via Ramble
    TIME_FAILED=$(date)
    ramble -s "Alert: Snapshot Failed" -b "The snapshot failed at $TIME_FAILED. Login and check the script for more information."
fi
