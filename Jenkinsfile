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
                    if (env.BRANCH_NAME == "main") {
                           withCredentials([usernamePassword(credentialsId: 'gh_user', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                            sh """
                                git pull --tags https://$USERNAME:$PASSWORD@github.com/hpodl/jenkins-petclinic -f
                            """
                        }
                        IMG_NAME = "main"
                        IMG_TAG = sh (
                            script: 'python3 ./semver_bump.py',
                            returnStdout: true
                        ).trim()

                        withCredentials([usernamePassword(credentialsId: 'gh_user', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                            sh """
                                git tag $IMG_TAG
                                git push --tags https://$USERNAME:$PASSWORD@github.com/hpodl/jenkins-petclinic -f
                            """
                        }
                    } else {
                      IMG_NAME = "mr"
                      IMG_TAG = "${env.GIT_COMMIT.take(8)}" // workaround for short version of git commit id
                    }
    
                    IMG_REPO = "https://index.docker.io/v1/"
                    echo "Repo is: ${IMG_REPO}"
    
                    echo 'Building image..'
                       image = docker.build("mydockertestacc/${IMG_NAME}")
    
                    echo "Tagging with: ${IMG_TAG}"
                    docker.withRegistry("${IMG_REPO}", "dockerhub-login"){
                        image.push("$IMG_TAG")
                    }   
                }
            }
        }
        stage('Deploy new version') {
            when {
                branch 'main'
            }
             
            steps {
                input "Approve deployment?"
                echo "Deployment approved." 

                withCredentials([file(credentialsId: 'petclinic_bastion_key', variable: 'KEYFILE'), 
                string(credentialsId: 'petclinic_bastion_user_address', variable: 'BASTION')]) {
                    sh '''
                        chmod 600 $KEYFILE

                        export IMG_TAG=`python3 ./semver_bump.py`

                        ssh "$BASTION" -o "StrictHostKeyChecking=no" -i $KEYFILE -tt << EOF
                            ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i inventory patch-app-playbook.yaml --extra-vars "image_tag=$IMG_TAG force_stop_old=true"
                            exit

                        cat tf_variables.yaml | grep ip
                        EOF'''
                }
            }
        }
    }
}
