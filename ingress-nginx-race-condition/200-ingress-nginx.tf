# Namespace for the ingress controller
resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"

    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
      "pod-security.kubernetes.io/audit" = "privileged"
      "pod-security.kubernetes.io/warn" = "privileged"
    }
  }
}

# Install the ingress controller
resource "helm_release" "ingress_nginx" {
  # Make the helm provider remove helm values when removing them from the manifest
  reset_values = true

  namespace = kubernetes_namespace.ingress_nginx.metadata[0].name
  name = "ingress-nginx"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart = "ingress-nginx"
  version = "4.12.1"

  values = [
    yamlencode({
      controller = {
        ingressClassResource = {
          default = true
        }

        # Avoid using a load balancer service for the ingress controller.
        # Instead, use a DaemonSet with hostPorts, so the ingress controller is available on all worker nodes.
        kind = "DaemonSet"
        hostPort = {
          enabled = true
        }
        service = {
          enabled = false
        }
      }
    }),
  ]
}
