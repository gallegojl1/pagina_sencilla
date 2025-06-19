pipeline {
    agent any

    environment {
        IMAGE_NAME = 'gallegojl1/mi-web'
        TAG = 'latest'
        DOCKERHUB_CREDENTIALS = credentials('joseluis-dockerhub')  // Reemplaza con tu ID de credencial
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/gallegojl1/mi-web.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$TAG .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'joseluis-dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $IMAGE_NAME:$TAG
                    '''
                }
            }
        }

        stage('Run Container Locally') {
            steps {
                sh 'docker rm -f mi-web || true'
                sh 'docker run -d -p 8080:80 --name mi-web $IMAGE_NAME:$TAG'
            }
        }
    }

    post {
        success {
            echo '✅ Página web desplegada correctamente. Visita http://localhost:8080'
        }
        failure {
            echo '❌ Falló el proceso.'
        }
    }
}
