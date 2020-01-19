from django.test import TestCase
from django.contrib.auth.models import User
from core.models import Profile

"""
Test fixture to ensure profiles are modified accordingly
when a user is added/deleted to/from the application
"""
class UserSignalTestCase(TestCase):
    """
    Ensure test can create the profile when the user was created.
    """
    def test_ensure_profile_created_when_user_created(self):
        self.assertEquals(Profile.objects.all().count(), 0)
        self.assertEquals(User.objects.all().count(), 0)

        User.objects.create_user(first_name='John',
                                 last_name='Doe',
                                 email='fake@mailinator.com',
                                 username='bob',
                                 password='password')

        self.assertEquals(User.objects.all().count(), 1)
        self.assertEquals(Profile.objects.all().count(), 1)

    """
    Ensure profile can be deleted when user was deleted.
    """
    def test_ensre_profile_deleted_when_user_deleted(self):
        user = User.objects.create_user(first_name='John',
                                        last_name='Doe',
                                        email='fake@mailinator.com',
                                        username='bob',
                                        password='password')

        self.assertEquals(Profile.objects.all().count(), 1)
        self.assertEquals(User.objects.all().count(), 1)

        user.delete()

        self.assertEquals(Profile.objects.all().count(), 0)
        self.assertEquals(User.objects.all().count(), 0)
