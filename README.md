# django web application boilerplate

## Getting Started

Django is a high-level Python Web framework that encourages rapid development and clean, pragmatic design.

nginx (pronounced engine-x) is a free, open-source, high-performance HTTP server and reverse proxy, as well as an IMAP/POP3 proxy server.

A web server faces the outside world. It can serve files (HTML, images, CSS, etc) directly from the file system. However, it can’t talk directly to Django applications; it needs something that will run the application, feed it requests from web clients (such as browsers) and return responses.

A Web Server Gateway Interface - WSGI - does this job. WSGI is a Python standard.

uWSGI is a WSGI implementation. In this example we will set up uWSGI so that it creates a Unix socket, and serves responses to the web server via the uwsgi protocol. 

Make sure you are using a virtual environment of some sort (e.g. `virtualenv` or
`pyenv`).

###
Known issues: 
A specified in Django 3.0 release note, django.utils.six is removed. In case you need it, it is advised to use pypi packages instead
https://github.com/dmkoch/django-jsonfield/issues/225

```
$ pipenv install
$ pipenv shell
$ pip install -r requirements.txt

$ npm uninstall node-sass
$ npm uninstall gulp-sass
$ npm install node-sass
$ npm install gulp-sass
$ npm install

$ ./manage.py migrate
$ ./manage.py loaddata sites
$ ./manage.py createsuperuser
$ npm run dev
```
Browse to http://localhost:3000/

## Getting started with Docker

```
$ docker-compose up
```

Browse to http://localhost:8003/
