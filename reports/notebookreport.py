"""s2i based launch script to run the notebook."""
import requests
import os
import sys
from datetime import datetime, timedelta
import papermill as pm
import glob
import csv
import base64


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
    url = notify_base_url + "/api/v2/notify/resend"
    response = requests.request("POST", url, headers=headers)

    resp = requests.post(
        os.getenv('NOTIFY_API_URL', ''),
        json=email,
        headers={
            'Content-Type': 'application/json',
            'Authorization': f'Bearer {token}'
        }
    )
    if resp.status_code != 200:
        raise Exception('Unsuccessful response when sending email.')


def processnotebooks():
    status = False
    
    for file in  glob.glob('*.ipynb', recursive=True):
        note_book = os.path.basename(file)
        subject = note_book.split('.ipynb')[0]
        email = {
            'recipients': os.getenv('REPORT_RECIPIENTS', 'Andriy.Bolyachevets@gov.bc.ca'),
            'requestBy': os.getenv('SENDER_EMAIL', 'no-reply@gov.bc.ca'),
            'content': {
                'subject': subject,
                'body': '',
                'attachments': []
            }
        }
        try:
            pm.execute_notebook(file, os.getenv('DATA_DIR', '')+'temp.ipynb', parameters=None)
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
            filename = os.path.basename(filename)
            
            status = True
        except Exception:  # noqa: B902
            # send_email('Error processing notebook', note_book)
            email = {
                'recipients': os.getenv('ERROR_EMAIL_RECIPIENTS', 'Andriy.Bolyachevets@gov.bc.ca'),
                'requestBy': os.getenv('SENDER_EMAIL', 'no-reply@gov.bc.ca'),
                'content': {
                    'subject': subject,
                    'body': 'Failed to generate report',
                }
            }
        finally:
            os.remove(os.getenv('DATA_DIR', '')+'temp.ipynb')
            send_email(email)
    return status


if __name__ == '__main__':
    START_TIME = datetime.utcnow()
    processnotebooks()
    END_TIME = datetime.utcnow()
    sys.exit()
