import json
import boto3
import datetime
import logging
import os

from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

SLACK_HOOK_URL = os.environ["SLACK_HOOK_URL"]
SLACK_CHANNEL = os.environ["SLACK_CHANNEL"]
SOURCE_IPS = json.loads(os.getenv("SOURCE_IPS", "[]"))
ADMINS = ["rexchun", "root"]

logger = logging.getLogger()
logger.setLevel(logging.INFO)

iam = boto3.client("iam")


def send_message_to_slack(slack_message):
    req = Request(SLACK_HOOK_URL, json.dumps(slack_message).encode("utf-8"))
    try:
        response = urlopen(req)
        response.read()
        logger.info("Message posted to %s", slack_message["channel"])
    except HTTPError as e:
        logger.error("Request failed: %d %s", e.code, e.reason)
    except URLError as e:
        logger.error("Server connection failed: %s", e.reason)


def lambda_handler(event, context):
    detail = event["detail"]

    # 콘솔 통하지 않을 경우 값 없음
    print(f"CONSOLE : {detail.get('sessionCredentialFromConsole', 'false')}")

    event_time = detail["eventTime"]
    arn = detail["userIdentity"]["arn"]
    access_key = detail["userIdentity"]["accessKeyId"]

    event_name = detail["eventName"]
    region = detail["awsRegion"]
    ip = detail["sourceIPAddress"]

    created_access_key_info = detail["responseElements"]["accessKey"]

    # Root 엑세스 키는 UserName이 존재하지 않음
    user_name = created_access_key_info.get("userName", "")
    created_access_key_id = created_access_key_info["accessKeyId"]
    status = created_access_key_info["status"]

    # print(event_time)
    # print(arn)
    # print(region)
    # print(access_key)
    # print(event_name)
    # print(ip)
    # print(created_access_key_id)
    # print(status)

    is_root = False
    is_deleted = False
    is_correct_user = False

    key_issuer = arn.split(":")[-1] if "/" not in arn else arn.split("/")[-1]
    if key_issuer in ADMINS:
        is_correct_user = True

    # Root 엑세스 키는 어차피 삭제 불가능함
    # if not user_name:
    #     is_root = True
    # return

    # 정상 동작 예시 1
    # if ip == "1.1.1.1":
    #     # send_message_to_slack()
    #     return

    # 정상 동작 예시 2
    # if arn.endswith("TESTACCOUNT"):
    #     # send_message_to_slack()
    #     return

    # 정상 동작 예시 3
    # if ip == "1.1.1.1" and arn.endswith("TESTACCOUNT"):
    #     # send_message_to_slack()
    #     return
    # 사용자의 경로(path)를 토대로 식별도 가능(권한 있는 부서인지!)

    # try:
    #     if is_root or is_correct_user:
    #         pass
    #     else:
    #         result = iam.delete_access_key(
    #             UserName=user_name, AccessKeyId=created_access_key_id
    #         )
    #         if result["ResponseMetadata"]["HTTPStatusCode"] == 200:
    #             is_deleted = True
    #             print(f"{user_name} KEY DELETED")
    # except iam.exceptions.NoSuchEntityException:
    #     print("중복")
    #     return

    slack_message = {
        "channel": SLACK_CHANNEL,
        "attachments": [
            {
                "color": "#30db3f" if key_issuer in ADMINS else "#eb4034",
                "blocks": [
                    {
                        "type": "section",
                        "text": {
                            "type": "mrkdwn",
                            "text": f"*{event_name}* ({region})",
                        },
                    },
                    {
                        "type": "section",
                        "fields": [
                            {"type": "mrkdwn", "text": f"*시간:*\n{event_time}"},
                            {
                                "type": "mrkdwn",
                                "text": f"*IP:*\n{ip}",
                            },
                            {
                                "type": "mrkdwn",
                                "text": f"*계정:*\n{detail['recipientAccountId']}",
                            },
                            {
                                "type": "mrkdwn",
                                "text": f"*발급인:*\n{arn}",
                            },
                            {
                                "type": "mrkdwn",
                                "text": f"*사용자:*\n{user_name}",
                            },
                            {
                                "type": "mrkdwn",
                                "text": f"*Access Key ID:*\n{created_access_key_id}",
                            },
                            # {
                            #     "type": "mrkdwn",
                            #     "text": f"*삭제여부:*\n`{is_deleted}`",
                            # },
                            # {
                            #     "type": "mrkdwn",
                            #     "text": f"*루트키여부:*\n`{is_root}`",
                            # },
                        ],
                    },
                ],
            }
        ],
    }

    send_message_to_slack(slack_message)

    return
