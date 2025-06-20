pipeline {
    agent any

    environment {
        IMAGE_NAME = 'gallegojl1/mi-web2'
        TAG = 'latest'
        DOCKERHUB_CREDENTIALS = credentials('joseluis-dockerhub')  // Reemplaza con tu ID de credencial
        REMOTE_HOST = '217.160.88.215' // ⚠️ Cambia esto por la IP real de tu servidor
        REMOTE_USER = 'root'        // ⚠️ Cambia esto por el usuario SSH de tu servidor
        REMOTE_PORT = '22'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/gallegojl1/pagina_sencilla.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$TAG .'
            }
        }
        stage('Build Docker Image2') {
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
    
        stage('Deploy to Remote Server') {
            steps {
                sshagent (credentials: ['remote-server-ssh']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no $REMOTE_USER@$REMOTE_HOST -p $REMOTE_PORT '
                            echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin &&     // con esto se logea en dockerhub antes de descargare la imagen; el token de de dockerhub lo he dado de alta en jenkins
                            docker pull $IMAGE_NAME:$TAG &&
                            docker stop mi-web
                            docker rm -f mi-web
                            docker run -d -p 8080:80 --name mi-web $IMAGE_NAME:$TAG
                        '
                    """
                }
            }
        }
   }
    post {
        success {
            echo '✅ Página web desplegada correctamente. Visita http://localhost:8081'
        }
        failure {
            echo '❌ Falló el proceso.'
        }
    }
}
