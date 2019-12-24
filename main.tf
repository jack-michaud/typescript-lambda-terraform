
variable "environment" {
  default = "test"
}

resource "aws_s3_bucket" "lambda_source" {
  bucket = "lambda-function-source-for-jacko"
  acl = "private"
  versioning {
    enabled = true
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

variable "lambda_name" {
  default = "my-lambda"
}
data "archive_file" "lambda_src" {
  type = "zip"
  output_path = "${path.module}/${var.lambda_name}.zip"
  source_dir = "${path.module}/dist"
}

resource "aws_s3_bucket_object" "lambda_src" {
  bucket = aws_s3_bucket.lambda_source.id
  key    = "${var.environment}-${var.lambda_name}"
  source = data.archive_file.lambda_src.output_path
  etag = filemd5(data.archive_file.lambda_src.output_path)
}

resource "aws_lambda_function" "test_lambda" {
  s3_bucket = aws_s3_bucket.lambda_source.id
  s3_key = aws_s3_bucket_object.lambda_src.key
  s3_object_version = aws_s3_bucket_object.lambda_src.version_id

  function_name = "${var.environment}_test_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda.handler"
  runtime       = "nodejs10.x"
}
