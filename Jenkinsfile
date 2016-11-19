#!/usr/bin/env groovy

import java.nio.file.Paths;

node {

  // git credentialsId: 'gitlabkey', url: "git@git.genesyslab.com:infrastructure/terraform-aws-vpc.git"
   checkout scm
   stage 'Stage 1.1'
   echo 'Hello World 1'
   stage 'Stage 2'
   echo 'Hello World 2'

   stage "plan test"


   withDockerContainer(args: dockerArgs, image:'cloud-workstation') {
     sh "touch file.txt"
     sh "chmod 600 file.txt"
     sh "cd tests; make plan"
     // some block
    }


}
