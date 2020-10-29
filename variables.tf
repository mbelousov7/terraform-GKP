# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "project" {
  description = "The project ID where all resources will be launched."
  type        = string
}

variable "region" {
  description = "The location (region or zone) of the GKE cluster."
  type        = string
  default     = null
}

variable "cluster_name" {
  description = "The name of the Kubernetes cluster."
  type        = string
  default     = "gke-cluster"
}

variable "description" {
  description = "The description of the cluster"
  type        = string
  default     = "terraform cluster"
}

variable "kubernetes_version" {
  description = "The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region."
  type        = string
  default     = "latest"
}

variable "logging_service" {
  description = "The logging service that the cluster should write logs to. Available options include logging.googleapis.com/kubernetes, logging.googleapis.com (legacy), and none"
  type        = string
  default     = "none"
}

variable "monitoring_service" {
  description = "The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Stackdriver Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting. Available options include monitoring.googleapis.com/kubernetes, monitoring.googleapis.com (legacy), and none"
  type        = string
  default     = "none"
}

variable "enable_binary_authorization" {
  description = "Enable BinAuthZ Admission controller"
  default     = false
}

variable "http_load_balancing" {
  description = "Whether to enable the http (L7) load balancing addon"
  type        = bool
  default     = true
}


variable "enable_kubernetes_dashboard" {
  description = "Whether to enable the Kubernetes Web UI (Dashboard). The Web UI requires a highly privileged security account."
  type        = bool
  default     = false
}

variable "basic_auth_username" {
  type        = string
  description = "The username to be used with Basic Authentication. An empty value will disable Basic Authentication, which is the recommended configuration."
  default     = ""
}

variable "basic_auth_password" {
  type        = string
  description = "The password to be used with Basic Authentication."
  default     = ""
}

variable "issue_client_certificate" {
  type        = bool
  description = "Issues a client certificate to authenticate to the cluster endpoint. To maximize the security of your cluster, leave this option disabled. Client certificates don't automatically rotate and aren't easily revocable. WARNING: changing this after cluster creation is destructive!"
  default     = false
}

variable "initial_node_count" {
  type        = number
  description = "The number of nodes to create in this cluster's default node pool."
  default     = 0
}

variable "remove_default_node_pool" {
  type        = bool
  description = "Remove default node pool while setting up the cluster"
  default     = false
}

variable "node_pools" {
  type        = list(map(string))
  description = "List of maps containing node pools"

  default = [
    {
      name = "default-node-pool"
      node_count = 1
      #labels = {lable = "value"}
    },
  ]
}

variable "node_pools_labels" {
  type        = map(map(string))
  description = "Map of maps containing node labels by node-pool name"
  # Default is being set in main.tf
  default = {
    all               = { }
    default-node-pool = { }
  }
}
