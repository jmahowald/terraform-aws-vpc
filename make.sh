#!/bin/sh

# This script makes packer available when not installed

#TODO put in internal repository tagged with
#specific version
IMAGE_NAME=joshmahowald/cloud-workstation

docker run -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -v $(pwd):/workspace \
  -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
  -e AWS_REGION=$AWS_REGION \
  $IMAGE_NAME make $@ 


  