#!/bin/bash -x

# H/T https://alestic.com/2010/12/ec2-user-data-output/
# Useful to see what happens during startup
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

yum install -y jq docker

service docker start
sudo usermod -a -G docker ec2-user

# Thanks to
# https://limecodeblog.wordpress.com/2016/09/19/consul-cluster-in-aws-with-auto-scaling/
# https://raw.githubusercontent.com/babtist/limestone-consul/master/cloudformation/consul.json

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

ASG_NAME=$(aws autoscaling --region ${region} describe-auto-scaling-instances \
 --instance-id $INSTANCE_ID \
| jq -r '.AutoScalingInstances[0].AutoScalingGroupName')

INSTANCE_IDS=$(aws autoscaling  --region ${region}  describe-auto-scaling-groups \
--auto-scaling-group-name $ASG_NAME | \
jq -r '.AutoScalingGroups[0].Instances[] | .InstanceId')

INSTANCE_DNS_NAMES=$(aws --region ${region} ec2 describe-instances --instance-ids $INSTANCE_IDS \
 | jq -r '.Reservations[].Instances[] | .PrivateDnsName')


INSTANCE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

docker run -d --net=host -h $INSTANCE_ID -v /var/consul:/consul/data \
   -e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt" : true,"addresses":{"http": "$INSTANCE_IP"}}' -P \
   --restart always --name consul -p 8500:8500 \
   consul agent -server -bind $INSTANCE_IP \
     -bootstrap-expect ${num_servers} -retry-join $INSTANCE_DNS_NAMES -ui
