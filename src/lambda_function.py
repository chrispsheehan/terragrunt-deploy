def lambda_handler(event, context):
    print("Received event:", event)
    # Process messages from SQS here
    return {"statusCode": 200, "body": "Success"}