variable "primary_bucket_name" {
  description = "Name of the primary S3 bucket"
  type        = string
  default     = "my-primary-data-bucket-unique"
}

variable "secondary_bucket_name" {
  description = "Name of the secondary S3 bucket"
  type        = string
  default     = "my-secondary-data-bucket-unique"
}

variable "domain_name" {
  description = "Domain name for Route 53"
  type        = string
  default     = "example.com"
}