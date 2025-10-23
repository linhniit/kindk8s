terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = ">= 0.6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.10.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
  }
}

provider "kind" {}

provider "helm" {
  kubernetes = {
    config_path = pathexpand("~/.kube/config")
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  depends_on = [kind_cluster.default]
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  #version          = "5.41.6"

  set = [
    {
      name  = "server.service.type"
      value = "NodePort"
    },
    {
      name  = "server.service.nodePortHttp"
      value = "30081"
    },
    {
      name  = "server.service.nodePortHttps"
      value = "30443"
    },
    {
      name  = "configs.params.server.insecure"
      value = "true"
    }
  ]

  #depends_on = [kind_cluster.default]
}



resource "kind_cluster" "default" {
  name            = var.cluster_name
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role  = "control-plane"
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
      role  = "worker"
      image = var.worker_node_image
    }
  }
}
