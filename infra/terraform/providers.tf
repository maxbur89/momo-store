terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.75.0"
    }
  }

  backend "s3" {
    endpoint = "http://localhost:9000"
    key = "terraform.tfstate"
    bucket = "momo-store"
    region = "main"
    skip_credentials_validation = true
    skip_metadata_api_check = true
    skip_region_validation = true
    force_path_style = true
    # access_key = var.access_key
    # secret_key = var.secret_key
    # or
    # логин и пароль сервисного аккаунта yandex cloud
    # export AWS_ACCESS_KEY_ID="momo"
    # export AWS_SECRET_ACCESS_KEY="aiJeer7aix"
    # https://oauth.yandex.ru/
    # export TF_VAR_token=
  }
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}
