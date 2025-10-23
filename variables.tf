variable "cluster_name" {
  description = "The name of the kind cluster"
  type        = string
  default     = "dev-cluster"
}

variable "control_plane_node_image" {
  description = "The node image for the kind cluster"
  type        = string
  default     = "kindest/node:v1.29.1"
}

variable "worker_node_image" {
  description = "The node image for the kind cluster"
  type        = string
  default     = "kindest/node:v1.29.1"
}

variable "kubeconfig_path" {
  description = "The path to export the kubeconfig file"
  type        = string
  default     = "~/.kube/kind-config.yaml"
}

variable "api_server_port" {
  description = "The API server port for the kind cluster"
  type        = number
  default     = 6443
}