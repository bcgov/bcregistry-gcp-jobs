import os
from dotenv import load_dotenv, find_dotenv

# this will load all the envars from a .env file located in the project root (api)
load_dotenv(find_dotenv())


class Config(object):
    PROJECT_ROOT = os.path.abspath(os.path.dirname(__file__))
    APP_FILE = os.getenv('APP_FILE', '')
    SENDER_EMAIL = os.getenv('SENDER_EMAIL', '')
    ERROR_EMAIL_RECIPIENTS = os.getenv('ERROR_EMAIL_RECIPIENTS', '')
    REPORT_RECIPIENTS = os.getenv('REPORT_RECIPIENTS', '')

    # POSTGRESQL
    DB_USER = os.getenv('DB_USER', '')
    DB_NAME = os.getenv('DB_NAME', '')
    DB_HOST = os.getenv('DB_HOST', '')
    DB_PORT = os.getenv('DB_PORT', '5432')

    # NOTIFY API
    NOTIFY_CLIENT = os.getenv('NOTIFY_CLIENT', '')
    NOTIFY_CLIENT_SECRET = os.getenv('NOTIFY_CLIENT_SECRET', '')
    KC_URL = os.getenv('KC_URL', '')
    NOTIFY_API_URL = os.getenv('NOTIFY_API_URL', '')

