pipeline {
    agent any

    stages {
        stage('Checkstyle') {
            when {
                changeRequest target: 'main'
            }
            steps {
                echo 'Checking style..'
                sh 'mvn checkstyle:checkstyle'
            }
        }
        stage('Test') {
            when {
                changeRequest target: 'main'
            }
            steps {
                echo 'Testing...'
                sh 'mvn test'
            }
        }
        stage('Build') {
            when {
                anyOf {
                    branch 'main'
                    changeRequest()
                }
            }
            steps {
                script {
                if (env.BRANCH_NAME == "main"){
                  IMG_REPO = "https://hub.docker.com/repositories/mydockertestacc/main"
                } else {
                  IMG_REPO = "https://hub.docker.com/repositories/mydockertestacc/mr"
                }

                echo "Repo is: ${IMG_REPO}"

                echo 'Building image..'
                   image = docker.build("my-img")

                docker.withRegistry(${IMG_REPO}, "dockerhub-login"){
                    image.push("${env.GIT_COMMIT.take(8)}")
                }
                    
                }
            }
        }
    }
}
