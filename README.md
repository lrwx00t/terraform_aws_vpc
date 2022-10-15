# Terraform VPC Task

Troubleshooting an fixing all issues in the terraform project.

## Summary of all fixes/changes:

```bash
❯ git --no-pager log --decorate=short --pretty=format:"* %s"

* Output logs - showing logs for completed apply and destroy commands after running it on a personal AWS account
* Refactor - run terraform fmt
* Fix warning: moved version to required_providers block to fix a warning for a deprecated syntax
* Skip retired features. EC2 Classic is retried and no longer required.
* FIX: completed missing implementation for private_subnets aws_subnet resource
* FIX: missing required arfument in the module sandbox_vpc.
* FIX/TYPO: this seems to be a typo. vpc_ciddrr_block -> vpc_cidr_block
* FIX: wrong path references in sandbox_vpc module. It should up for one parent directory.
* FIX: missing required value for the output id. It should output the provisioned VPC as mentioned in the description.
* FIX: missing count index in the route_table_id of the private_rta resource. Need to specify the count index so terrraform can iterate over the list of the RT associated with each subnet_id.
* FIX: missing value for the gateway_id attribute in the public_rt resource. Assigning the value of the internet gateway id for the public routing table resource
* FIX: missing value for the attribute count in the public_subnets resource. The value has been set to match the number/length of elements in the public_subnet_cidr_blocks
* Fix: missing attribute value in the public_subnets resource. Need to assign a value for the VPC id of the applica_vpc resource in the previous block.
* FIX: wrong type in variable private_subnet_cidr_blocks. Assigned string instead of list
* Init commit for adding the default task files and .gitignore (vscode settings included)%
```

## Notes:

- Each fix is explained inline within the code and has its own commit message and log.
- The template was deployed successfully and resources have been cleaned up and destroyed. Relevant logs can be found in the `apply-output` directory.
