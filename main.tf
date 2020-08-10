locals {
  location   =  var.region
  region     =  var.region

  node_pools_labels = merge(
    { all = {} },
    { default-node-pool = {} },
    var.node_pools_labels
  )

}
