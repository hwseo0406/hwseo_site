pipeline {
    agent {
        kubernetes {
            defaultContainer 'jnlp'
            label 'docker-agent'
            yamlFile 'agentpod.yaml'
        }
    }

    environment {
        GITHUB_CREDENTIALS = credentials('github-token')  // GitHub 토큰을 Jenkins의 Credentials에서 불러옵니다.
        DOCKER_CREDENTIALS = credentials('docker-hub-credentials')  // Docker Hub 자격 증명을 Jenkins에서 불러옵니다.
        DOCKER_IMAGE = 'hwwseo/hwseo-site'  // Docker 이미지 이름
        VERSION = "${BUILD_NUMBER}"  // Jenkins 빌드 번호를 버전으로 사용
    }

    stages {
        stage('Clone my-template') {
            steps {
                script {
                    // GitHub에서 리포지토리 클론
                    git credentialsId: 'github-token', url: 'https://github.com/hwseo0406/hwseo_site.git', branch: 'main'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Dockerfile을 사용하여 이미지를 빌드
                    def imageTag = "${DOCKER_IMAGE}:${VERSION}"
                    sh """
                        docker build -t ${imageTag} .
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Docker Hub로 이미지를 푸시
                    def imageTag = "${DOCKER_IMAGE}:${VERSION}"
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                        docker.image(imageTag).push()
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Docker 이미지 빌드 및 푸시 성공!'
        }
        failure {
            echo 'Docker 이미지 빌드 또는 푸시 실패!'
        }
    }
}
