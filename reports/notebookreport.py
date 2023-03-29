"""s2i based launch script to run the notebook."""
import fnmatch
import os
import sys
from datetime import datetime, timedelta
import papermill as pm
from flask import Flask, current_app
from config import Config
import glob
import csv


def create_app(config=Config):
    app = Flask(__name__)
    app.config.from_object(config)
    # db.init_app(app)
    app.app_context().push()
    return app


def send_email(subject, filename):
    """STUB"""
    print(subject)
    print(filename)


def processnotebooks():
    status = False
    date = datetime.strftime(datetime.now() - timedelta(1), '%Y-%m-%d')
    for file in  glob.glob('*.ipynb', recursive=True):
        note_book = os.path.basename(file)
        try:
            pm.execute_notebook(file, os.getenv('DATA_DIR', '')+'temp.ipynb', parameters=None)
            subject = note_book.split('.ipynb')[0]
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
            send_email(subject, filename)
            status = True
        except Exception:  # noqa: B902
            send_email('Error processing notebook', note_book)
        finally:
            os.remove(os.getenv('DATA_DIR', '')+'temp.ipynb')
    return status


if __name__ == '__main__':
    START_TIME = datetime.utcnow()
    processnotebooks()
    END_TIME = datetime.utcnow()
    sys.exit()
