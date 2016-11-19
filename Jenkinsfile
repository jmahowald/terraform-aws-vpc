#!/usr/bin/env groovy


node {

  // git credentialsId: 'gitlabkey', url: "git@git.genesyslab.com:infrastructure/terraform-aws-vpc.git"
   checkout scm
 
  properties([[$class: 'GitLabConnectionProperty', gitLabConnection: 'gitlab']])
   def runWorkstation(args) {
      sh """
        docker run --rm -i \\
          -v \$(pwd):/workspace \\
          -e TEST_RESULTS_DIR=/workspace \\
        joshmahowald/cloud-workstation ${args}
        """
   }
  
    wrap([$class: 'AnsiColorBuildWrapper'])    
     {
        stage "plan"   
        runWorkstation("make -C tests plan")

        stage "test"
        runWorkstation("make -C tests test")
    }


}
