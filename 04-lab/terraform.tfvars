project_name        = "demo"
instance_count      = 2
instance_type       = "t2.micro"
allowed_cidr_blocks = ["0.0.0.0/0"]
aws_region          = "us-west-2"
key_pair_name       = "labs_key"
tags = {
  Owner = "DevOpsTeam"
}
