### Terraform-Jenkins2-ECS


#### How to Run
Export the AWS Creds

```

 $ export AWS_ACCESS_KEY_ID=AK**
 $ export AWS_SECRET_ACCESS_KEY=O4Z***
 $ export AWS_DEFAULT_REGION="u**"

 $ export TERRAFORM_STATE_BUCKET="tf-artifact-bucket"
 $ export TERRAFORM_STATE_S3_KEY="sample-ecs-tf"

 $ export TF_VAR_region="ap-northeast-1"
 $ export TF_VAR_environment="test"

```
Rename file `terraform.tfvars.dummy` to `terraform.tfvars`
	
	```
	Note: terraform.tfvars file is ignored from git commit
	```

Update varialbes in `terraform.tfvars`

Initialize terraform

```
$ terraform init -backend-config "region=$TF_VAR_region" \
	       -backend-config "bucket=$TERRAFORM_STATE_BUCKET" \
	       -backend-config "key=$TERRAFORM_STATE_BUCKET/$TERRAFORM_STATE_S3_KEY"

```

Plan and Apply

```

 $ terraform plan
 $ terraform apply

```
