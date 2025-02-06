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

Connection to OpenShift database in *.ipynb is established via (note the names of environmental variables used - DB_USER, DB_PASS, DB_HOST, DB_PORT - these will be supplied by the google cloud environment):
```
connect_to_db = 'postgresql://' + \
                os.getenv('DB_USER', '') + ":" + os.getenv('DB_PASS', '') +'@' + \
                os.getenv('DB_HOST', '') + ':' + os.getenv('DB_PORT', '5432') + '/' + os.getenv('DB_NAME', '');
```

To connect to Google Cloud database check out this [example](https://github.com/bcgov-registries/ops-support/blob/main/support/ops/bar/notebooks/EXAMPLE.ipynb). You can use ```google.cloud.sql.connector``` Python library and you would define a connection via a constructor:
```
def get_conn():
    conn = connector.connect(
        DB_HOST,
        "pg8000",
        user=DB_USER,
        password=DB_PASSWORD,
        db=DB_NAME
    )
    return conn
```

.env contains a list of environmental variables. The following variables are needed:

REPORT_RECIPIENTS=... - comma separated list of report recipient emails

REPORT_SUBJECT=... - email subject

ERROR_EMAIL_RECIPIENTS=... - comma separated list of error recipient emails

CRON_SCHEDULE="..." - cron schedule expression in double quotes that determines frequency of report runs, see https://crontab.guru for details

VAULT=... - 1password section of 'database' vault, 3 values are accepted for OpenShift databases: pay, namex, entity (for lear db). For data warehouse connection, hosted in Google Cloud, the value should be gcp-warehouse.


## Development Environment

Create .env file with values pulled from 1password (the latest list of used variables can be found in the tools branch under reports/variables.tf or in gcp job configurations). Notebook .ipynb file and corresponding .env should be dropped into the current reports/ directory.
