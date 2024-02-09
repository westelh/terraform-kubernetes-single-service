variable "app_name" {
  description = "The name of the application"
  type        = string
}

variable "app_image" {
  description = "The Docker image to use for the application"
  type        = string
}

variable "arguments" {
  description = "The arguments to pass to the container"
  type        = list(string)
}

variable "port" {
  description = "The port the application listens on"
  type        = number
}
