#Config TFC
terraform {
  cloud {
    organization = "Challenges"
    workspaces {
      name = "Challenges"
    }
  }
}