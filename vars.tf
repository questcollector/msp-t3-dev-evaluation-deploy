## Define Common variables #################################

variable "aws_region" {
  default     = null
  type        = string
  description = "AWS region"
}

variable "my_ami" {
  default     = null
  type        = string
  description = "EC2 ami"
}

variable "global_lounge_cidr" {
  default     = null
  type        = list(any)
  description = "global lounge cidr"
}

variable "instance_type" {
  default     = "t3.medium"
  type        = string
  description = "ec2 instance type"
}

variable "slack_token" {
  type        = string
  sensitive   = true
  description = "slack bot user token"
}

variable "start_date" {
  default     = null
  type        = string
  description = "2023-04-20T00:00:00"
}

variable "end_date" {
  default     = null
  type        = string
  description = "2023-04-20T00:00:00"
}