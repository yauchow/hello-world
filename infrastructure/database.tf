module "database" {
  source = "./modules/databases/postgres"

  vpc         = module.vpc
  name        = "postrges"
  environment = local.environment
}