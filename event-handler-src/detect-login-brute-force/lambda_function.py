import json
import logging
import os

from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

SLACK_HOOK_URL = os.environ["SLACK_HOOK_URL"]
SLACK_CHANNEL = os.environ["SLACK_CHANNEL"]

logger = logging.getLogger()
logger.setLevel(logging.INFO)


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

    ### COMMON ###
    event_time = detail["eventTime"]
    arn = detail["userIdentity"]["arn"]
    event_name = detail["eventName"]
    region = detail["awsRegion"]
    ip = detail["sourceIPAddress"]
    response = detail["responseElements"]
    # request = detail["requestParameters"]
    user_agent = detail["userAgent"]
    has_mfa = detail["additionalEventData"].get("MFAUsed", "NO_MFA_KEY")
    account_id = detail["recipientAccountId"]
    user_id = detail["userIdentity"]
    ### COMMON ###

    if event_name == "ConsoleLogin":
        is_succeeded = response["ConsoleLogin"]
        user_name = user_id["arn"]
    elif event_name == "CredentialVerification":
        is_succeeded = detail["serviceEventDetails"]["CredentialVerification"]
        user_name = user_id["userName"]
    else:
        return

    if is_succeeded == "Success":
        return

    slack_message = {
        "channel": SLACK_CHANNEL,
        "attachments": [
            {
                "color": "#eb4034",
                "blocks": [
                    {
                        "type": "section",
                        "text": {
                            "type": "mrkdwn",
                            "text": f"*{event_name}* ({region}) *(Maybe BruteForce)*",
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
                                "text": f"*계정:*\n{account_id}",
                            },
                            {
                                "type": "mrkdwn",
                                "text": f"*사용자:*\n{user_name}",
                            },
                            {
                                "type": "mrkdwn",
                                "text": f"*유저에이전트:*\n{user_agent})",
                            },
                            {
                                "type": "mrkdwn",
                                "text": f"*MFA:*\n{has_mfa}",
                            },
                        ],
                    },
                ],
            }
        ],
    }

    send_message_to_slack(slack_message)

    return
