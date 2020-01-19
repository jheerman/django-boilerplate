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

echo "Initializing cron."
touch /etc/cron.d/django-boilerplate
env >> /etc/cron.d/django-boilerplate
echo 'SHELL=/bin/bash' >> /etc/cron.d/django-boilerplate
cat /etc/cron.d/django-boilerplate-cron >> /etc/cron.d/django-boilerplate
rm /etc/cron.d/django-boilerplate-cron
chmod 0644 /etc/cron.d/django-boilerplate
crontab /etc/cron.d/django-boilerplate

echo "Done intializing cron."
echo "Django Environment: $DJANGO_ENV"
echo "Application profile is: $APPLICATION_PROFILE"
echo "Analyzing data fixtures."

python /home/docker/code/app/manage.py migrate --noinput

## Create a superuser account from the environment vars found in web.env; password isn't required and will default to env variable
python /home/docker/code/app/manage.py createsuperuser --username $DJANGO_SUPERUSER_USERNAME --email $DJANGO_SUPERUSER_EMAIL --no-input

#Reset the data each time in the dev environment
if [ $RUNNING_IN_AWS -eq 0 ]; then
    echo "Loading fixture data into local environment..."
    python /home/docker/code/app/manage.py loaddata sites
fi

python /home/docker/code/app/manage.py collectstatic --noinput

echo "Starting supervisor process monitoring."
supervisord -n -c /etc/supervisor/supervisord.conf 

echo "Done."
