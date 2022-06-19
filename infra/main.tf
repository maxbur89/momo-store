# CONTROL PLANE

resource "yandex_kubernetes_cluster" "k8s-cluster-mxl" {

 name        = "k8s-cluster-mxl"
 description = "Cluster k8s mxl"

 network_id = yandex_vpc_network.k8s-network1.id
 master {
   version = "1.21"
   zonal {
     zone      = yandex_vpc_subnet.k8s-subnet1.zone
     subnet_id = yandex_vpc_subnet.k8s-subnet1.id
   }
   public_ip = true

   maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "03:00"
        duration   = "3h"
      }
    }
 }
 service_account_id      = yandex_iam_service_account.k8s-manager-mxl.id
 node_service_account_id = yandex_iam_service_account.k8s-manager-mxl.id
   depends_on = [
     yandex_resourcemanager_folder_iam_binding.editor,
     yandex_resourcemanager_folder_iam_binding.images-puller
   ]
 release_channel = "REGULAR"
}

resource "yandex_vpc_network" "k8s-network1" { name = "k8s-network1" }

resource "yandex_vpc_subnet" "k8s-subnet1" {
 v4_cidr_blocks = ["10.1.0.0/16"]
 zone           = "ru-central1-a"
 network_id     = yandex_vpc_network.k8s-network1.id
}

resource "yandex_iam_service_account" "k8s-manager-mxl" {
 name        = "k8s-manager-mxl"
 description = "Service account for k8s"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
 folder_id = "b1g258e1e9ejogc2jt0a"
 role      = "editor"
 members   = [
   "serviceAccount:${yandex_iam_service_account.k8s-manager-mxl.id}"
 ]
}

resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
 folder_id = "b1g258e1e9ejogc2jt0a"
 role      = "container-registry.images.puller"
 members   = [
   "serviceAccount:${yandex_iam_service_account.k8s-manager-mxl.id}"
 ]
}




#NODE
resource "yandex_kubernetes_node_group" "k8s-node-group-mxl" {
  cluster_id  = "${yandex_kubernetes_cluster.k8s-cluster-mxl.id}"
  name        = "k8s-node-group-mxl"
  description = "k8s-node-group-mxl"
  version     = "1.21"

  labels = {
    "node_type" = "node"
  }

  instance_template {
    platform_id = "standard-v1"

    network_interface {
      nat                = true
      subnet_ids         = ["${yandex_vpc_subnet.k8s-subnet1.id}"]
    }

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "03:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "03:00"
      duration   = "4h30m"
    }
  }
}


#BALANCER
resource "yandex_lb_network_load_balancer" "internal-lb-momo-store" {
  name = "external-lb-momo-store"

  listener {
    name = "listiner-momo-store"
    port = 443
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = "${yandex_lb_target_group.k8s-node-group-mxl.id}"

    healthcheck {
      name = "http"
      http_options {
        port = 8080
        path = "/ping"
      }
    }
  }
}
