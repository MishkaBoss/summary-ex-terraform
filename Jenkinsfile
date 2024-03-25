pipeline {
    agent any
    stages {
        stage('Clone Git Repository') {
             steps {
                sh 'rm -rf summary-ex-terraform'
                sh "git clone 'https://github.com/MishkaBoss/summary-ex-terraform.git'"
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

        stage('terraform destroy') {
            steps {
                sh 'terraform destroy -auto-approve'
            }
        }
    }
}