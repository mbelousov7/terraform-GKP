
# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A PRIVATE CLUSTER IN GOOGLE CLOUD PLATFORM
# ---------------------------------------------------------------------------------------------------------------------

resource "google_container_cluster" "cluster" {
  provider = google
  name        = var.cluster_name
  description = var.description
  project    = var.project
  location   = local.location
  #master_version = var.kubernetes_version
  min_master_version = var.kubernetes_version

  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service
  enable_binary_authorization = var.enable_binary_authorization

  remove_default_node_pool = var.remove_default_node_pool

  node_pool {
    name               = "default-pool"
    initial_node_count = var.initial_node_count

    node_config {

    }
  }

  lifecycle {
      ignore_changes = [node_pool, initial_node_count]
  }

  addons_config {
    http_load_balancing {
      disabled = ! var.http_load_balancing
    }

#    kubernetes_dashboard {
#      disabled = ! var.enable_kubernetes_dashboard
#    }

  }

  master_auth {
    username = var.basic_auth_username
    password = var.basic_auth_password

    client_certificate_config {
      issue_client_certificate = var.issue_client_certificate
    }
  }
}

/******************************************
  Create Container Cluster node pools
 *****************************************/
resource "google_container_node_pool" "pools" {
  provider = google
  for_each = {for pool in var.node_pools:  pool.name => pool}
  name       = each.value.name
  location   = local.location
  cluster    = google_container_cluster.cluster.name
  node_count = lookup(each.value, "node_count", 1)

  lifecycle {
  ignore_changes = [initial_node_count]
  }

  node_config {
    preemptible  = true
    image_type   = lookup(each.value, "image_type", "COS")
    machine_type = lookup(each.value, "machine_type", "n1-standard-1")
    disk_size_gb    = lookup(each.value, "disk_size_gb", 100)
    disk_type       = lookup(each.value, "disk_type", "pd-standard")

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = merge(
      local.node_pools_labels["all"],
      lookup(local.node_pools_labels,each.value.name,{})
    )
    #labels = lookup(each.value, "labels", {})

  }

}
