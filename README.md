## Amazon AppFlow Samples, Blogs, and Demos

This repository contains example code snippets, blogs and demos for showing how Amazon AppFlow can be used to securely transfer data between SaaS applications (like Salesforce, Marketo, Slack, etc.) and AWS services (like Amazon S3 and Amazon Redshift).

To learn more about Amazon AppFlow visit: https://aws.amazon.com/appflow/

## Samples/ Blogs

| Topic                                                    | Description                                                |
| ----------------------------------------------------------- | ---------------------------------------------------------- |
| [CloudFormation Template to build a flow from Salesforce to S3](https://github.com/aws-samples/amazon-appflow/tree/master/CF-template) | How to use AWS CloudFormation to setup a flow on AppFlow|
| [AppFlow API Samples](https://docs.aws.amazon.com/appflow/1.0/APIReference/API_Operations.html) | How to use AppFlow APIs to setup flows and connector profiles|
| [Upsert Salesforce data into Redshift (private subnet) with S3 work around](sf-appflow-upsert-redshift-lambda/README.md) | Extract salesforce data using Amazon AppFlow and upsert it to Redshift tables hosted on private subnet via Amazon S3|
| [Setup EventBridge & route Salesforce Events to Lambda](https://aws.amazon.com/blogs/compute/building-salesforce-integrations-with-amazon-eventbridge/) | How to set up the integration, and route Salesforce events to an AWS Lambda function for processing|

## Demos

| Topic                                                    | Description                                                |
| ----------------------------------------------------------- | ---------------------------------------------------------- |
| [How to run sentiment analysis on slack data using AppFlow with Amazon Comprehend](slack-appflow-sentiment/README.md) | Extract conversations data from Slack to S3 using AppFlow and run sentiment analysis on it using Amazon Comprehend and Amazon SageMaker|


## Other Resources

- [Product Information](https://aws.amazon.com/appflow/)
- [Getting Started Content](https://aws.amazon.com/appflow/getting-started/)

## License Summary

The sample code is made available under the MIT-0 license. See the LICENSE file.
