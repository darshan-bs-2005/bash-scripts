
# AWS Config – EC2 Monitoring Compliance (Two Demos)

This project demonstrates how to check **EC2 detailed monitoring compliance**
using **AWS Config** in two different ways:

1. AWS Managed Rule  
2. Custom AWS Config Rule using Lambda and boto3  

---

## Demo 1: AWS Managed Rule (Simple Method)

### Step 1: Create EC2 Instances
1. Go to **EC2 → Launch instance**
2. Create one EC2 instance
3. Enable **Detailed Monitoring** for this instance
4. Create another EC2 instance **without enabling monitoring**

---

### Step 2: Enable AWS Config
1. Go to **AWS Config**
2. Click **Get started**
3. Enable resource recording
4. Select **EC2 instances**
5. Save the configuration

---

### Step 3: Create AWS Managed Rule
1. Go to **AWS Config → Rules**
2. Click **Add rule**
3. Select **AWS managed rule**
4. Search for:
5. Select the rule
6. Click **Save**

---

### Step 4: Check Compliance Result
- EC2 instance with monitoring enabled → **COMPLIANT**
- EC2 instance without monitoring → **NON_COMPLIANT**

This completes **Demo 1**.

---

## Demo 2: Custom AWS Config Rule using Lambda (boto3)

### Step 1: Create IAM Role for Lambda
1. Go to **IAM → Roles → Create role**
2. Select **Lambda** as the service
3. Attach these policies (for demo purpose):
- AmazonEC2FullAccess
- AWSConfigRulesExecutionRole
- CloudWatchFullAccess
4. Create the role

This role allows Lambda to talk with EC2, AWS Config, and CloudWatch.

---

### Step 2: Create Lambda Function
1. Go to **Lambda → Create function**
2. Choose **Author from scratch**
3. Runtime: **Python 3.x**
4. Attach the IAM role created above
5. Create the function

---

### Step 3: Add Lambda Code (boto3)

Paste the below code into the Lambda editor:

```python
import boto3
import json
import datetime

def lambda_handler(event, context):

 invoking_event = json.loads(event['invokingEvent'])
 configuration_item = invoking_event['configurationItem']
 instance_id = configuration_item['resourceId']

 ec2 = boto3.client('ec2')
 instance = ec2.describe_instances(
     InstanceIds=[instance_id]
 )['Reservations'][0]['Instances'][0]

 compliance = "COMPLIANT"
 annotation = "EC2 detailed monitoring is enabled"

 if instance['Monitoring']['State'] != 'enabled':
     compliance = "NON_COMPLIANT"
     annotation = "EC2 detailed monitoring is not enabled"

 config = boto3.client('config')
 config.put_evaluations(
     Evaluations=[{
         'ComplianceResourceType': 'AWS::EC2::Instance',
         'ComplianceResourceId': instance_id,
         'ComplianceType': compliance,
         'Annotation': annotation,
         'OrderingTimestamp': datetime.datetime.utcnow()
     }],
     ResultToken=event['resultToken']
 )

 return "Evaluation completed"

## Step 4: Create Custom AWS Config Rule (Lambda)

1. Go to **AWS Config → Rules**
2. Click **Add rule**
3. Select **Custom rule**
4. Choose **AWS Lambda function**
5. Paste the **Lambda Function ARN**
6. Scope:
   - Resource type: `AWS::EC2::Instance`
7. Click **Save**

---

## Step 5: Do NOT Test the Lambda

- Do **not** click the **Test** button in Lambda
- AWS Config will trigger the Lambda **automatically**
- Manual testing will cause errors because `invokingEvent` is sent only by AWS Config

---

## Step 6: Automatic Evaluation by AWS Config

- AWS Config automatically detects EC2 configuration changes
- Lambda is triggered in the background
- Wait **1–5 minutes**
- Refresh the rule page in AWS Config

---

## Step 7: Check Compliance Result

- EC2 instance with **detailed monitoring enabled**  
  → **COMPLIANT**

- EC2 instance with **detailed monitoring disabled**  
  → **NON_COMPLIANT**

Click the resource ID to view:
- Compliance status
- Annotation message
- Evaluation time

---

## Expected Output

| EC2 Monitoring | Compliance Status |
|---------------|------------------|
Enabled | COMPLIANT |
Disabled | NON_COMPLIANT |

---

## Conclusion

- AWS Config triggers the Lambda automatically
- Lambda uses boto3 to check EC2 detailed monitoring
- Compliance results are reported using `put_evaluations`
- No manual testing is required
