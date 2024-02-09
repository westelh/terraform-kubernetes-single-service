resource "random_id" "id" {
  byte_length = 8
}

resource "kubernetes_deployment" "app" {
  metadata {
    name      = "${var.app_name}-${random_id.id.hex}"
    namespace = "default"
    labels = {
      "waypointproject.io/template"   = "single-service"
      "waypointproject.io/id"         = random_id.id.hex
      "waypointproject.io/app"        = var.app_name
      "app.kubernetes.io/name"        = var.app_name
      "app.kubernetes.io/managed-by"  = "Terraform"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "waypointproject.io/id"  = random_id.id.hex
        "waypointproject.io/app" = var.app_name
      }
    }
    template {
      metadata {
        labels = {
          "waypointproject.io/id"  = random_id.id.hex
          "waypointproject.io/app" = var.app_name
        }
      }
      spec {
        container {
          image = var.app_image
          name  = var.app_name
          port {
            container_port = var.port
          }
          args = var.arguments
          liveness_probe {
            http_get {
              path = "/"
              port = var.port
            }
            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name      = "${var.app_name}-${random_id.id.hex}"
    namespace = "default"
    labels = {
      "waypointproject.io/template"   = "single-service"
      "waypointproject.io/id"         = random_id.id.hex
      "waypointproject.io/app"        = var.app_name
      "app.kubernetes.io/name"        = var.app_name
      "app.kubernetes.io/managed-by"  = "Terraform"
    }
  }
  spec {
    selector = {
      "waypointproject.io/id"  = random_id.id.hex
      "waypointproject.io/app" = var.app_name
    }
    port {
      port        = var.port
      target_port = var.port
    }
  }
}
