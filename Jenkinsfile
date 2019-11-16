// Jenkinsfile
def COLOR_MAP = ['SUCCESS': 'good', 'FAILURE': 'danger', 'UNSTABLE': 'danger', 'ABORTED': 'danger']

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
          credentialsId: '21cbb50b-94da-480a-8114-c309d6a11950',
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
          credentialsId: '21cbb50b-94da-480a-8114-c309d6a11950',
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
      echo 'This is a success!'
    }  
  }
} 
