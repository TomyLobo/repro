locals {
  labels_example_ingress = {
    app = "example-ingress"
  }
}

# In my actual use case, there's also a deployment here.
# However, that deployment takes too long to start.
# This delays ingress creation enough to prevent repro.
# In my actual use case, I have a second deployment with the same image, but which does not depend on ingress_nginx.
# That second deployment essentially pre-pulls the image.
# That means the deployment starts up fast enough to allows repro.
# To simplify this test case, I removed that deployment entirely.

resource "kubernetes_service" "example_ingress" {
  depends_on = [
    helm_release.ingress_nginx,
  ]

  metadata {
    name = "example-ingress"
  }

  spec {
    selector = local.labels_example_ingress
    port {
      port = 80
      target_port = 80
    }
  }
}

resource "kubernetes_ingress_v1" "example_ingress" {
  metadata {
    name = "example-ingress"
  }

  spec {
    rule {
      host = "example-ingress.example.com"

      http {
        path {
          path = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.example_ingress.metadata[0].name

              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
