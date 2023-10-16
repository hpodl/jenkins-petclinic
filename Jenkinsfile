pipeline {
    agent any

    stages {
        stage('Checkstyle') {
            when {
                changeRequest target: 'main'
            }
            steps {
                echo 'Checking style..'
            }
        }
        stage('Test') {
            when {
                changeRequest target: 'main'
            }
            steps {
                echo 'Testing..'
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

                echo "${IMG_REPO}"

                echo 'Building image..'
                    docker.build("my-img")
                }
            }
        }
    }
}
