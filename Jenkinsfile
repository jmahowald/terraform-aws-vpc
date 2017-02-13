#!/usr/bin/env groovy
 
node {
  // git credentialsId: 'gitlabkey', url: "git@git.genesyslab.com:infrastructure/terraform-aws-vpc.git"
   checkout scm
      wrap([$class: 'AnsiColorBuildWrapper'])    
      {   
        withEnv(["AWS_ACCESS_KEY=${env.AWS_ACCESS_KEY}",
        "AWS_SECRET_ACCESS_KEY=${env.AWS_SECRET_ACCESS_KEY}"]) {
          try {
            stage "plan"   
            sh "./make.sh -C tests plan || ./make.sh -C tests clean"

            stage "test"
            sh "./make.sh -C tests test"
          }
          catch(error) {
            // emailext attachLog: true, body: "Build failed (see ${env.BUILD_URL}): ${error}", subject: "[JENKINS] ${env.JOB_NAME} failed", to: 'josh.mahowald@genesys.com'
            //We don't want vpc instances lieing around'
            sh "./make.sh -C tests clean"
          }
        }
    }
}
