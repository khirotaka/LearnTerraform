terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

# Terraform {}ブロックには、Terraformがインフラストラクチャのプロビジョニングに使用する必要なプロバイダーを含むTerraform設定が含まれています。
# 各プロバイダーについて、ソース属性はオプションのホスト名、名前空間、およびプロバイダータイプを定義します。
# Terraformは、デフォルトでTerraformレジストリからプロバイダーをインストールします。
# この設定例では、Googleプロバイダーのソースは、registry.terraform.io/hashicorp/googleの略語であるhashicorp/googleとして定義されています。

provider "google" {
  credentials = file(var.credentials_file)

  project = var.project
  region = var.region
  zone = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}


resource "google_compute_instance" "vm_instance" {
  name = "terraform-instance"
  machine_type = "f1-micro"
  tags = ["web", "dev"]
  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }
  
  network_interface {
    # 上のresouce で定義してある
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}