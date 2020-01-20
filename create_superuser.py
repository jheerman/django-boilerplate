from django.contrib.auth.models import User
import os, logging

logger = logging.getLogger(__name__)

try:
    if not User.objects.exists():
        exit(1)
except:
    logger.info("Failed to create superuser")
    exit(1) 

User.objects.create_superuser(\
    os.getenv('DJANGO_SUPERUSER_USERNAME'), 
    os.getenv('DJANGO_SUPERUSER_EMAIL'), 
    os.getenv('DJANGO_SUPERUSER_PASSWORD'))

