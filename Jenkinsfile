pipeline {
    agent any

    environment {
        REGISTRY    = "192.168.100.102:5000"
        IMAGE_NAME  = "cups-reporting"
        NAMESPACE   = "printing"
        HELM_RELEASE = "cups-reporting"
    }

    stages {
        // Jenkins will automatically check out the repo here (Declarative checkout)

        stage('Docker Build & Push') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS')]) {
                        sh """
                            echo $DOCKER_PASS | docker login $REGISTRY -u $DOCKER_USER --password-stdin
                            docker build -t $REGISTRY/$IMAGE_NAME:${BUILD_NUMBER} .
                            docker push $REGISTRY/$IMAGE_NAME:${BUILD_NUMBER}
                        """
                    }
                }
            }
        }

        stage('Helm Deploy') {
            steps {
                script {
                    withCredentials([file(
                        credentialsId: 'kubeconfig-secret',
                        variable: 'KUBECONFIG')]) {
                        sh """
                            export KUBECONFIG=$KUBECONFIG
                            helm upgrade --install $HELM_RELEASE charts/cups-reporting-helm \
                                --namespace $NAMESPACE --create-namespace \
                                --set image.repository=$REGISTRY/$IMAGE_NAME \
                                --set image.tag=${BUILD_NUMBER}
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment succeeded!"
        }
        failure {
            echo "❌ Pipeline failed. Check logs for error details."
        }
    }
}
