pipeline {
    agent any

    environment {
        MAVEN_HOME = tool(name: 'Maven', type: 'maven')
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_IMAGE = 'test-project'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh "${MAVEN_HOME}/bin/mvn clean package"
            }
        }

        stage('Test') {
            steps {
                sh "${MAVEN_HOME}/bin/mvn test"
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${BUILD_NUMBER} ."
            }
        }

        stage('Publish Docker Image') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-credentials', url: "https://${DOCKER_REGISTRY}"]) {
                    sh "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${BUILD_NUMBER}"
                }
            }
        }
    }

    post {
        success {
            echo 'Build and deployment completed successfully.'
        }
        failure {
            echo 'Build or deployment failed.'
        }
    }
}

