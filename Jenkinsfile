pipeline {
    agent any

    environment {
        REGISTRY    = "192.168.100.102:5000"
        APP_NAME    = "cups-reporting"
        IMAGE       = "${REGISTRY}/${APP_NAME}:${BUILD_NUMBER}"
        NAMESPACE   = "printing"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'git@github.com:mamungtg/cups-reporting.git',
                    credentialsId: 'github-ssh'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE} ."
            }
        }

        stage('Push to Registry') {
            steps {
                sh "docker push ${IMAGE}"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                helm upgrade --install ${APP_NAME} charts/cups-reporting-helm \
                    --namespace ${NAMESPACE} --create-namespace \
                    --set image.repository=${REGISTRY}/${APP_NAME} \
                    --set image.tag=${BUILD_NUMBER}
                """
            }
        }

        stage('Verify Deployment') {
            steps {
                sh "kubectl rollout status deployment/${APP_NAME} -n ${NAMESPACE} --timeout=60s"
            }
        }
    }

    post {
        failure {
            sh "kubectl rollout undo deployment/${APP_NAME} -n ${NAMESPACE}"
        }
    }
}
