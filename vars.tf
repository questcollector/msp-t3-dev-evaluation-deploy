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

variable "cidr_blocks_to_access" {
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

variable "acm_arn" {
  default     = null
  type        = string
  description = "arn:aws:acm:region:99999999:certificate/id"
}

variable "route53_zone_name" {
  default     = null
  type        = string
  description = "t2-practice-kiyoung-2022.click"
}

