variable "r9_username" {
  default = "ec2-user"
}

variable "d12_username" {
  default = "admin"
}
variable "region" {
  description = "AWS region"
  type        = string
  default    = "us-east-1"
}

variable "public_key" {
  description = "SSH public key for VM access"
  type        = string
  default    = "jenkins-tf"
}
