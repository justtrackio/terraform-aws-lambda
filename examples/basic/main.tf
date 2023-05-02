module "example" {
  source = "../.."

  namespace                = "ns"
  environment              = "env"
  stage                    = "st"
  name                     = "app"
  attributes               = ["foo"]
  aws_account_id           = "1234567890101"
  aws_region               = "eu-central-1"
  container_image_tag      = "latest"
  alarm_create             = false
  container_repository_url = "123456789012.dkr.ecr.us-east-1.amazonaws.com/hello-world"
}
