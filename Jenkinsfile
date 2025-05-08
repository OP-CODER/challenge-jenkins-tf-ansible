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
        
        stage('Run Ansible') {
            steps {
                dir('ansible') {
                    sh 'ansible-playbook -i inventory.ini main.yaml'
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
