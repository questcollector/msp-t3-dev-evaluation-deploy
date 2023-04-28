data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "iam_for_lambda-AWSLambdaVPCAccessExecutionRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.iam_for_lambda.name
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/index.mjs"
  output_path = "${path.module}/lambda_function_payload.zip"
}

resource "aws_security_group" "sg_for_lambda" {
  name   = "sg_for_lambda"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_for_lambda"
  }
}

resource "aws_security_group_rule" "https_ingress" {

  description = "https - anywhere"
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "TCP"

  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_for_lambda.id
}

resource "aws_lambda_function" "slack_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  depends_on = [
    data.archive_file.lambda
  ]
  filename      = "${path.module}/lambda_function_payload.zip"
  function_name = "slack_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs18.x"

  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = var.public_subnet_id
    security_group_ids = [aws_security_group.sg_for_lambda.id]
  }

  environment {
    variables = {
      foo            = "bar",
      EVALUATION_API = var.docker_server_local_ip,
      START_DATE     = var.start_date,
      END_DATE       = var.end_date
    }
  }
}

resource "aws_lambda_function_url" "https_url" {
  function_name      = aws_lambda_function.slack_lambda.function_name
  authorization_type = "NONE"
}