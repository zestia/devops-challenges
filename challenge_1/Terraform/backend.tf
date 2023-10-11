#Config TFC
terraform {
  cloud {
    organization = "devops-challenges"
    workspaces {
      name = "devops-challenges"
    }
  }
}