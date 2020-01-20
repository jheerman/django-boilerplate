if [[ -n "$CREATE_DJANGO_SUPERUSER" ]]; then
    echo "Creating a django superuser account"
    cat create_superuser.py | python app/manage.py shell
fi
