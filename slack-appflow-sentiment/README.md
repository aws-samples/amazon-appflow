## How to run sentiment analysis on slack data using Amazon AppFlow with Amazon Comprehend

[Amazon AppFlow](https://aws.amazon.com/appflow/) is a fully managed integration service that enables you to securely transfer data between Software-as-a-Service (SaaS) applications like Salesforce, Marketo, Slack, and ServiceNow, and AWS services like Amazon S3 and Amazon Redshift, in just a few clicks. 

Here I am going to demonstrate how you can extract conversations from slack using Amazon AppFlow to Amazon S3. Then I will call the [Amazon Comprehend](https://aws.amazon.com/comprehend/) service which is a natural language processing (NLP) service that uses machine learning to find insights and relationships in text to detect sentiments of the text. I will be using the [Amazon SageMaker](https://aws.amazon.com/sagemaker/) which is a fully managed service that provides every developer and data scientist with the ability to build, train, and deploy machine learning (ML) models quickly, to read the data from Amazon S3, call the Amazon Comprehend API to detect sentiments, and visualize it in Amazon SageMaker Notebook.


## Demonstration Video
[How to run sentiment analysis on slack data using Amazon AppFlow with Amazon Comprehend](https://youtu.be/fCHkIwbcRtg)

## SageMaker Notebook
* [Jupyter Notebook Viewer](https://nbviewer.jupyter.org/github/aws-samples/amazon-appflow/blob/master/slack-appflow-sentiment/notebooks/slack-sentiment.ipynb)
* Notebook Link: https://github.com/aws-samples/amazon-appflow/blob/master/slack-appflow-sentiment/notebooks/slack-sentiment.ipynb
