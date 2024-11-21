pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'hwwseo/hwseo-site:latest'
        DOCKER_REGISTRY = 'docker.io'
        K8S_CONFIG = '/home/jenkins/.kube/config'
    }

    stages {
        stage('Clone Template') {
            steps {
                git 'https://github.com/hwseo0406/hwseo_site.git'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t hwwseo/hwseo-site:latest .'
                }
            }
        }
        
        stage('Docker Hub Login') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: hwwseo, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                    }
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    // Docker 이미지 푸시
                    sh 'docker push hwwseo/hwseo-site:latest'
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh 'kubectl --kubeconfig=${K8S_CONFIG} apply -f my_template/nginx-deployment.yaml'
                }
            }
        }
    }
    
    post {
        success {
            echo 'success'
        }
        failure {
            echo 'fail'
        }
    }
}