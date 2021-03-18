#!/bin/bash

cat <<EOF > /home/ec2-user/env.list
ENDPOINT=${endpoint}
BACKET_NAME=${backet_name}
DATABASE_PASS=${database_pass}
DATABASE_USER=${database_user}
DATABASE_NAME=${database_name}
SECRET_KEY=${secret_key}
AWS_ACCESS_KEY_ID=${aws_access_key_id}
AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}
region=${region}
OUTPUT=${output}
USER_DJANGO=${user_django}
EMAIL_DJANGO=${email_django}
PASS_DJANGO=${pass_django}
EOF

cat <<EOF >> /home/ec2-user/.bashrc
export MY_IP=`curl ifconfig.me/ip`
EOF

export MY_IP=`curl ifconfig.me/ip`

yum -y update
yum -y install docker
service docker start
chkconfig docker on

docker run --name terraform --rm -d -p 80:80 -e MY_IP=$MY_IP --env-file /home/ec2-user/env.list vitaly10kanivets/devops_project_web:${version}
