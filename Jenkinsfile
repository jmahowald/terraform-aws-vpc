#!/usr/bin/env groovy

   def runWorkstation(args) {
      sh """
        docker run --rm -i \\
          -v \$(pwd):/workspace \\
          -e AWS_ACCESS_KEY=$AWS_ACCESS_KEY  \\
          -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \\
          -e TEST_RESULTS_DIR=/workspace \\
        joshmahowald/cloud-workstation ${args}
        """
   }
   
node {

  // git credentialsId: 'gitlabkey', url: "git@git.genesyslab.com:infrastructure/terraform-aws-vpc.git"
   checkout scm
 

    withEnv(["AWS_ACCESS_KEY=${env.AWS_ACCESS_KEY}",
    "AWS_SECRET_ACCESS_KEY=${env.AWS_SECRET_ACCESS_KEY}"]) {
      wrap([$class: 'AnsiColorBuildWrapper'])    
     {
        stage "plan"   
        runWorkstation("make -C tests plan")

        stage "test"
        runWorkstation("make -C tests test")
    }
    }

}
