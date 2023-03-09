# Copyright © 2023 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
import psycopg2
import os


def reindex_db():
    db_name = os.environ['DB_NAME']
    db_port = os.environ['DB_PORT']
    db_host = os.environ['DB_HOST']
    db_user = os.environ['DB_USER']

    conn = psycopg2.connect(user=db_user,
                            host=db_host,
                            port=db_port,
                            dbname=db_name)
    cur = conn.cursor()
    select_q = "select * from users;"
    cur.execute(select_q)
    target_users = cur.fetchall()
    conn.commit()
    cur.close()


if __name__ == '__main__':
    reindex_db()
