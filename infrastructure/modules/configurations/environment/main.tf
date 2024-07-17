module "baseConfig" {
  source = "../environment-files"

  # File paths are relative from <root>/infrastructure/locals.tf to files at <root>/environments/
  folder = "../environments/base"
}

module "environmentConfig" {
  source = "../environment-files"

  # File paths are relative from <root>/infrastructure/locals.tf to files at <root>/environments/
  folder = "../environments/${terraform.workspace}"
}

module "config" {
  source = "Invicton-Labs/deepmerge/null"

  maps = [
    module.baseConfig.config,
    module.environmentConfig.config
  ]
}

output "value" {
  value = module.config.merged
}