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
                echo "${BRANCH_NAME}"
                echo "${env.BRANCH_NAME}"

                echo 'Building image..'
                docker.build("my-img")
            }
        }
    }
}
