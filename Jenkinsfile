pipeline {
    agent {
        kubernetes {
            defaultContainer 'jnlp'
            yamlFile 'agentpod.yaml'
        }
    }

    environment {
        GITHUB_CREDENTIALS = credentials('github-token')
        DOCKER_CREDENTIALS = credentials('docker-hub-credentials')
        DOCKER_IMAGE = 'hwwseo/hwseo-site'
        VERSION = "${BUILD_NUMBER}" // Jenkins 빌드 번호를 버전으로 사용
    }

    stages {
        stage('Checkout hwseo_site') {
            steps {
                container('jnlp') {
                    script {
                        // 'hwseo_site' 리포지토리에서 프로젝트 코드 체크아웃
                        git credentialsId: 'github-token', url: 'https://github.com/hwseo0406/hwseo_site.git', branch: 'main'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                container('docker') {
                    dir('.') { // 빌드 컨텍스트를 최상위 디렉토리로 변경
                        script {
                            def imageTag = "${DOCKER_IMAGE}:${VERSION}"
                            docker.build(imageTag, "-f Dockerfile .")
                        }
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                container('docker') {
                    script {
                        def imageTag = "${DOCKER_IMAGE}:${VERSION}"
                        docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                            docker.image(imageTag).push()
                        }
                    }
                }
            }
        }

    //     stage('Checkout k8s-manifests') {
    //         steps {
    //             container('jnlp') {
    //                 script {
    //                     // 'k8s-manifests' 리포지토리에서 매니페스트 코드 체크아웃
    //                     git credentialsId: 'github-token', url: 'https://github.com/hwseo0406/k8s-manifests.git', branch: 'main'
    //                 }
    //             }
    //         }
    //     }

    //     stage('Update nginx-deployment.yaml') {
    //         steps {
    //             script {
    //                 def newImage = "${DOCKER_IMAGE}:${VERSION}"
    //                 // 'k8s-manifests/manifests/deployments' 경로로 이동하여 nginx-deployment.yaml 파일 수정
    //                 dir('manifests/deployments') {
    //                     sh """
    //                     # 정규식을 사용하여 image 라인에서 태그 부분만 교체
    //                     sed -i 's|image: hanjunn/hanjun-site:[^ ]*|image: ${newImage}|g' nginx-deployment.yaml
    //                     cat nginx-deployment.yaml  # 변경 사항 확인
    //                     """
    //                 }
    //             }
    //         }
    //     }

    //     stage('Commit and Push nginx-deployment.yaml') {
    //         steps {
    //             container('jnlp') {
    //                 script {
    //                     withCredentials([usernamePassword(credentialsId: 'github-token', usernameVariable: 'GITHUB_USER', passwordVariable: 'GITHUB_TOKEN')]) {
    //                         sh """
    //                         git config --global user.email "qwedfr79@naver.com"
    //                         git config --global user.name "hanjunnn"
    //                         git remote set-url origin https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/hanjunnn/k8s-manifests.git
    //                         git add manifests/deployments/nginx-deployment.yaml
    //                         git commit -m "Update nginx deployment image version to ${VERSION} [skip ci]"
    //                         git push origin main
    //                         """
    //                     }
    //                 }
    //             }
    //         }
    //     }
     }

    post {
        success {
            echo 'Build, push, and deployment file update successful!'
        }
        failure {
            echo 'Build or push failed.'
        }
    }
}

