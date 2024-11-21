pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'hwwseo/hwseo-site:latest'
        DOCKER_REGISTRY = 'docker.io'
        K8S_CONFIG = '/home/jenkins/.kube/config' // Kubeconfig 파일 경로 설정
    }

    stages {
        stage('Clone Template') {
            steps {
                // GitHub에서 템플릿 클론
                git 'https://github.com/hwseo0406/hwseo_site.git'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Docker 이미지 빌드 (Dockerfile 경로 지정)
                    echo 'Starting Docker Build...'
                    def buildResult = sh(script: 'docker build --no-cache --progress=plain -f Dockerfile -t $DOCKER_IMAGE .', returnStdout: true)
                    echo buildResult // 빌드 로그를 출력
                }
            }
        }
        
        stage('Docker Hub Login') {
            steps {
                script {
                    // Docker Hub 로그인
                    withCredentials([usernamePassword(credentialsId: 'hwwseo', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        echo 'Logging into Docker Hub...'
                        def loginResult = sh(script: 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin', returnStdout: true)
                        echo loginResult // 로그인 결과 출력
                    }
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    // Docker 이미지 푸시
                    echo 'Pushing Docker image to Docker Hub...'
                    def pushResult = sh(script: 'docker push $DOCKER_IMAGE', returnStdout: true)
                    echo pushResult // 푸시 로그 출력
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Kubernetes에 배포
                    echo 'Deploying to Kubernetes...'
                    def deployResult = sh(script: 'kubectl --kubeconfig=${K8S_CONFIG} apply -f my_template/nginx-deployment.yaml', returnStdout: true)
                    echo deployResult // 배포 로그 출력
                }
            }
        }
    }
    
    post {
        success {
            echo '빌드 및 배포가 성공적으로 완료되었습니다.'
        }
        failure {
            echo '빌드 또는 배포 중 오류가 발생했습니다.'
        }
    }
}
