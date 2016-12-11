#!/bin/sh

#TODO fail if these aren't here


docker run -d --net=host -h node${index} -v /var/consul:/consul/data \
   -e 'CONSUL_LOCAL_CONFIG=${consul_local_config}' -P \
   --restart always --name consul \
   consul agent -server -bind ${address} \
     -bootstrap-expect ${num_servers} -retry-join ${root_address} -ui
