provider "helm" {
  kubernetes {
    host                   = "${cluster_endpoint}"
    cluster_ca_certificate = base64decode("${cluster_ca_certificate}")
    client_certificate     = base64decode("${cluster_client_certificate}")
    client_key             = base64decode("${cluster_client_key}")
  }
}
