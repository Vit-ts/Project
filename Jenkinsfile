pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                // docker build and passing environment variables to docker
                sh '''
                    docker build -t job1 .
                    docker tag job1 vitaly10kanivets/devops_project_web:v${BUILD_NUMBER}
                    
                '''
                // docker run
                sh '''
                    export MY_IP=`curl ifconfig.me/ip`
                    docker run --rm -d --name test -p 80:80 --env-file env.list  -e MY_IP=$MY_IP vitaly10kanivets/devops_project_web:v${BUILD_NUMBER}
                '''
            }
        }
        stage('Test') {
            steps {
                // curl localhost
                sh '''
                    count=0
                    while true
                    do
                        sleep 2
                        if curl localhost:80; then 
                            break
                        elif [ "$count" -eq 20 ]; then
                            exit 1
                        fi
                        echo "number of attampt is $count"
                        count=$(( count + 1 ))
                   done
                '''
                // docker stop
                sh '''
                    docker stop test
                '''
            }
        }
        stage('Delivery') {
            steps {
                sh '''
                    docker push vitaly10kanivets/devops_project_web:v${BUILD_NUMBER}
                    docker rmi vitaly10kanivets/devops_project_web:v${BUILD_NUMBER}
                    docker images
                    docker image prune -f
                    docker images
                '''
                sh '''
                     echo "export VERSION=v${BUILD_NUMBER}" > Build_number
                '''
                sh '''
                    scp -i "~/jenkins.pem" -v -o StrictHostKeyChecking=no Build_number ec2-user@54.159.238.234:/home/ec2-user
                '''
            }
        }
    }
}

