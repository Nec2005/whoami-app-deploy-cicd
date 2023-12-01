
resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name = "ingress-myapp-demo"
    annotations = {
      # Load Balancer Name
      "alb.ingress.kubernetes.io/load-balancer-name" = "certdiscoverytls-ingress"
      # Ingress Core Settings
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
      # Health Check Settings
      "alb.ingress.kubernetes.io/healthcheck-protocol" =  "HTTP"
      "alb.ingress.kubernetes.io/healthcheck-port" = "traffic-port"
      "alb.ingress.kubernetes.io/healthcheck-interval-seconds" = 15
      "alb.ingress.kubernetes.io/healthcheck-timeout-seconds" = 5
      "alb.ingress.kubernetes.io/success-codes" = 200
      "alb.ingress.kubernetes.io/healthy-threshold-count" = 2
      "alb.ingress.kubernetes.io/unhealthy-threshold-count" = 2
      ## SSL Settings
      "alb.ingress.kubernetes.io/listen-ports" = jsonencode([{"HTTPS" = 443}, {"HTTP" = 80}])
      # SSL Redirect Setting
      "alb.ingress.kubernetes.io/ssl-redirect" = 443
    # External DNS - For creating a Record Set in Route53
      "external-dns.alpha.kubernetes.io/hostname" = "${var.service_dns_prefix}.necatidevops.co.uk"
    }    
  }
  spec {
    ingress_class_name = "my-aws-ingress-class" # Ingress Class            
    # SSL Certificate Discovery using TLS
    tls {
      hosts = [ "*.necatidevops.co.uk" ]
    }      
    rule {
      http {
        path {
          backend {
            service {
              name = kubernetes_service_v1.myapp_np_service.metadata[0].name
              port {
                number = 80
              }
            }
          }
          path = "/"
          path_type = "Prefix"
        }

      }
    }
  }
}



