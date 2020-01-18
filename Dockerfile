# Copyright 2019 Agco 
#

FROM python:3.7.2-stretch

# Configure the environment vars in Docker container
ARG FUSE_ENV

ENV FUSE_ENV=${FUSE_ENV}
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DJANGO_ENV=prod
ENV DOCKER_CONTAINER=1
ENV PIPENV_VENV_IN_PROJECT=1

# Install required packages and remove the apt packages cache when done.
RUN apt-get update && \
    apt-get upgrade -y && \     
    apt-get install -y \
    git \
    vim \
    nginx \
    supervisor \
    cron \
    postgresql-client \
    sqlite3 && \
    pip install -U pip setuptools && \
    rm -rf /var/lib/apt/lists/*

# install uwsgi now because it takes a little while
RUN pip install --upgrade pip
RUN pip install uwsgi

# copy aws install
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
RUN unzip awscli-bundle.zip
RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

# setup all the configfiles
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY nginx-app.conf /etc/nginx/sites-available/default
COPY supervisord.conf /etc/supervisor/
COPY supervisor-app.conf /etc/supervisor/conf.d/

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# COPY requirements.txt and RUN pip install BEFORE adding the rest of your code, this will cause Docker's caching mechanism
# to prevent re-installing (all your) dependencies when you made a change a line or two in your app.
COPY app/requirements.txt app/requirements-zero.txt app/requirements-account.txt /home/docker/code/app/
RUN pip install -r /home/docker/code/app/requirements.txt

# add (the rest of) our code
COPY . /home/docker/code/

# Grant permissions to www-data group to the application directory
RUN chgrp -R www-data /home/docker/code
RUN chmod g+rwxs /home/docker/code

RUN chmod +x /home/docker/code/docker-entrypoint.sh

EXPOSE 8003
EXPOSE 2300
EXPOSE 3000

ENTRYPOINT ["bash", "/home/docker/code/docker-entrypoint.sh"]

