#!/bin/bash

# creates a stack in AWS via CloudFromation

STACKNAME=${1:-Weapon-X-ELB}
PROJECTNAME=${2:-Weapon-X}
VPC=${3:-vpc-bd6df4da}
SECURITYGROUPS=${4:-sg-d0b6c0a8}
SUBNETS=${5:-subnet-362bfe7f,subnet-9a16a5fd}
ENVIRONMENT=${6:-development}
CREATOR=${7:-CloudFormation}
TEMPLATELOCATION=${8:-file://$(pwd)/elb.yml}

VALIDATE="aws cloudformation validate-template --template-body $TEMPLATELOCATION"
echo $VALIDATE
$VALIDATE

CREATE="aws cloudformation create-stack --stack-name $STACKNAME \
                                        --template-body $TEMPLATELOCATION \
                                        --capabilities CAPABILITY_NAMED_IAM \
                                        --parameters ParameterKey=Project,ParameterValue=$PROJECTNAME \
                                                     ParameterKey=Environment,ParameterValue=$ENVIRONMENT \
                                                     ParameterKey=Creator,ParameterValue=$CREATOR \
                                                     ParameterKey=Subnets,ParameterValue=\"$SUBNETS\" \
                                                     ParameterKey=VPC,ParameterValue=$VPC \
                                                     ParameterKey=SecurityGroups,ParameterValue=\"$SECURITYGROUPS\" \
                                        --tags Key=Project,Value=$PROJECTNAME \
                                               Key=Environment,Value=$ENVIRONMENT \
                                               Key=Creator,Value=$CREATOR"
echo $CREATE
$CREATE
