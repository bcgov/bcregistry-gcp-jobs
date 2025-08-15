# Notebook Report

Common infrastructure for notebook reports

## Deploying Jupyter Notebook Reports

Detailed deployment of notebook reports can be traced in a [notebook-tf-config-update.yml](https://github.com/bcgov/bcregistry-gcp-jobs/blob/main/.github/workflows/notebook-tf-config-update.yml) gh actions workflow.

The workflow is triggered when pushes are made to notebooks/ directory in the current repo, where notebooks should be added as subdirectories (e.g. in notebooks/worksafe, 'worksafe' will be used to name infrastructure artifacts, such as docker images, gcp jobs, etc.). The workflow will take care of building docker images encapsulating notebook jobs and scheduling them on google cloud. Subdirectory name is used to generate a name for google cloud job. Since google cloud restricts job names: ```only lowercase, digits, and hyphens; must begin with letter, and cannot end with hyphen```, the naming of subdirectories must follow this convention as well.

Currently, the workflow expects 2 files for each notebook subdirectory: .env and *.ipynb (it does not matter what a *.ipynb file is called, as long as it has the correct extension, but the file name will be used in the subject of the email sent out on job completion):

>notebooks/
>>|-- worksafe/
>>>       |-- .env
>>>       |-- worksafe_report.ipynb

## Database Connection

**Note: This infrastructure only supports GCP Cloud SQL database connections. OpenShift database connections are no longer supported.**

Database connection in *.ipynb notebooks is established using Google Cloud SQL connector. The required environment variables are:
- `DB_USER` - Database username
- `DB_NAME` - Database name
- `DB_INSTANCE_CONNECTION_NAME` - Cloud SQL instance connection name (format: `project:region:instance`)
- `DB_PASSWORD` - Database password (optional for IAM authentication)
- `VAULT=gcp-warehouse` - alias for 1password database vault section, default gcp-warehouse is recommended

### Required Dependencies

Add these packages to your requirements.txt:
```
cloud-sql-python-connector[pg8000]
pg8000
sqlalchemy
ipython-sql
```

### Connection Setup

Use the Google Cloud SQL connector to establish database connections:

```python
import os
import sqlalchemy
from google.cloud.sql.connector import Connector
import pg8000

# Initialize Connector object
connector = Connector()

def get_conn():
    """Create a connection to Google Cloud SQL using Cloud SQL connector."""
    conn = connector.connect(
        os.getenv('DB_INSTANCE_CONNECTION_NAME'),  # Cloud SQL instance connection name
        "pg8000",
        user=os.getenv('DB_USER'),
        password=os.getenv('DB_PASSWORD', ''),  # Password might be empty for IAM auth
        db=os.getenv('DB_NAME')
    )
    return conn

# Create SQLAlchemy engine using Cloud SQL connector
engine = sqlalchemy.create_engine(
    "postgresql+pg8000://",
    creator=get_conn,
)

# Set up SQL magic to use the new engine
%sql engine
```

.env contains a list of environmental variables. The following variables are needed:

**Report Configuration:**
- `REPORT_RECIPIENTS=...` - comma separated list of report recipient emails
- `REPORT_SUBJECT=...` - email subject
- `ERROR_EMAIL_RECIPIENTS=...` - comma separated list of error recipient emails
- `CRON_SCHEDULE="..."` - cron schedule expression in double quotes that determines frequency of report runs, see https://crontab.guru for details

**Database Configuration (GCP Cloud SQL only):**
- `DB_USER=...` - Database username
- `DB_NAME=...` - Database name
- `DB_INSTANCE_CONNECTION_NAME=...` - Cloud SQL instance connection name (format: `project:region:instance`)
- `DB_PASSWORD=...` - Database password (optional for IAM authentication)


## Development Environment

Create .env file with values pulled from 1password (the latest list of used variables can be found in the tools branch under reports/variables.tf or in gcp job configurations). Notebook .ipynb file and corresponding .env should be dropped into the current reports/ directory.
