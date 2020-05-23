from django.db.models.signals import post_save
from django.dispatch import receiver
from django.contrib.auth.models import User
from core.models import Profile

"""
Event handler when a new user is created
"""
@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        Profile.objects.create(user=instance)


"""
Event handler when a user is saved
"""
@receiver(post_save, sender=User)
def save_user_profile(sender, instance, **kwargs):
    instance.profile.save()

