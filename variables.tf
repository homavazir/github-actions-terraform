variable "cidr" {
  type    = list(any)
  default = ["10.0.0.0/16"]
}

variable "availability_zone" {
  description = "availability_zone"
  default     = "ap-southeast-2a"
}