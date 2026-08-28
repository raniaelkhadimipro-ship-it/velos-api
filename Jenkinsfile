pipeline {
agent any

stages {

    stage('Tester') {
        steps {
            sh 'docker build -t velos-api:test .'
        }
    }

    stage('Construire') {
        steps {
            sh 'docker build -t raniakdm/velos-api:1.0 .'
        }
    }

    stage('Publier') {
        steps {
            withCredentials([usernamePassword(
                credentialsId: 'docker-hub',
                usernameVariable: 'DOCKER_USER',
                passwordVariable: 'DOCKER_PASSWORD'
            )]) {
                sh 
                    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USER" --password-stdin
                   sh 'docker push raniakdm/velos-api:1.0'
                
            }
        }
    }

    stage('Déployer') {
        steps {
            withCredentials([file(
                credentialsId: 'kubeconfig-kind',
                variable: 'KUBECONFIG'
            )]) {
                sh '''
                    kubectl --kubeconfig="$KUBECONFIG" set image deployment/velos-api \
                    velos-api=raniakdm/velos-api:1.0

                    kubectl --kubeconfig="$KUBECONFIG" rollout status deployment/velos-api --timeout=120s
                '''
            }
        }
    }
}

post {
    always {
        echo 'Pipeline terminé.'
    }

    success {
        echo 'Tester, construire, publier et déployer réussis.'
    }

    failure {
        echo 'Le pipeline a échoué.'
    }
}

}
