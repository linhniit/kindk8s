terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = ">= 0.6.0"
    }
  }
}

provider "kind" {}

# creating a cluster with kind of the name "test-cluster" with kubernetes version v1.27.1 and two nodes
resource "kind_cluster" "default" {
    name = "test-cluster"
    #node_image = "kindest/node:v1.27.1"
    kind_config  {
        kind = "Cluster"
        api_version = "kind.x-k8s.io/v1alpha4"
        node {
            role = "control-plane"
            image = var.control_plane_node_image
            kubeadm_config_patches = [  
              "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
            ]
            extra_port_mappings {
        container_port = 80
        host_port      = 80
      }

      extra_port_mappings {
        container_port = 443
        host_port      = 443
      }
        }
        node {
            role =  "worker"
            image = var.worker_node_image
        }
    }
}

# resource "kind_cluster" "test-cluster-1" {
#     name           = "test-cluster-1"
#     wait_for_ready = true

#   kind_config {
#       kind        = "Cluster"
#       api_version = "kind.x-k8s.io/v1alpha4"

#       node {
#           role = "control-plane"

#           kubeadm_config_patches = [
#               "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
#           ]

#           extra_port_mappings {
#               container_port = 80
#               host_port      = 80
#           }
#           extra_port_mappings {
#               container_port = 443
#               host_port      = 443
#           }
#       }

#       node {
#           role = "worker"
#       }
#   }
# }