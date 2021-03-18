#!/bin/bash

# User credentials
user=$USER_DJANGO
email=$EMAIL_DJANGO
password=PASS_DJANGO

# migration 
python3 manage.py makemigrations
python3 manage.py migrate

# creation users
echo "from django.contrib.auth.models import User; User.objects.create_superuser \
    ('$user', '$email', '$password')" | python3 manage.py shell

# downloading awcli and put credentials.
mkdir ~/.aws

cat <<EOF > ~/.aws/comfig 
[default]
region = $REGION
output = $OUTPUT
EOF

cat <<EOF > ~/.aws/credentials 
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
EOF

# running the script with synchronization of images with AWS S3
chmod ugo+x sync.sh
sh sync.sh &> /dev/null &

# run app
python3 manage.py runserver 0.0.0.0:80