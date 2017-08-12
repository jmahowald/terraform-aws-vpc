FROM artifactory.corp.code42.com:5000/c42/cloud-workstation

RUN mkdir -p /opt/terraform/aws-vpc
ADD . /opt/terraform/aws-vpc 
