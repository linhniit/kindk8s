output "cluster_name" {
  value = kind_cluster.default.name
  description = "The name of the kind cluster"
}

output "control_plane_node_image" {
  value = var.control_plane_node_image
}

#output "kubeconfig_path" {
#  value = var.kubeconfig_path
#  description = "path of the kubeconfig file"
#}