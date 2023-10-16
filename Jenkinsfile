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
                echo 'Building image..'
                script{
                    if (env.BRANCH_NAME == main) {
                        echo "Is main"
                    } 
                    else {
                        echo "Is MR"
                    }
                }
            }
        }
    }
}
