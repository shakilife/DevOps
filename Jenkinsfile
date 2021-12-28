pipeline {
  agent {
    kubernetes {
      defaultContainer 'jenkins-slave-general'
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: jenkins-slave-general
            image: shakilife/awsagent:v1.2
            command:
            - cat
            tty: true
        '''
    }
  }
    environment {
    AWS_DEFAULT_REGION="us-east-1"
  }
  stages {
    stage('Check version') {
      steps {
        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-auto-user', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          sh '''
             aws --version
             ansible --version
             python3 --version
             aws ec2 describe-vpcs
             aws ec2 describe-instances
             git version
             cd Devops && python3 list_user.py
          '''
          }
      }
    }
  }
}
