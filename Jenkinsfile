pipeline {
    agent any

    environment {
        REGISTRY = "192.168.100.102:5000"
        IMAGE_NAME = "cups-reporting"
        NAMESPACE = "printing"
        HELM_RELEASE = "cups-reporting"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/mamungtg/cups-reporting.git', credentialsId: 'github-credentials'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-credentials',
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
                    withCredentials([file(credentialsId: 'kubeconfig-secret', variable: 'KUBECONFIG')]) {
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
}
