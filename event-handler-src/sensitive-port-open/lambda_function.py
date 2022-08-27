import json
import boto3
import logging
import os

from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError
from ipaddress import ip_interface
from botocore.config import Config

SLACK_HOOK_URL = os.environ["SLACK_HOOK_URL"]
SLACK_CHANNEL = os.environ["SLACK_CHANNEL"]
SENSITIVE_PORTS = json.loads(os.getenv("SENSITIVE_PORTS", "[]"))
ALLOWED_IPS = json.loads(os.getenv("ALLOWED_IPS", "[]"))

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


def is_allowed_ip_and_port(src_ip, from_port, to_port):
    is_sensitive_port = False
    is_not_allowed_ip = True

    for port in SENSITIVE_PORTS:
        if int(from_port) <= port <= int(to_port):
            is_sensitive_port = True
            break

    for allowed_ip in ALLOWED_IPS:
        if ip_interface(allowed_ip).network.overlaps(ip_interface(src_ip).network):
            is_not_allowed_ip = False
            break

    return (not is_sensitive_port) & is_not_allowed_ip


def get_port_range(from_port, to_port):
    return to_port if from_port == to_port else f"{from_port} - {to_port}"


def delete_double_quotes(string_with_double_quotes):
    return string_with_double_quotes.replace('"', "")


def lambda_handler(event, context):
    detail = event["detail"]

    ### COMMON ###
    event_time = detail["eventTime"]
    arn = detail["userIdentity"]["arn"]
    event_name = detail["eventName"]
    region = detail["awsRegion"]
    ip = detail["sourceIPAddress"]
    response = detail["responseElements"]
    request = detail["requestParameters"]
    ### COMMON ###

    if not response:
        print(detail.get("errorCode", None), detail.get("errorMessage", None))
        return

    # config = Config(
    #     region_name=region,
    #     signature_version="v4",
    # )
    # ec2 = boto3.client("ec2", config=config)

    print(event_name)

    if event_name == "AuthorizeSecurityGroupIngress":
        ### 성공하지 못했으면 알람 보내지 않음 ###
        is_succeeded = response["_return"]
        if not is_succeeded:
            return
        ### 성공하지 못했으면 알람 보내지 않음 ###

        port_ranges = []
        rule_ids = []
        group_ids = []
        src_ips = []
        descs = []
        protocols = []
        # is_deleteds = []

        for item in response["securityGroupRuleSet"]["items"]:
            ### IP 판단이 불가한 경우 종료 ###
            if "prefixListId" in item or "referencedGroupId" in item:
                pass
                # return
            ### IP 판단이 불가한 경우 종료 ###

            [from_port, to_port, protocol, src_ip, desc] = [
                item["fromPort"],
                item["toPort"],
                item["ipProtocol"],
                item.get("cidrIpv4", None) or item.get("cidrIpv6", None),
                item.get("description", None),
            ]

            print(protocol)  # icmp, icmpv6

            if protocol.startswith("icmp"):
                continue

            if is_allowed_ip_and_port(src_ip, from_port, to_port):
                pass
                # continue

            [group_id, rule_id] = [item["groupId"], item["securityGroupRuleId"]]

            port_range = get_port_range(from_port, to_port)

            port_ranges.append(port_range)
            rule_ids.append(rule_id)
            group_ids.append(group_id)
            src_ips.append(src_ip)
            descs.append(desc)
            protocols.append(protocol)

            # result = ec2.revoke_security_group_ingress(
            #     GroupId=group_id, SecurityGroupRuleIds=[rule_id]
            # )
            # is_deleted = result["Return"]
            # is_deleteds.append(is_deleted)

    elif event_name == "ModifySecurityGroupRules":
        ### 성공하지 못했으면 알람 보내지 않음 ###
        is_succeeded = response["ModifySecurityGroupRulesResponse"].get("return", False)
        if not is_succeeded:
            return
        ### 성공하지 못했으면 알람 보내지 않음 ###

        rule_request = request["ModifySecurityGroupRulesRequest"]
        group_id = rule_request["GroupId"]
        rule = rule_request["SecurityGroupRule"]
        [rule_id, rule_info] = [rule["SecurityGroupRuleId"], rule["SecurityGroupRule"]]

        ### IP 판단이 불가한 경우 종료 ###
        if "PrefixListId" in rule_info or "ReferencedGroupId" in rule_info:
            pass
            # return
        ### IP 판단이 불가한 경우 종료 ###

        [from_port, to_port, protocol, src_ip, desc] = [
            rule_info["FromPort"],
            rule_info["ToPort"],
            rule_info["IpProtocol"],
            rule_info.get("CidrIpv4", None) or rule_info.get("CidrIpv6", None),
            rule_info.get("Description", None),
        ]

        if protocol.startswith("icmp"):
            return

        if is_allowed_ip_and_port(src_ip, from_port, to_port):
            pass
            # return

        port_range = get_port_range(from_port, to_port)

        # result = ec2.revoke_security_group_ingress(
        #     GroupId=group_id, SecurityGroupRuleIds=[rule_id]
        # )
        # is_deleted = result["Return"]

    else:
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
                                "text": f"*생성인:*\n{arn}",
                            },
                            {
                                "type": "mrkdwn",
                                "text": f"*보안그룹ID (룰ID):*\n`{group_id if event_name == 'ModifySecurityGroupRules' else delete_double_quotes(json.dumps(group_ids))} ({rule_id if event_name == 'ModifySecurityGroupRules' else delete_double_quotes(json.dumps(group_ids))})`",
                            },
                            {
                                "type": "mrkdwn",
                                "text": f"*출발지:*\n`{src_ip if event_name == 'ModifySecurityGroupRules' else delete_double_quotes(json.dumps(src_ips))}`",
                            },
                            {
                                "type": "mrkdwn",
                                "text": f"*프로토콜:*\n`{protocol if event_name == 'ModifySecurityGroupRules' else delete_double_quotes(json.dumps(protocols))}`",
                            },
                            {
                                "type": "mrkdwn",
                                "text": f"*포트:*\n`{port_range if event_name == 'ModifySecurityGroupRules' else delete_double_quotes(json.dumps(port_ranges))}`",
                            },
                            {
                                "type": "mrkdwn",
                                "text": f"*설명:*\n`{desc if event_name == 'ModifySecurityGroupRules' else delete_double_quotes(json.dumps(descs))}`",
                            },
                            # {
                            #     "type": "mrkdwn",
                            #     "text": f"*삭제여부:*\n`{is_deleted if event_name == 'ModifySecurityGroupRules' else json.dumps(is_deleteds)}`",
                            # },
                        ],
                    },
                ],
            }
        ],
    }

    send_message_to_slack(slack_message)

    return
