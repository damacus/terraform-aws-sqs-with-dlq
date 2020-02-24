module "queue" {
  source                     = "../../"
  name                       = "test-queue"
  visibility_timeout_seconds = 30

  tags = {
    Environment = "Environment"
    Project     = "Test"
  }
}

provider "aws" {
  region = "eu-west-1"
}

