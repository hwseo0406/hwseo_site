pipeline {
    agent any

    environment {
        GITHUB_CREDENTIALS = credentials('github-token')  // GitHub 토큰을 Jenkins의 Credentials에서 불러옵니다.
        DOCKER_CREDENTIALS = credentials('docker-hub-credentials')  // Docker Hub 자격 증명을 Jenkins에서 불러옵니다.
        DOCKER_IMAGE = 'hwwseo/hwseo-site'  // Podman 이미지 이름
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

        stage('Build Podman Image') {
            steps {
                script {
                    // Dockerfile을 사용하여 이미지를 Podman으로 빌드
                    def imageTag = "${DOCKER_IMAGE}:${VERSION}"
                    sh """
                        podman build -t ${imageTag} .
                    """
                }
            }
        }

        stage('Push Podman Image') {
            steps {
                script {
                    // Podman을 사용하여 Docker Hub로 이미지를 푸시
                    def imageTag = "${DOCKER_IMAGE}:${VERSION}"
                    sh """
                        podman login -u ${DOCKER_CREDENTIALS_USR} -p ${DOCKER_CREDENTIALS_PSW}
                        podman push ${imageTag}
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Podman 이미지 빌드 및 푸시 성공!'
        }
        failure {
            echo 'Podman 이미지 빌드 또는 푸시 실패!'
        }
    }
}
