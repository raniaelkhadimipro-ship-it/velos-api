pipeline {
agent any

stages {
    stage('Checkout') {
        steps {
            checkout scm
        }
    }

    stage('Build & Tests Docker') {
        steps {
            sh 'docker build -t velos-api:latest .'
        }
    }
}

post {
    always {
        echo 'Pipeline terminé.'
    }
    success {
        echo 'Build Docker et tests réussis.'
    }
    failure {
        echo 'Le pipeline a échoué.'
    }
}

}
