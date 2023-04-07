node{
        stage('Git checkout'){
            git 'https://github.com/tonudon86/mongo-crud-kubernates.git'
        }
        

        stage('Sending dockerfile to ansible serber'){
            sshagent(['anisble']) {
                    sh  'ssh -o StrictHostKeyChecking=no ec2-user@172.31.44.49'
                    sh 'scp /var/lib/jenkins/workspace/demo/* ec2-user@172.31.44.49:/home/ec2-user/ '
                    
            }
        }
        stage('Building image and tagging '){
                sshagent(['anisble']) {
                    sh  'ssh -o StrictHostKeyChecking=no ec2-user@172.31.44.49 cd /home/ec2-user/ '
                    sh  'ssh -o StrictHostKeyChecking=no ec2-user@172.31.44.49 docker build -t tonudon86/mongo-crud:v1.$BUILD_ID . '
                    sh  'ssh -o StrictHostKeyChecking=no ec2-user@172.31.44.49 docker tag  tonudon86/mongo-crud:v1.$BUILD_ID  tonudon86/mongo-crud:latest '
                        
                     
                    
            }  
        }
        stage('Pusing image to docker hub'){
        sshagent(['anisble']) {
                    withCredentials([string(credentialsId: 'docker_hub', variable: 'docker_hub_pswd')]) {
                    sh  'ssh -o StrictHostKeyChecking=no ec2-user@172.31.44.49 docker login -u  tonudon86  -p ${docker_hub_pswd} '
                    }
                     sh  'ssh -o StrictHostKeyChecking=no ec2-user@172.31.44.49 docker push  tonudon86/mongo-crud:v1.$BUILD_ID  '
                      sh  'ssh -o StrictHostKeyChecking=no ec2-user@172.31.44.49 docker push  tonudon86/mongo-crud:latest  '
                     sh 'ssh -o StrictHostKeyChecking=no ec2-user@172.31.44.49 docker image rm  tonudon86/mongo-crud:v1.$BUILD_ID tonudon86/mongo-crud:latest  '
                    
            } 
            
        }
        
        stage('Sending files to kubernates'){
          sshagent(['kubernates']) {
                sh  'ssh -o StrictHostKeyChecking=no  ubuntu@172.31.35.67 '
                  sh 'scp /var/lib/jenkins/workspace/demo/* ubuntu@172.31.35.67:/home/ubuntu/ '
            }
        }
        
        stage('Kubernates deployment using ansible'){
                   sshagent(['anisble']) {
                    sh  'ssh -o StrictHostKeyChecking=no ec2-user@172.31.44.49 cd /home/ec2-user/ '
                    sh  'ssh -o StrictHostKeyChecking=no ec2-user@172.31.44.49  ansible-playbook ansilbe.yaml '
                    
            }  
        }
}