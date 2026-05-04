pipeline {
    agent any

    environment {
        IMAGE_NAME = "nixhal33/project-management"
        CONTAINER_NAME = "project-management"
    }

    stages {
        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/GreatStackDev/project-management.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push $IMAGE_NAME'
                }
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    docker stop $CONTAINER_NAME || true
                    docker rm $CONTAINER_NAME || true
                    docker compose up --build --force-recreate -d
                '''
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}
