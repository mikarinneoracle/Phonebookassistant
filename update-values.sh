#!/bin/bash

# Change this
export HOST="oda-258e6..............ddcd0bb-da4.data.digitalassistant.oci.oraclecloud.com"

echo "Host $HOST\n"

export SKILL_IND_TO_UPDATE=$1

# Expects to find only one Dynamic Entity (index=0), adjust if necessary
export ENTITY_IND_TO_UPDATE=0

if [ -n "$1" ]
then
    SKILL_ID=$(./oci-curl $HOST get "/api/v1/skills" | jq -r ".items[$SKILL_IND_TO_UPDATE].id")

    SKILL_NAME=$(./oci-curl $HOST get "/api/v1/skills" | jq -r ".items[$SKILL_IND_TO_UPDATE].name")

    echo "Skill $SKILL_IND_TO_UPDATE: $SKILL_ID $SKILL_NAME"

    ENTITY_ID=$(./oci-curl $HOST get "/api/v1/bots/$SKILL_ID/dynamicEntities/" | jq -r ".items[$ENTITY_IND_TO_UPDATE].id")

    ENTITY_NAME=$(./oci-curl $HOST get "/api/v1/bots/$SKILL_ID/dynamicEntities/" | jq -r ".items[$ENTITY_IND_TO_UPDATE].name")

    echo "Entity $ENTITY_IND_TO_UPDATE: $ENTITY_ID $ENTITY_NAME"

    #echo /api/v1/bots/$SKILL_ID/dynamicEntities/$ENTITY_ID/pushRequests

    REQ_ID=$(./oci-curl $HOST post ./empty.json "/api/v1/bots/$SKILL_ID/dynamicEntities/$ENTITY_ID/pushRequests" | jq -r ".id")

    #echo $REQ_ID

    echo "\\nPatching values for $SKILL_NAME $ENTITY_NAME entity, request $REQ_ID\n"

    ./oci-curl $HOST patch ./values.json "/api/v1/bots/$SKILL_ID/dynamicEntities/$ENTITY_ID/pushRequests/$REQ_ID/values"

    echo "\nPatching completed\n"

    ./oci-curl $HOST put ./empty.json "/api/v1/bots/$SKILL_ID/dynamicEntities/$ENTITY_ID/pushRequests/$REQ_ID/done"
else
    RES=$(./oci-curl $HOST get "/api/v1/skills")
    
    COUNT=$(echo $RES | jq -r ".count")
    
    echo "Total skills $COUNT:"
    
    for (( i=0; i < $COUNT; i++ ))
    do
       :
       SKILL_ID=$(echo $RES | jq -r ".items[$i].id")
       SKILL_NAME=$(echo $RES | jq -r ".items[$i].name")
       SKILL_VERSION=$(echo $RES | jq -r ".items[$i].version")
       SKILL_STATUS=$(echo $RES | jq -r ".items[$i].status")
       
       ENTITY_NAME=$(./oci-curl $HOST get "/api/v1/bots/$SKILL_ID/dynamicEntities/" | jq -r ".items[$ENTITY_IND_TO_UPDATE].name")
       
       if [ "$ENTITY_NAME" != "null" ]
       then
           echo "$i $SKILL_ID $SKILL_NAME $SKILL_VERSION $SKILL_STATUS : Entity $ENTITY_NAME"
       else
           echo "$i $SKILL_ID $SKILL_NAME $SKILL_VERSION $SKILL_STATUS : -"
       fi
       
    done
fi

echo "\n"