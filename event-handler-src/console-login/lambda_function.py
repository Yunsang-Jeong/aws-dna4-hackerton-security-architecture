import json
import logging
import os

from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

SLACK_HOOK_URL = os.environ["SLACK_HOOK_URL"]
SLACK_CHANNEL = os.environ["SLACK_CHANNEL"]
SOURCE_IPS = json.loads(os.environ["SOURCE_IPS"])

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    detail = event["detail"]

    if detail["eventName"] != "ConsoleLogin":
        return

    if detail["responseElements"]["ConsoleLogin"] != "Success":
        return

    print(
        f"""
        EventTime: {detail['eventTime']}
        EventName: {detail['eventName']}
        Region: {detail['awsRegion']}
        IP: {detail['sourceIPAddress']}
        MFAUsed: {detail['additionalEventData']['MFAUsed']}
        AccountId: {detail['recipientAccountId']}
        Type: {detail['userIdentity']['type']}
        Arn: {detail['userIdentity']['arn']}
        AccessKeyId: {detail['userIdentity'].get('accessKeyId', 'None') or 'None'}
        """
    )

    # if detail["sourceIPAddress"] in SOURCE_IPS:
    #     return

    slack_message = {
        "channel": SLACK_CHANNEL,
        "attachments": [
            {
                "color": "#30db3f"
                if detail["sourceIPAddress"] in SOURCE_IPS
                else "#eb4034",
                "blocks": [
                    {
                        "type": "section",
                        "text": {
                            "type": "mrkdwn",
                            "text": f"*{detail['eventName']}* ({detail['awsRegion']})",
                        },
                    },
                    {
                        "type": "section",
                        "fields": [
                            {"type": "mrkdwn", "text": f"*시간:*\n{detail['eventTime']}"},
                            {
                                "type": "mrkdwn",
                                "text": f"*IP:*\n{detail['sourceIPAddress']}",
                            },
                            {
                                "type": "mrkdwn",
                                "text": f"*계정:*\n{detail['recipientAccountId']}",
                            },
                            {
                                "type": "mrkdwn",
                                "text": f"*종류:*\n{detail['userIdentity']['type']}",
                            },
                            {
                                "type": "mrkdwn",
                                "text": f"*사용자:*\n{detail['userIdentity']['arn']}",
                            },
                            {
                                "type": "mrkdwn",
                                "text": f"*MFA:*\n{detail['additionalEventData']['MFAUsed']}",
                            },
                        ],
                    },
                ],
            }
        ],
    }

    req = Request(SLACK_HOOK_URL, json.dumps(slack_message).encode("utf-8"))
    try:
        response = urlopen(req)
        response.read()
        logger.info("Message posted to %s", slack_message["channel"])
    except HTTPError as e:
        logger.error("Request failed: %d %s", e.code, e.reason)
    except URLError as e:
        logger.error("Server connection failed: %s", e.reason)

    return
