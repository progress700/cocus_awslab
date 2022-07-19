/*variable "aws_access_key" {}

variable "aws_secret_key" {}
*/
variable "aws_region" {
  default     = "eu-west-1"
  description = "aws region to lunch"
  type        = string
}

variable "vpc_cidr" {
  default     = "172.16.0.0/23"
  description = "vpc cidr block"
  type        = string
}

variable "public_subnet_cidr" {
  default     = "172.16.0.0/24"
  description = "Public Subnet cidr block"
  type        = string
}

variable "private_subnet_cidr" {
  default     = "172.16.1.0/24"
  description = "Private Subnet cidr block"
  type        = string
}
