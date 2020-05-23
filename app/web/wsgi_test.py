"""
Test to see if uwsgi is set up properly
Visit for more details: https://uwsgi-docs.readthedocs.io/en/latest/tutorials/Django_and_nginx.html
"""
def application(env, start_response):
    start_response('200 OK', [('Content-Type', 'text/html')])
    return [b"Hello from uwsgi"]
