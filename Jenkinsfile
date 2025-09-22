pipeline {
    agent any

    environment {
        REMOTE_HOST = '217.160.88.215'   // ⚠️ tu IP real
        REMOTE_USER = 'root'             // ⚠️ tu usuario SSH
        REMOTE_PORT = '22'
        APP_DIR = '/root/pagina_sencilla'  // Carpeta fija en el servidor remoto
    }

    stages {
        stage('Checkout (solo para pruebas locales en Jenkins)') {
            steps {
                git url: 'https://github.com/gallegojl1/pagina_sencilla.git', branch: 'main'
            }
        }

        stage('Deploy to Remote Server') {
            steps {
                sshagent (credentials: ['remote-server-ssh']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no -p $REMOTE_PORT $REMOTE_USER@$REMOTE_HOST '
                            # Crear carpeta si no existe
                            mkdir -p $APP_DIR
                            
                            # Ir a la carpeta y clonar o actualizar el repo
                            if [ -d "$APP_DIR/.git" ]; then
                                cd $APP_DIR && git pull
                            else
                                git clone https://github.com/gallegojl1/pagina_sencilla.git $APP_DIR
                            fi
                            
                            # Construir la imagen en el servidor
                            cd $APP_DIR
                            docker build -t mi-web:latest .
                            
                            # Parar y borrar contenedor anterior
                            docker stop mi-web || true
                            docker rm -f mi-web || true
                            
                            # Levantar nuevo contenedor
                            docker run -d -p 8080:80 --name mi-web mi-web:latest
                        '
                    """
                }
            }
        }
    }

    post {
        success {
            echo '✅ Página web desplegada correctamente en el servidor remoto.'
        }
        failure {
            echo '❌ Falló el despliegue.'
        }
    }
}
