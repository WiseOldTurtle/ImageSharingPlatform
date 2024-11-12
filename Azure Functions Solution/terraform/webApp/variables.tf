variable "storage_connection_string" {
  type = string
}

variable "image_resolution" {
  type    = string
  default = "300x300,600x600,1200x1200"  # Example values
}

variable "link_shortener_api_key" {
  type = string
}

variable "auth_secret" {
  type = string
}

variable "log_level" {
  type    = string
  default = "info"  # Example log level
}