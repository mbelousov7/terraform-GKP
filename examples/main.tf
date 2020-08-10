terraform {
  required_version = ">= 0.12"
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

  node_pools = [
    {
      name            = "pool-01"
      machine_type      = "n1-standard-2"
      node_count       = 1
    },
    {
      name              = "pool-02"
      machine_type      = "n1-standard-2"
      node_count         = 1
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
    pool-02 = {
      name = "pool-02"
      active = true
    }
  }


}
