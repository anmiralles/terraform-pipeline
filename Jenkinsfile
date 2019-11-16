// Jenkinsfile
def COLOR_MAP = ['SUCCESS': 'good', 'FAILURE': 'danger', 'UNSTABLE': 'danger', 'ABORTED': 'danger']

def getBuildUser() {
    return currentBuild.rawBuild.getCause(Cause.UserIdCause).getUserId()
}

pipeline {
  agent any

  stages {
    stage('checkout') {
      steps {
        cleanWs()
        checkout scm
      }
    }
    stage('terraform_setup') {
      steps {
        script {
          def tfHome = tool name: 'Terraform'
          env.PATH = "${tfHome}:${env.PATH}"
        }
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws_credentials',
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
          ansiColor('xterm') {
            sh 'terraform version'
            sh 'terraform init'
          }
        }
      }
    }
    stage('terraform_plan_apply') {
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws_credentials',
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
          ansiColor('xterm') {
            sh 'terraform plan -out=plan'
          sh "terraform apply -auto-approve"
          }
        }
      }  
    }
  }
  post {
    always {
      script {
        BUILD_USER = getBuildUser()
      }
      echo 'I will always say Hello again!'
    
      slackSend channel: '#rpa-devops',
        color: COLOR_MAP[currentBuild.currentResult],
        message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} by ${BUILD_USER}\n More info at: ${env.BUILD_URL}"
    }  
  }
} 
