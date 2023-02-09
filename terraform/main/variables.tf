# Google cloud authentication file
variable "credentials_file" {
  type = string
}

variable "project_name" {
  type = string
  
}

variable "project_region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_location" {
  type    = string
}

variable "node_count" {
  type    = number
}

variable "oauth_scopes" {
  type = list(string)
}
