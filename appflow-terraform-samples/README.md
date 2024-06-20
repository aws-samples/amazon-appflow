# HashiCorp Terraform samples for Amazon Appflow
--------------------------------------
These samples demostrate how you can use HashiCorp Terraform to automate the deployment of your Data Flows between AWS Services and SaaS applications with [Amazon AppFlow](https://aws.amazon.com/appflow/).


## Prerequisites
--------------------------------------

The prerequisites depend on your Flow sources and destinations. Please review the [AWS Documentation](https://docs.aws.amazon.com/appflow/latest/userguide/app-specific.html) for Amazon Flow supported sources and destinations.

Each folder covers a specific use-case, please review the prerequisites in each of them. In general:

- An AWS Account that will be used to run the [Amazon AppFlows](https://aws.amazon.com/appflow/) Flows
- Access to your AWS Environment and specific resources
- Amazon Appflow connection to your specific Application. 
- [Terraform v1.4.5](https://releases.hashicorp.com/terraform/1.4.5/) or later installed

## Considerations
--------------------------------------
1. Run your Terraform commands as per the best practices and recommendations depending on your use case.
2. Make sure to store and secure your Terraform State file accordingly.
3. Ingest Variables using your preferred method

## Use-cases

Current directories in this Sample:

- salesforce-appflow-amazon-s3: Describes API Connection from Amazon AppFlow to Salesforce, and exports data to Amazon S3. 
- salesforce-private-connect-appflow-amazon-s3: Some customers may need to connect privately to Salesforce using [Private Connect feature](https://help.salesforce.com/s/articleView?id=sf.private_connect_overview.htm&type=5) in an AWS Region that is [not supported by Salesforce](https://help.salesforce.com/s/articleView?id=sf.private_connect_considerations.htm&type=5). This sample describes a workaround to this limitation. It establishes Private connection from Amazon AppFlow to Salesforce on a supported AWS Region (Pivot Region) exporting Data on Amazon S3. Then, Data is going to be replicated to an Amazon S3 Bucket in the desired AWS Region. There are multiples ways to replicate Data from one Amazon S3 Bucket to another. For this sample We replicate Data using [S3 Cross-Region replication](https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication.html#crr-scenario)

## Security
--------------------------------------

See [CONTRIBUTING](CONTRIBUTING.md) for more information.

## License
--------------------------------------

This library is licensed under the MIT-0 License. See the [LICENSE](LICENSE) file.

