#!/bin/sh

set -e

# create topic and wait for it to be set up
oc apply -f topic.yaml
oc wait kafkatopic performance-topic --for=condition=ready --timeout 1m

# run the performance workload and wait for it to complete
oc apply -f test.yaml
oc wait job performance-producer --for=condition=complete --timeout 15m

# get the result summaries
oc logs --tail=1000 -l app=performance-producer | grep "1000000 records sent"
