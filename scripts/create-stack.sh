#!/bin/bash

# creates a stack in AWS via CloudFromation

STACKNAME=${1:-Weapon-X-ELB}
PROJECTNAME=${2:-Weapon-X}
VPC=${3:-vpc-9251cff5}
SECURITYGROUPS=${4:-sg-f786f38f}
SUBNETS=${5:-subnet-ad3cf6e4,subnet-3e2f9f59}
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
