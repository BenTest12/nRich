# Google cloud authentication file
variable "credentials_file" {
  type = string
}

# Variable to store project name
variable "project_name" {
  type = string
  
}

# Variable to store project region
variable "project_region" {
  type = string
}

# Variable to store cluster name
variable "cluster_name" {
  type = string
}

# Variable to store cluster location
variable "cluster_location" {
  type    = string
}

# Variable to gke node count
variable "node_count" {
  type    = number
}

# Variable to store oauth scope list
variable "oauth_scopes" {
  type = list(string)
}
