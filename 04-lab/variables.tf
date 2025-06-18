variable "aws_region" {
  description = "AWS region to deploy resources."
  type        = string
  default     = "us-west-2"

  validation {
    condition     = contains(["us-west-1", "us-west-2"], var.aws_region)
    error_message = "Region must be one of the permitted regions."
  }
}

variable "project_name" {
  description = "Logical name for project resources."
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances to launch."
  type        = number
  default     = 2

  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 5
    error_message = "instance_count must be between 1 and 5."
  }
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t2.micro"

  validation {
    condition     = can(regex("^t[2-3]\\.[a-z]+", var.instance_type))
    error_message = "Instance type must start with 't2.' or 't3.'"
  }
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks allowed to access the instances via SSH."
  default     = ["0.0.0.0/0"]

  validation {
    condition     = alltrue([for cidr in var.allowed_cidr_blocks : cidr != ""])
    error_message = "CIDR blocks list must not contain empty strings."
  }
}

variable "key_pair_name" {
  description = "Name of an existing EC2 Key Pair for SSH access."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to resources."
  type        = map(string)
  default     = {}
}
