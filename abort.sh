#!/bin/bash

# Change this
export HOST="oda-258e6..............ddcd0bb-da4.data.digitalassistant.oci.oraclecloud.com"

echo "Host $HOST\n"

export REQ_IND_TO_ABORT=$1

SKILL_ID=$(./oci-curl $HOST get "/api/v1/skills" | jq -r ".items[1].id")

#echo $SKILL_ID

ENTITY_ID=$(./oci-curl $HOST get "/api/v1/bots/$SKILL_ID/dynamicEntities/" | jq -r ".items[0].id")

#echo $ENTITY_ID

if [ -n "$1" ]
then
    echo "Aborting pushRequests index $REQ_IND_TO_ABORT"

    REQ_ID=$(./oci-curl $HOST get "/api/v1/bots/$SKILL_ID/dynamicEntities/$ENTITY_ID/pushRequests" | jq -r ".items[$REQ_IND_TO_ABORT].id")

    echo $REQ_ID

    ./oci-curl $HOST put ./empty.json "/api/v1/bots/$SKILL_ID/dynamicEntities/$ENTITY_ID/pushRequests/$REQ_ID/abort"
else
    RES=$(./oci-curl $HOST get "/api/v1/bots/$SKILL_ID/dynamicEntities/$ENTITY_ID/pushRequests")
    
    COUNT=$(echo $RES | jq -r ".count")
    
    echo "Total requests $COUNT:"
    
    for (( i=0; i < $COUNT; i++ ))
    do
       :
       ID=$(echo $RES | jq -r ".items[$i].id")
       STATUS=$(echo $RES | jq -r ".items[$i].status")
       echo "$i $ID $STATUS"
    done
fi

