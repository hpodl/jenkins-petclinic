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
                // echo 'Building image..'
                // script{
                //     if (env.BRANCH_NAME == main) {
                //         echo "Is main"
                //         env.IMAGE_NAME = "mydockertestacc/main"
                //     } 
                //     else {
                //         echo "Is MR"
                //         env.IMAGE_NAME = "mydockertestacc/mr"
                //     }
                // }
                // echo "..named ${IMAGE_NAME}"
            }
        }
    }
}
