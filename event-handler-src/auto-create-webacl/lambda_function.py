import os
import json
import urllib.request
import boto3
    
    
def lambda_handler(event, context):
    # TODO implement
    service_name = os.environ['SERVICE_NAME']

    cloudfront_id  = event['detail']['responseElements']['distribution']['id']
    waf_web_acl_name = service_name+'-waf-webacl-'+cloudfront_id
    
    create_waf_web_acl(waf_web_acl_name)
    
    
def create_waf_web_acl(web_acl_name):
    client = boto3.client('wafv2')
    
    response = client.create_web_acl(
        Name=web_acl_name,
        Scope='CLOUDFRONT', #'CLOUDFRONT'|'REGIONAL',
        DefaultAction={
            'Allow': {}
        },
        Description='WebACL Created by CloudFront',
        VisibilityConfig={
            'SampledRequestsEnabled': True,
            'CloudWatchMetricsEnabled': True,
            'MetricName': web_acl_name
        },
        Tags=[
            {
                'Key': 'Name',
                'Value': web_acl_name
            },
        ]
    )
    