[![license](https://img.shields.io/github/license/merps/f5-cwl-telegraf)](LICENSE)
[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)
[![coverage report](https://gitlab.wirelessravens.org/merps/f5-cwl-telegraf/badges/master/coverage.svg)](https://gitlab.wirelessravens.org/merps/f5-cwl-telegraf/-/commits/master)
[![pipeline status](https://gitlab.wirelessravens.org/merps/f5-cwl-telegraf/badges/master/pipeline.svg)](https://gitlab.wirelessravens.org/merps/f5-cwl-telegraf/-/commits/master)


# F5-CWL-Telegraf  (WIP)

This HowTo is an attempt to replay AWS CloudWatch Logs, via Telegraf, to Beacon which also provisions
a 3-nic BIG-IP configuration to AWS hosting WordPress that is fronted by EAP+CFN.  

This is built upon the following previous work:

* [F5 Sumologic Refactor](https://github.com/merps/f5-ts-sumo)
* [SRE Multi-Cluster Container Platform](https://github.com/f5devcentral/f5-bd-sre-demo)
* [terraform-aws-bigip](https://github.com/merps/terraform-aws-bigip)

> **_NOTE:_**  terraform-aws-bigip at time of writing has not been merged to F5DevCentral.

There is also some other stuff along the way...

## Prerequisites

To support this deployment pattern the following components are required:

* [Terraform CLI](https://www.terraform.io/docs/cli-index.html)
* [git](https://git-scm.com/)
* [AWS CLI](https://aws.amazon.com/cli/) access.
* [AWS Access Credentials](https://docs.aws.amazon.com/general/latest/gr/aws-security-credentials.html)


## Installation 

This section will over both the provisioning of the previously mentioned architecture using Terraform along
with references to 


### *AWS*

The deployment environment used for development is covered in detail [F5 AWAF Demo](https://github.com/merps/f5devops/f5-swg-aws),
this is a AWS Deployment example of AutoScaling AWAF. For simplicity, steps replicate this deployment are as follows;

***a)***    First, clone the repo:
```
git clone https://github.com/merps/fw-cwl-telegraf.git
```

***b)***    Second, create a [tfvars](https://www.terraform.io/docs/configuration/variables.html) file in the following format to deploy the environment;

#### Inputs
Name | Description | Type | Default | Required
---|---|---|---|---
cidr | CIDR Range for VPC | String | *NA* | **Yes**
region | AWS Deployment Region | String | *NA* | **Yes**
azs | AWS Availability Zones | List | *NA* | **Yes** 
secops-profile | SecurityOperations AWS Profile | String | `default` | **Yes**
customer | Customer/Client Short name used for AWS Tag/Naming | String | `customer` | No
environment | Environment short-name name used for AWS Tag/Naming | String | `demo` | No
project | Project short-name name used for AWS Tag/Naming | String | `project` | No
ec2_key_name | EC2 KeyPair for Instance Creation | String | *NA* | **Yes**


***c)***    Third, intialise and plan the terraform deployment as follows:
```
cd f5-cwl-tele/src/infra/
terraform init
terraform plan --vars-file ../variables.tfvars
```

this will produce and display the deployment plan using the previously created `variables.tfvars` file.


***d)***    Then finally to deploy the successful plan;
```
terraform apply --vars-file ../variables.tfvars
```

> **_NOTE:_**  This architecture deploys two c4.2xlage PAYG BIG-IP Marketplace instances, it is 
recommended to perform a `terraform destroy` to not incur excessive usage costs outside of free tier.


This deployment also covers the provisioning of the additional F5 prerequeset components so required for 
deployment example covered in the [F5 AWAF Demo](https://github.com/merps/f5devops/f5-swg-aws)

### EAP+CFN

[EAP+CFN](https://www.f5.com/c/cloud-2021/f5-eap-aws-cloudfront) is ***TBC*** - currently deployed manually
with outputs from terraform.

## Usage

**TBC**

## TODO 

- [ ] EAP+CFN api metrics out via telegraf -> beacon
- [ ] Codify EAP+CFN with either TF/Anisble
- [ ] secure big-ip using metadata
- [ ] Usage Instructions(?)

## Contributing

See [the contributing file](CONTRIBUTING.md)!

PRs accepted.

## License

[Apache](../LICENSE)
