### CloudFormation Template for Amazon AppFlow

Amazon AppFlow supports AWS CloudFormation for creating and configuring Amazon AppFlow resources such as Connector profile and Amazon AppFlow Flow along with the rest of your AWS infrastructure—in a secure, efficient, and repeatable way. The Amazon AppFlow APIs and SDK give developers programmatic access to Amazon AppFlow functionality, enabling developers to set up flows between source and destinations supported by Amazon AppFlow, create connector profiles and execute flows programmatically.  

AWS CloudFormation provides a common language for you to model and provision AWS and third party application resources in your cloud environment. AWS CloudFormation allows you to use programming languages or a simple text file to model and provision, in an automated and secure manner, all the resources needed for your applications across all regions and accounts. This gives you a single source of truth for your AWS and third party resources. AWS CloudFormation support for Amazon AppFlow is available in all regions where Amazon AppFlow is available.  

To learn more about how to use AWS CloudFormation to provision and manage Amazon AppFlow resources, visit our **[documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_AppFlow.html)**.  

**Note:** We have added comments in the template below for the ease of understanding on how CF Template works for AppFlow. You will not be able to run the template code if it has comments on it. To use the code as it is, you can use this **[clean file](https://github.com/aws-samples/amazon-appflow/blob/master/CF-template/cf-template-sfdc-to-s3.json)** which has the code without comments. 

**About CF Template:** This template helps build a flow from Salesforce to S3. 

**Code:** 

```js
{
    "AWSTemplateFormatVersion": "2010-09-09",
    "Description": "Sample CloudFormation Template for AppFlow: Sample template shows how to create a flow",
    "Metadata": {
        "AWS::CloudFormation::Interface": {
            "ParameterGroups": [
                {
                    "Label": {
                        "default": "Parameters"
                    },
                    "Parameters": [
                        "Connection",
                        "S3Bucket",
                        "Prefix"
                    ]
                }
            ],
            "ParameterLabels": {
                "Connection": {
                    "default": "SFDC Connection Name"
                },
                "S3Bucket": {
                    "default": "S3 Bucket Name to write data to"
                },
                "Prefix": {
                    "default": "S3 prefix to be used to write the data - something like SFDCData"
                }
            }
        }
    },
    "Parameters": {
        "Connection": {
            "Type": "String"
        },
        "S3Bucket": {
            "Type": "String"
        },
        "Prefix": {
            "Type": "String"
        }
    },
    "Resources": {
        "S3bucketpolicy": {
            "Type": "AWS::S3::BucketPolicy",
            "Properties": {
                "Bucket": {
                    "Ref": "S3Bucket"
                },
                "PolicyDocument": {
                    "Version": "2012-10-17",
                    "Statement": [
                        {
                            "Effect": "Allow",
                            "Principal": {
                                "Service": "appflow.amazonaws.com"
                            },
                            "Action": [
                                "s3:PutObject",
                                "s3:AbortMultipartUpload",
                                "s3:ListMultipartUploadParts",
                                "s3:ListBucketMultipartUploads",
                                "s3:GetBucketAcl",
                                "s3:PutObjectAcl"
                            ],
                            "Resource": [
                                {
                                    "Fn::Join": [
                                        "",
                                        [
                                            "arn:aws:s3:::",
                                            {
                                                "Ref": "S3Bucket"
                                            }
                                        ]
                                    ]
                                },
                                {
                                    "Fn::Join": [
                                        "",
                                        [
                                            "arn:aws:s3:::",
                                            {
                                                "Ref": "S3Bucket"
                                            },
                                            "/*"
                                        ]
                                    ]
                                }
                            ]
                        }
                    ]
                }
            }
        },
        "SFDCFlow": {
            "Type": "AWS::AppFlow::Flow",
            "Properties": {
                "Description": "AppFlow Flow integrating SFDC Account Data into the Data Lake",
                // Properties related to Destination connector.
                // Note: many AWS connectors like AmazonS3 don't require a connector profile.
                // AppFlow has access to the S3 bucket through a BucketResourcePolicy, therefore a connectorprofile isn't needed.
                "DestinationFlowConfigList": [
                    {
                        "ConnectorType": "S3",
                        "DestinationConnectorProperties": {
                            "S3": {
                                "BucketName": {
                                    "Ref": "S3Bucket"
                                },
                                "BucketPrefix": {
                                    "Ref": "Prefix"
                                },
                                //the configuration that determine show Amazon AppFlow should format the flow output data when AmazonS3 is used as the destination.
                                "S3OutputFormatConfig": {
                                    //the aggregation settings that you can use to customize the output format of your flowdata. Allowed values: None|SingleFile
                                    "AggregationConfig": {
                                        "AggregationType": "None"
                                    },
                                    //indicates the file type that AmazonAppFlow places in the AmazonS3 bucket.Allowed values: CSV|JSON|PARQUET
                                    "FileType": "PARQUET"
                                }
                            }
                        }
                    }
                ],
                "FlowName": "SFDCAccount",
                // Properties related to Source connector
                "SourceFlowConfig": {
                    // To create a flow,you must first create a connector profile that contains information about connecting to Salesforce.
                    // ConnectorProfileName is the name for the connector profile created through console or ref to the resource if created through CFN template.
                    "ConnectorProfileName": {
                        "Ref": "Connection"
                    },
                    "ConnectorType": "Salesforce",
                    "SourceConnectorProperties": {
                        "Salesforce": {
                            // The flag that enables dynamic fetching of new(recently added) fields in the Salesforce objects while running a flow.
                            "EnableDynamicFieldUpdate": false,
                            // Indicates whether AmazonAppFlow includes deleted files in the flow run.
                            "IncludeDeletedRecords": false,
                            // The object specified in the flow source (here, Salesforce).
                            "Object": "Account"
                        }
                    }
                },
                // "Tasks" describe what to do with the data once it has been retrieved, but before it is sent to the destination.
                // Most connectors require a projection task, a projection task describes what fields should be retrieved from the source object.
                "Tasks": [
                    {
                        // Specifies the particular task implementation that AmazonAppFlow performs. Allowed values: Arithmetic|Filter|Map|Mask|Merge|Truncate|Validate
                        // For projection tasks, selected task type has to be filter
                        "TaskType": "Filter",
                        "SourceFields": [
                            "Id",
                            "Name",
                            "Type",
                            "BillingAddress",
                            "ShippingAddress",
                            "Phone",
                            "Sic",
                            "Industry",
                            "AnnualRevenue"
                        ],
                        // Define the operation to be performed on the provided source fields.Allowed values can be found at https: //docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-appflow-flow-connectoroperator.html
                        "ConnectorOperator": {
                            "Salesforce": "PROJECTION"
                        }
                    },
                    {
                        // Most flows also require atleast one mapping task. mapping tasks map a source field to a destination field (here, mapping Id to Id).
                        // Note: projected fields will only showup in the destination if they have a mapping task.
                        "TaskType": "Map",
                        "SourceFields": [
                            "Id"
                        ],
                        // A map used to store task-related information. More info at https: //docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-appflow-flow-taskpropertiesobject.html
                        "TaskProperties": [
                            {
                                "Key": "SOURCE_DATA_TYPE",
                                "Value": "id"
                            },
                            {
                                "Key": "DESTINATION_DATA_TYPE",
                                "Value": "id"
                            }
                        ],
                        "DestinationField": "Id",
                        "ConnectorOperator": {
                            "Salesforce": "NO_OP"
                        }
                    },
                    {
                        "TaskType": "Map",
                        "SourceFields": [
                            "Name"
                        ],
                        "TaskProperties": [
                            {
                                "Key": "SOURCE_DATA_TYPE",
                                "Value": "string"
                            },
                            {
                                "Key": "DESTINATION_DATA_TYPE",
                                "Value": "string"
                            }
                        ],
                        "DestinationField": "Name",
                        "ConnectorOperator": {
                            "Salesforce": "NO_OP"
                        }
                    },
                    {
                        "TaskType": "Map",
                        "SourceFields": [
                            "Type"
                        ],
                        "TaskProperties": [
                            {
                                "Key": "SOURCE_DATA_TYPE",
                                "Value": "picklist"
                            },
                            {
                                "Key": "DESTINATION_DATA_TYPE",
                                "Value": "picklist"
                            }
                        ],
                        "DestinationField": "Type",
                        "ConnectorOperator": {
                            "Salesforce": "NO_OP"
                        }
                    },
                    {
                        "TaskType": "Map",
                        "SourceFields": [
                            "BillingAddress"
                        ],
                        "TaskProperties": [
                            {
                                "Key": "SOURCE_DATA_TYPE",
                                "Value": "address"
                            },
                            {
                                "Key": "DESTINATION_DATA_TYPE",
                                "Value": "address"
                            }
                        ],
                        "DestinationField": "BillingAddress",
                        "ConnectorOperator": {
                            "Salesforce": "NO_OP"
                        }
                    },
                    {
                        "TaskType": "Map",
                        "SourceFields": [
                            "ShippingAddress"
                        ],
                        "TaskProperties": [
                            {
                                "Key": "SOURCE_DATA_TYPE",
                                "Value": "address"
                            },
                            {
                                "Key": "DESTINATION_DATA_TYPE",
                                "Value": "address"
                            }
                        ],
                        "DestinationField": "ShippingAddress",
                        "ConnectorOperator": {
                            "Salesforce": "NO_OP"
                        }
                    },
                    {
                        "TaskType": "Map",
                        "SourceFields": [
                            "Phone"
                        ],
                        "TaskProperties": [
                            {
                                "Key": "SOURCE_DATA_TYPE",
                                "Value": "phone"
                            },
                            {
                                "Key": "DESTINATION_DATA_TYPE",
                                "Value": "phone"
                            }
                        ],
                        "DestinationField": "Phone",
                        "ConnectorOperator": {
                            "Salesforce": "NO_OP"
                        }
                    },
                    {
                        "TaskType": "Map",
                        "SourceFields": [
                            "Sic"
                        ],
                        "TaskProperties": [
                            {
                                "Key": "SOURCE_DATA_TYPE",
                                "Value": "string"
                            },
                            {
                                "Key": "DESTINATION_DATA_TYPE",
                                "Value": "string"
                            }
                        ],
                        "DestinationField": "Sic",
                        "ConnectorOperator": {
                            "Salesforce": "NO_OP"
                        }
                    },
                    {
                        "TaskType": "Map",
                        "SourceFields": [
                            "Industry"
                        ],
                        "TaskProperties": [
                            {
                                "Key": "SOURCE_DATA_TYPE",
                                "Value": "picklist"
                            },
                            {
                                "Key": "DESTINATION_DATA_TYPE",
                                "Value": "picklist"
                            }
                        ],
                        "DestinationField": "Industry",
                        "ConnectorOperator": {
                            "Salesforce": "NO_OP"
                        }
                    },
                    {
                        "TaskType": "Map",
                        "SourceFields": [
                            "AnnualRevenue"
                        ],
                        "TaskProperties": [
                            {
                                "Key": "SOURCE_DATA_TYPE",
                                "Value": "currency"
                            },
                            {
                                "Key": "DESTINATION_DATA_TYPE",
                                "Value": "currency"
                            }
                        ],
                        "DestinationField": "AnnualRevenue",
                        "ConnectorOperator": {
                            "Salesforce": "NO_OP"
                        }
                    },
                    {
                        "TaskType": "Validate",
                        "SourceFields": [
                            "Id"
                        ],
                        "TaskProperties": [
                            {
                                "Key": "VALIDATION_ACTION",
                                "Value": "DropRecord"
                            }
                        ],
                        "ConnectorOperator": {
                            "Salesforce": "VALIDATE_NON_NULL"
                        }
                    },
                    {
                        "TaskType": "Mask",
                        "SourceFields": [
                            "Phone"
                        ],
                        "TaskProperties": [
                            {
                                "Key": "MASK_LENGTH",
                                "Value": "5"
                            },
                            {
                                "Key": "MASK_VALUE",
                                "Value": "*"
                            }
                        ],
                        "ConnectorOperator": {
                            "Salesforce": "MASK_LAST_N"
                        }
                    }
                ],
                "TriggerConfig": {
                    // Configuration related to trigger type: OnDemand, Scheduled, Event
                    "TriggerType": "OnDemand"
                }
            },
            "DependsOn": "S3bucketpolicy"
        }
    }
}		
```
