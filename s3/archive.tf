resource "random_password" "rand_passwd" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "local_file" "init_mongo" {
  content = templatefile("${path.module}/files/db/initdb.d/init-mongo.js.tpl", {
    rand_passwd = random_password.rand_passwd.result
  })
  filename = "${path.module}/files/db/initdb.d/init-mongo.js"
}

resource "local_file" "env" {
  content = templatefile("${path.module}/files/.env.tpl", {
    rand_passwd = random_password.rand_passwd.result,
    slack_token = var.slack_token
  })
  filename = "${path.module}/files/.env"
}

resource "local_file" "mongodb_password" {
  content = templatefile("${path.module}/files/mongodb_password.tpl", {
    rand_passwd = random_password.rand_passwd.result
  })
  filename = "${path.module}/files/mongodb_password"
}

data "archive_file" "files" {
  depends_on = [
    local_file.env,
    local_file.mongodb_password,
    local_file.init_mongo
  ]

  type        = "zip"
  output_path = "${path.module}/files.zip"
  excludes = [
    "db/initdb.d/init-mongo.js.tpl",
    ".env.tpl",
    "mongodb_password.tpl"
  ]

  source_dir = "${path.module}/files"
}

