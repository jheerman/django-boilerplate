from web.settings import *

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": APP_DIR + "/dev.db",
    }
}
