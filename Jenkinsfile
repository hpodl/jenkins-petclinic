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
                echo 'Testing..'
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
                  IMG_REPO = "main"
                } else {
                  IMG_REPO = "mr"
                }

                echo "Repo is: ${IMG_REPO}"

                echo 'Building image..'
                    docker.build("my-img")
                }
            }
        }
    }
}
