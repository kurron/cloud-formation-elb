#!/bin/bash

# creates a stack in AWS via CloudFromation

STACKNAME=${1:-Weapon-X-ELB}
PROJECTNAME=${2:-Weapon-X}
VPC=${3:-vpc-7b1b781c}
SECURITYGROUPS=${4:-sg-548bc62c}
SUBNETS=${5:-subnet-09e73b40,subnet-4164de26}
VISIBILITY=${6:-internet-facing}
ENVIRONMENT=${7:-development}
CREATOR=${8:-CloudFormation}
TEMPLATELOCATION=${9:-file://$(pwd)/elb.yml}

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
                                                     ParameterKey=LoadBalancerType,ParameterValue=$VISIBILITY \
                                                     ParameterKey=VPC,ParameterValue=$VPC \
                                                     ParameterKey=SecurityGroups,ParameterValue=\"$SECURITYGROUPS\" \
                                        --tags Key=Project,Value=$PROJECTNAME \
                                               Key=Environment,Value=$ENVIRONMENT \
                                               Key=Creator,Value=$CREATOR"
echo $CREATE
$CREATE
