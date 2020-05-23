#!/bin/sh

echo 'alias ll="ls -l"' >> ~/.bashrc
echo 'alias la="ls -A"' >> ~/.bashrc
echo 'set -o vi' >> ~/.bashrc

STATUS=$(curl --max-time 5 -s -o /dev/null -w '%{http_code}' http://169.254.170.2/v2/metadata/)
if [ $STATUS -eq 200 ]; then
    echo "Running in AWS, pull parameters from ssm parameter store"
    export RUNNING_IN_AWS=1
else
    echo "Got $STATUS : Not running in AWS"
    export RUNNING_IN_AWS=0
fi

echo "Django Environment: $DJANGO_ENV"
echo "Analyzing data fixtures."

python /home/docker/code/app/manage.py migrate --noinput

## Create a superuser account from the environment vars found in web.env; password isn't required and will default to env variable
## Note: This only works in Django 3.0, but there are dependencies (account, jsonfield2) that are not compatible yet
#python /home/docker/code/app/manage.py createsuperuser --username $DJANGO_SUPERUSER_USERNAME --email $DJANGO_SUPERUSER_EMAIL --noinput

#Reset the data each time in the dev environment
if [ $RUNNING_IN_AWS -eq 0 ]; then
    echo "Loading fixture data into local environment..."
    python /home/docker/code/app/manage.py loaddata sites
    python /home/docker/code/app/manage.py loaddata accounts
    python /home/docker/code/app/manage.py loaddata profiles
    python /home/docker/code/app/manage.py loaddata users
fi

python /home/docker/code/app/manage.py collectstatic --noinput

echo "Starting supervisor process monitoring."
supervisord -n -c /etc/supervisor/supervisord.conf 

echo "Done."
