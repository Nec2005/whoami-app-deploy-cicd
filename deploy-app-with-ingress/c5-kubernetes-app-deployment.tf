# Kubernetes Deployment Manifest
resource "kubernetes_deployment_v1" "myapp" {
  metadata {
    name = "whoami-deployment"
    labels = {
      app = "whoami"
    }
  } 
 
  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "whoami"
      }
    }

    template {
      metadata {
        labels = {
          app = "whoami"
        }
      }

      spec {
        container {
          image = "${var.image_registry}:${var.image_tag}"
          name  = "whoami"
          port {
            container_port = 80
          }
          }
        }
      }
    }
}

