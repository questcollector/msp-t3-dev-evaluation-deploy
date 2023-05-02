resource "random_password" "mongodb_passwd" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "rabbitmq_passwd" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

data "external" "rabbitmq_admin_hash" {
  program = ["python3",
    "${path.module}/rabbitmq-password-hash.py",
  "${random_password.rabbitmq_passwd.result}"]
}

data "external" "rabbitmq_guest_hash" {
  program = ["python3",
    "${path.module}/rabbitmq-password-hash.py",
  "guest"]
}

resource "local_file" "init_mongo" {
  content = templatefile("${path.module}/files/db/initdb.d/init-mongo.js.tpl", {
    mongodb_passwd = random_password.mongodb_passwd.result
  })
  filename = "${path.module}/files/db/initdb.d/init-mongo.js"
}

resource "local_file" "env" {
  content = templatefile("${path.module}/files/.env.tpl", {
    mongodb_passwd  = random_password.mongodb_passwd.result,
    slack_token     = var.slack_token,
    rabbitmq_passwd = random_password.rabbitmq_passwd.result
  })
  filename = "${path.module}/files/.env"
}

resource "local_file" "mongodb_password" {
  content = templatefile("${path.module}/files/mongodb_password.tpl", {
    mongodb_passwd = random_password.mongodb_passwd.result
  })
  filename = "${path.module}/files/mongodb_password"
}

resource "local_file" "rabbitmq_definitions" {
  content = templatefile("${path.module}/files/rabbitmq_definitions.json.tpl", {
    admin_password = data.external.rabbitmq_admin_hash.result.hash,
    guest_password = data.external.rabbitmq_guest_hash.result.hash
  })
  filename = "${path.module}/files/rabbitmq_definitions.json"
}

data "archive_file" "files" {
  depends_on = [
    local_file.env,
    local_file.mongodb_password,
    local_file.init_mongo,
    local_file.rabbitmq_definitions
  ]

  type        = "zip"
  output_path = "${path.module}/files.zip"
  excludes = [
    "db/initdb.d/init-mongo.js.tpl",
    ".env.tpl",
    "mongodb_password.tpl",
    "rabbitmq_definitions.json.tpl"
  ]

  source_dir = "${path.module}/files"
}

