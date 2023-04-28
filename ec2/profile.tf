########################
## ec2 instance profile
########################

resource "aws_iam_instance_profile" "docker-sever-profile" {
  role = aws_iam_role.docker-sever-role.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "docker-sever-role" {
  name               = "docker-sever-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "docker-sever-role-AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.docker-sever-role.name
}

resource "aws_iam_role_policy_attachment" "docker-sever-role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.docker-sever-role.name
}

resource "aws_iam_role_policy_attachment" "docker-sever-role-CloudWatchLogsFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role       = aws_iam_role.docker-sever-role.name
}

resource "aws_iam_role_policy_attachment" "docker-sever-role-AmazonS3ReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.docker-sever-role.name
}