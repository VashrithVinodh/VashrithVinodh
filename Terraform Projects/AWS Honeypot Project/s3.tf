resource "aws_s3_bucket" "bucket" {
    bucket = "<ENTER_BUCKET_NAME_HERE>"

    tags = {
        Name = ""
        Environment = "Dev"
    }
}

# enabling acls for the bucket
resource "aws_s3_bucket_ownership_controls" "enable_acls" {
    bucket = aws_s3_bucket.bucket.id

    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
    depends_on = [ aws_s3_bucket_ownership_controls.enable_acls ]
    bucket = aws_s3_bucket.bucket.id
    acl = "private"
}

# allow cloudtrail to write logs to the bucket
resource "aws_s3_bucket_policy" "allow_cloudtrail" {
    bucket = aws_s3_bucket.bucket.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid = "AllowCloudTrailToWrite"
                Effect = "Allow"
                Principal = {
                    Service = "cloudtrail.amazonaws.com"
                }
                Action = "s3:PutObject"
                Resource = "${aws_s3_bucket.bucket.arn}/AWSLogs/*"
                Condition = {
                    StringEquals = {
                        "s3:x-amz-acl" = "bucket-owner-full-control"
                    }
                }
            },
            {
                Sid = "AllowCloudTrailListBucket"
                Effect = "Allow"
                Principal = {
                    Service = "cloudtrail.amazonaws.com"
                }
                Action = "s3:GetBucketAcl"
                Resource = aws_s3_bucket.bucket.arn
            }
        ]
    })
}

resource "aws_cloudtrail" "s3_trail" {
    name                          = "s3-data-access-trail"
    s3_bucket_name                = aws_s3_bucket.bucket.id
    include_global_service_events = true
    is_multi_region_trail         = true

    event_selector {
        read_write_type = "All"
        include_management_events = true

        data_resource {
            type = "AWS::S3::Object"
            values = ["${aws_s3_bucket.bucket.arn}/"]
        }
    }

    depends_on = [ aws_s3_bucket_policy.allow_cloudtrail ]
}