#!/usr/bin/env groovy
 
node {
  // git credentialsId: 'gitlabkey', url: "git@git.genesyslab.com:infrastructure/terraform-aws-vpc.git"
   checkout scm
      wrap([$class: 'AnsiColorBuildWrapper'])    
      {   
        withEnv(["AWS_ACCESS_KEY=${env.AWS_ACCESS_KEY}",
        "AWS_SECRET_ACCESS_KEY=${env.AWS_SECRET_ACCESS_KEY}"]) {
          stage "plan"   
          sh "./make.sh -C tests plan"

          stage "test"
          sh "./make.sh -C tests test"
        }
    }
}
