from django.db import models
from django.contrib.auth.models import User 

# Create your models here.

"""
Model to represent the extended User model
"""
class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    date_created = models.DateField(auto_now_add=True)
    date_modified = models.DateField(auto_now=True)
