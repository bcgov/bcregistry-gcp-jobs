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
import requests
import base64
import os


def notify_api_run():
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
    print(response.status_code)
    print(response.text)


if __name__ == '__main__':
    notify_api_run()
