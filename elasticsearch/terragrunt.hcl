terraform {
  source = "git::git@github.com:bayudwiyansatria/terraform-modules//terraform-helm-elasticsearch?ref=master"
}

locals {
  provider_tpl_file = "provider.tpl"
  parsed_path       = regex(".*/(?P<company>.*?)/(?P<cloud>.*?)/(?P<environment>.*?)/(?P<platform>.*)", abspath(path_relative_to_include()))

  // Extracted Value
  company     = local.parsed_path.company
  cloud       = local.parsed_path.cloud
  environment = local.parsed_path.environment
  platform    = local.parsed_path.platform

  // Get Account
  account = lookup(lookup(yamldecode(file("${dirname(find_in_parent_folders())}/_accounts/${local.cloud}.yaml")), local.company), local.environment)
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = templatefile(local.provider_tpl_file, {
    cluster_endpoint           = local.account.cluster_endpoint,
    cluster_ca_certificate     = local.account.cluster_ca_certificate,
    cluster_client_certificate = local.account.cluster_client_certificate,
    cluster_client_key         = local.account.cluster_client_key
  })
}
