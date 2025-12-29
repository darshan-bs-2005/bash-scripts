import boto3
import json
import datetime

def lambda_handler(event, context):

    # Parse AWS Config event (sent automatically by AWS Config)
    invoking_event = json.loads(event['invokingEvent'])
    configuration_item = invoking_event['configurationItem']

    # EC2 Instance ID
    instance_id = configuration_item['resourceId']

    # Create EC2 client
    ec2 = boto3.client('ec2')

    # Get EC2 instance details
    response = ec2.describe_instances(
        InstanceIds=[instance_id]
    )
    instance = response['Reservations'][0]['Instances'][0]

    # Assume compliant by default
    compliance = "COMPLIANT"
    annotation = "EC2 detailed monitoring is enabled"

    # Check EC2 detailed monitoring
    if instance['Monitoring']['State'] != 'enabled':
        compliance = "NON_COMPLIANT"
        annotation = "EC2 detailed monitoring is not enabled"

    # Prepare evaluation result
    evaluation = {
        'ComplianceResourceType': 'AWS::EC2::Instance',
        'ComplianceResourceId': instance_id,
        'ComplianceType': compliance,
        'Annotation': annotation,
        'OrderingTimestamp': datetime.datetime.utcnow()
    }

    # Send evaluation back to AWS Config
    config = boto3.client('config')
    config.put_evaluations(
        Evaluations=[evaluation],
        ResultToken=event['resultToken']
    )

    return "AWS Config evaluation completed"
