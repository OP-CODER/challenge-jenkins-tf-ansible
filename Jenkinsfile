pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/OP-CODER/challenge-jenkins-tf-ansible.git'
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Generate Inventory') {
            steps {
                dir('terraform') {
                    sh 'terraform output -raw inventory > ../ansible/inventory.ini'
                }
            }
        }

        stage('Configure VMs') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ubuntu1', keyFileVariable: 'UBUNTU_KEY')]) {
                    withCredentials([sshUserPrivateKey(credentialsId: 'ec2-user1', keyFileVariable: 'AMAZON_KEY')]) {
                        dir('ansible') {
                            sh '''
                                chmod 600 $UBUNTU_KEY $AMAZON_KEY
                                export ANSIBLE_HOST_KEY_CHECKING=False

                                ansible-playbook -i inventory.ini playbook_backend.yml --private-key=$UBUNTU_KEY -u ubuntu
                                ansible-playbook -i inventory.ini playbook_frontend.yml --private-key=$AMAZON_KEY -u ec2-user
                            '''
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            archiveArtifacts artifacts: 'ansible/inventory.ini',
                                onlyIfSuccessful: true
            cleanWs()
        }
    }
}
