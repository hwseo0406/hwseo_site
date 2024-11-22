pipeline {
    agent any

    stages {
        stage('Clone Template') {
            steps {
                echo "Cloning GitHub repository..."
                git 'https://github.com/hwseo0406/hwseo_site.git'
            }
        }

        stage('Build Podman Image') {
            steps {
                echo "Building Image with Podman..."
                script {
                    sh '''
                        podman build -t hwwseo/hwseo-site:latest .
                    '''
                }
            }
        }

        stage('Podman Login to Docker Hub') {
            steps {
                echo "Logging in to Docker Hub using Podman..."
                script {
                    withCredentials([usernamePassword(credentialsId: 'hwwseo', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh '''
                            echo $DOCKER_PASSWORD | podman login -u $DOCKER_USERNAME --password-stdin docker.io
                        '''
                    }
                }
            }
        }

        stage('Push Podman Image') {
            steps {
                echo "Pushing Image to Docker Hub using Podman..."
                script {
                    sh '''
                        podman push hwwseo/hwseo-site:latest
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "Deploying to Kubernetes..."
                script {
                    sh '''
                        kubectl apply -f nginx-deployment.yaml
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '빌드 및 배포 성공!'
        }
        failure {
            echo '빌드 또는 배포 실패!'
        }
    }
}
