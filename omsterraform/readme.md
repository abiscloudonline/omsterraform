# the file list
* omsterraform/modules/awstransferfamily/transferfamily.tf - this is to  create aws transfer server with required user access and transfer bucket in s3  
* omsterraform/modules/awstransferfamily/variables.tf - contains the details of variables used in transferfamily.tf 
* omsterraform/modules/awsmskkafka/kafka.tf - this is to msk cluster 
* omsterraform/modules/awsmskkafka/variables.tf - contains the details of variables used in kafka.tf
* omsterraform/modules/publicnetwork/vpc.tf - this is to provision the public network
* omsterraform/modules/publicnetwork/variables.tf - contains the details of variables used in vpc.tf
* omsterraform/modules/apigateway/apigateway.tf - this is to provision the Rest API Gateway
* omsterraform/modules/apigateway/variables.tf - contains the details of variables used in apigateway.tf
* omsterraform/modules/apigateway/policy.tf - Contains the Sample Policy to invoke lambda
* omsterraform/modules/cognito/coginto.tf - This is to provision the cognito user, resource, client pool
* omsterraform/modules/cognito/variables.tf - contains the details of variables used in cognito.tf
* omsterraform/modules/sts/sts.tf - This is to access ec2 instance from another AWS account using STS
* omsterraform/modules/vpcendpoint/vpcendpoints3.tf - This is to provision the VPC endpoint for s3
* omsterraform/modules/vpcendpoint/variables.tf - contains the details of variables used in vpcendpoints3.tf
* omsterraform/modules/awsservicecatalog/service_catalog_vpc.tf - This is to provision the VPC endpoint for s3
* omsterraform/modules/awsservicecatalog/service_catalog_ecsrole.tf - This is to provision the VPC endpoint for s3
* omsterraform/modules/awsservicecatalog/service_catalog_portfolio.tf - This is to provision the VPC endpoint for s3
* omsterraform/modules/awsservicecatalog/variables.tf - contains the details of variables used in service_catalog_vpc.tf,service_catalog_ecsrole.tf,service_catalog_portfolio.tf
* omsterraform/configuration/vars.tf - to provision aws services in various envronments like dev, pre-prod, prod 




# command to provision the resources
terrform apply --var-file=/configuration/dev.tfvars
