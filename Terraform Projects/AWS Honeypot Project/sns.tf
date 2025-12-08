resource "aws_sns_topic" "alerts_topic" {
    name = "security-alerts"

    tags = {
        Name = "security-alerts"
        Environment = "Dev"
    }
}

resource "aws_sns_topic_subscription" "email_subscription" {
    topic_arn = aws_sns_topic.alerts_topic.arn
    protocol  = "email"
    endpoint  = "<ENTER_YOUR_EMAIL_HERE>" # replace with your email address
}