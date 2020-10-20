terraform {
  required_version = "~> 0.13"
}

provider "google" {
  version = "~> 3.16.0"
  project = var.project
  region  = var.region
  credentials = file(var.file_sa)
}

module "gke_cluster" {
  source = "../"
  project = var.project
  description = "test laba k8s cluster"
  region  = var.region
  cluster_name = "gke-cluster-${terraform.workspace}"
  kubernetes_version = "latest"

  node_pools = [
    {
      name              = "pool-01"
      machine_type      = "e2-medium"
      node_count         = 2
      disk_size_gb      = 150
      disk_type         = "pd-standard"
      image_type        = "COS"
    },
  ]

  node_pools_labels = {
    all = {
      all = true
    }
    pool-01 = {
      name = "pool-01"
    }
  }


}
