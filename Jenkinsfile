pipeline {
    agent any
    
    options {
        buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '10'))
    }
 
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
    
                    IMG_REPO = "https://index.docker.io/v1/"
                    echo "Repo is: ${IMG_REPO}"
    
                    echo 'Building image..'
                       image = docker.build("mydockertestacc/${IMG_NAME}")
    
                    IMG_TAG = "${env.GIT_COMMIT.take(8)}" // workaround for short version of git commit id
                    echo "Tagging with: ${IMG_TAG}"
                    docker.withRegistry("${IMG_REPO}", "dockerhub-login"){
                        image.push("$IMG_TAG")
                    }   
                }
            }
        }
        stage('Deploy new version') {
            when {
                anyOf {
                    branch 'main'
                    changeRequest()
                }
            } 
            
            steps {
                node {
                    def remote = [:]
                    remote.name = 'test'
                    remote.host = 'test.domain.com'
                    remote.user = 'root'
                    remote.password = 'password'
                    remote.allowAnyHosts = true
                    stage('Remote SSH') {
                        sshCommand remote: remote, command: "docker ps | grep"
                    }
                }
            }
        }
    }
}
