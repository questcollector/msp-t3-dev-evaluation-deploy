########################
## ec2 instance profile
########################

resource "aws_iam_instance_profile" "docker-sever-profile" {
  role = aws_iam_role.docker-sever-role.name
}

resource "aws_iam_role" "docker-sever-role" {
  name = "docker-sever-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
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