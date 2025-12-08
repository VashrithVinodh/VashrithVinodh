resource "aws_cloudwatch_event_rule" "s3_event_rule" {
    name = "capture-s3-trap-access"
    description = "capture S3 bucket access events from CloudTrail"

    event_pattern = jsonencode({
        "source" : [ "aws.s3" ],
        "detail-type" : [ "AWS API Call via CloudTrail" ], 
        "detail" : {
            "eventSource" : [ "s3.amazonaws.com" ],
            "eventName" : [ "GetObject", "ListObjects"]
            "requestParameters" : {
                "bucketName" : [ <ENTER_BUCKET_NAME_HERE> ]
            }
        }
    })
}

resource "aws_cloudwatch_event_target" "send_to_sns" {
    rule      = aws_cloudwatch_event_rule.s3_event_rule.name
    target_id = "sns-target"
    arn       = aws_sns_topic.alerts_topic.arn
}

# eventbridge cannot send events to sns without permission
resource "aws_sns_topic_policy" "allow_eventbridge" {
    arn = aws_sns_topic.alerts_topic.arn
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid = "AllowEventBridge"
                Effect = "Allow"
                Principal = {
                    Service = "events.amazonaws.com"
                }
                Action = "sns:Publish"
                Resource = aws_sns_topic.alerts_topic.arn
            }
        ]
    })
}