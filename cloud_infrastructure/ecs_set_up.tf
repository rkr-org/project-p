module "ecs_creation" {
  source           = "./modules/common-ecs-module"
  ecs_cluster_name = var.ecs_cluster_name
  aws_account_id   = data.aws_caller_identity.this.account_id
  aws_region       = var.aws_region
  environment      = var.environment
}
