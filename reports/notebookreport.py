"""s2i based launch script to run the notebook."""
import requests
import os
import sys
from datetime import datetime, timedelta, date
import papermill as pm
import glob
import csv
import base64
from pathlib import Path
import os
from dotenv import load_dotenv, find_dotenv

# this will load all the envars from a .env file located in the project root (api)
load_dotenv(find_dotenv())

def send_email(email: dict):
    """Send the email."""
    client = os.environ['NOTIFY_CLIENT']
    secret = os.environ['NOTIFY_CLIENT_SECRET']
    kc_url = os.environ['KC_URL']
    notify_base_url = os.environ['NOTIFY_API_URL']
    payload = "grant_type=client_credentials"
    auth_str = client + ":" + secret
    basic_hash = base64.b64encode(auth_str.encode()).decode()
    headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': f'Basic {basic_hash}'
    }
    response = requests.request("POST", kc_url, headers=headers, data=payload)
    token = response.json()['access_token']

    headers = {
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {token}'
    }
    url = notify_base_url + "/api/v1/notify"
    response = requests.request("POST", url, json=email, headers=headers)
    if response.status_code != 200:
        print(response)
        raise Exception('Unsuccessful response when sending email.')


def processnotebooks():
    status = False

    for file in  glob.glob('*.ipynb', recursive=True):
        note_book = os.path.basename(file)
        today = date.today()
        subject = os.getenv('REPORT_SUBJECT', note_book.split('.ipynb')[0]) + today.strftime(' - %Y-%b-%d')
        email = {
            'recipients': os.getenv('REPORT_RECIPIENTS', ''),
            'content': {
                'subject': subject,
                'body': 'Report ready',
                'attachments': []
            }
        }
        try:
            temp_file = os.getenv('DATA_DIR', '') + 'temp.ipynb'
            pm.execute_notebook(file, temp_file, parameters=None)
            files = glob.glob(os.getenv('DATA_DIR', '') + '*.csv')
            filename = files[0]
            counter = 0
            with open(filename) as csvfile:
                reader = csv.DictReader(csvfile)
                for row in enumerate(reader):
                    print(row)
                    counter += 1
                    if counter >= 9:
                        break
            with open(filename, "rb") as f:
                attachments = []
                file_bytes = f.read()
                file_encoded = base64.b64encode(file_bytes)
                attachments.append(
                    {
                        'fileName': subject + '_' + datetime.strftime(datetime.now(),'%Y-%m-%d') + '.csv',
                        'fileBytes': file_encoded,
                        'fileUrl': '',
                        'attachOrder': 1
                    }
                )
                email['content']['attachments'] = attachments
            filename = os.path.basename(filename)

            status = True
        except Exception:  # noqa: B902
            email = {
                'recipients': os.getenv('ERROR_EMAIL_RECIPIENTS', ''),
                'content': {
                    'subject': subject,
                    'body': 'Failed to generate report',
                }
            }
        finally:
            if Path(temp_file).exists():
                os.remove(os.getenv('DATA_DIR', '') + 'temp.ipynb')
            send_email(email)
    return status


if __name__ == '__main__':
    START_TIME = datetime.utcnow()
    processnotebooks()
    END_TIME = datetime.utcnow()
    sys.exit()
