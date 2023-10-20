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
                      IMG_NAME = "main"
                    } else {
                      IMG_NAME = "mr"
                    }
    
                    IMG_REPO = "https://hub.docker.com/"
                    echo "Repo is: ${IMG_REPO}"
    
                    echo 'Building image..'
                       image = docker.build("${IMG_NAME}")
    
                    IMG_TAG = "${env.GIT_COMMIT.take(8)}" // workaround for short version of git commit id
                    echo "Tagging with: ${IMG_TAG}"
                    docker.withRegistry("${IMG_REPO}", "dockerhub-login"){
                        image.push("mydockertestacc/${IMG_NAME}")
                        image.push("$IMG_TAG")
                    }   
                }
            }
        }
    }
}
