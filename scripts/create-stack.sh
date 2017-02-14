#!/bin/bash

# creates a stack in AWS via CloudFromation

STACKNAME=${1:-Weapon-X-ECS}
PROJECTNAME=${2:-Weapon-X}
INSTANCETYPE=${3:-m4.large}
SPOTPRICE=${4:-0.025}
ENVIRONMENT=${5:-development}
CREATOR=${6:-CloudFormation}
TEMPLATELOCATION=${7:-file://$(pwd)/ecs.yml}

VALIDATE="aws cloudformation validate-template --template-body $TEMPLATELOCATION"
echo $VALIDATE
$VALIDATE

CREATE="aws cloudformation create-stack --stack-name $STACKNAME \
                                        --template-body $TEMPLATELOCATION \
                                        --capabilities CAPABILITY_NAMED_IAM \
                                        --parameters ParameterKey=Project,ParameterValue=$PROJECTNAME \
                                                     ParameterKey=Environment,ParameterValue=$ENVIRONMENT \
                                                     ParameterKey=Creator,ParameterValue=$CREATOR \
                                                     ParameterKey=InstanceType,ParameterValue=$INSTANCETYPE \
                                                     ParameterKey=SpotPrice,ParameterValue=$SPOTPRICE \
                                        --tags Key=Project,Value=$PROJECTNAME \
                                               Key=Environment,Value=$ENVIRONMENT \
                                               Key=Creator,Value=$CREATOR"
echo $CREATE
$CREATE
