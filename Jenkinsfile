pipeline {
    agent any

    environment {
        IMAGE_NAME = "raniakdm/velos-api"
        IMAGE_TAG  = "${env.BUILD_NUMBER}-${env.GIT_COMMIT.take(7)}"
    }

    stages {
        stage('Tester') {
            steps {
                sh 'docker build --target tests -t velos-api:test-${BUILD_NUMBER} .'
            }
        }

        stage('Construire') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
            }
        }

        stage('Publier') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASSWORD'
                )]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Deployer') {
            steps {
                withCredentials([file(
                    credentialsId: 'kubeconfig-kind',
                    variable: 'KUBECONFIG'
                )]) {
                    sh '''
                        kubectl --kubeconfig="$KUBECONFIG" set image deployment/api api=${IMAGE_NAME}:${IMAGE_TAG}
                        kubectl --kubeconfig="$KUBECONFIG" rollout status deployment/api --timeout=120s
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline termine.'
        }
        success {
            echo 'Tester, construire, publier et deployer reussis.'
        }
        failure {
            echo 'Le pipeline a echoue.'
        }
    }
}
