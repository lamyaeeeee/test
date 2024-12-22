pipeline {
    agent any

    environment {
        MAVEN_HOME = tool(name: 'Maven', type: 'maven')
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_IMAGE = 'lamyae_app'
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
                sh './deploy_to_server.sh'
            }
        }
    }

    post {
        success {
            echo 'Build et déploiement terminés avec succès.'
        }
        failure {
            echo 'Le build ou le déploiement a échoué.'
        }
    }
}
