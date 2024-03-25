pipeline {
    agent any
    stages {
        stage('git clone') {
            steps {
                sh 'rm -rf finalEx'
                sh "git clone 'https://github.com/MishkaBoss/finalEx.git'"
            }
        }

        stage('Delete previous image if exists and build docker image') {
            steps {
                script {
                    def imageExists = sh(script: 'docker images -q final-ex-todo-app', returnStdout: true).trim()
                    if (imageExists) {
                        sh 'docker rmi -f final-ex-todo-app'
                    }
                }
        sh 'docker build -t final-ex-todo-app ./finalEx'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerHubCredentials', passwordVariable: 'DOCKER_HUB_PASSWORD', usernameVariable: 'DOCKER_HUB_USERNAME')]) {
                    sh 'docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD'
                }
            }
        }

        stage('Push image to docker hub') {
            steps {
                sh 'docker tag final-ex-todo-app:latest devoops93/todo-app:v${BUILD_NUMBER}'
                sh 'docker push devoops93/todo-app:v${BUILD_NUMBER}'
            }
        }

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