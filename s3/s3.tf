resource "aws_s3_bucket" "docker_server_data" {
  bucket = "docker-server-bucket-mspt3"

  tags = {
    description = "data bucket for docker-server"
  }
}

resource "aws_s3_object" "object" {
  depends_on = [
    data.archive_file.files
  ]

  bucket = aws_s3_bucket.docker_server_data.id
  key    = "files.zip"
  source = "${path.module}/files.zip"
}
