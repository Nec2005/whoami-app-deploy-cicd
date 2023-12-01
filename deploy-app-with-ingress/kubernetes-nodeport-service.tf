# Kubernetes Service Manifest (Type: Node Port Service)
resource "kubernetes_service_v1" "myapp_np_service" {
  metadata {
    name = "whoami-nodeport-service"
    annotations = {
      "alb.ingress.kubernetes.io/healthcheck-path" = "/api"
    }    
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.myapp.spec.0.selector.0.match_labels.app
    }
    port {
      name        = "http"
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}
