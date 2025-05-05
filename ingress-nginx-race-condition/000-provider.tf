terraform {
  required_providers {
    # Used to create a local cluster
    kind = {
      source = "tehcyx/kind"
      version = "0.8.0"
    }

    # Used to create namespaces and example workloads
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.35.1"
    }

    # Used to install and configure ingress-nginx in the cluster
    helm = {
      source = "hashicorp/helm"
      version = "2.16.1"
    }
  }
}

provider "kind" {
}

provider "kubernetes" {
  host = kind_cluster.this.endpoint
  client_certificate = kind_cluster.this.client_certificate
  client_key = kind_cluster.this.client_key
  cluster_ca_certificate = kind_cluster.this.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host = kind_cluster.this.endpoint
    client_certificate = kind_cluster.this.client_certificate
    client_key = kind_cluster.this.client_key
    cluster_ca_certificate = kind_cluster.this.cluster_ca_certificate
  }
}
