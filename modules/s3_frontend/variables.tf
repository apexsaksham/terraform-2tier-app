variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "tf-frontend-saksham-16"
}

variable "tags" {
  description = "A map of tags to assign to the bucket"
  type        = map(string)
  default     = {}
}

variable "upload_files" {
  description = "Whether to upload the static files"
  type        = bool
  default     = true
}

variable "files_path" {
  description = "Path to the directory containing the files to upload"
  type        = string
  default     = "./files"
}
