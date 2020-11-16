# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ------------------------------------------------------------------------------

variable "file_sa" {
  description = "The location sa_account"
  type        = string
}

variable "project" {
  description = "The project ID where all resources will be launched."
  type        = string
}

variable "region" {
  description = "The location (region or zone) of the GKE cluster."
  type        = string
}
