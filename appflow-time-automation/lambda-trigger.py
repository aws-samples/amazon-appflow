#
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify,
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

import json
import boto3
import os
from datetime import timedelta
from datetime import datetime
from urllib.parse import urlparse

template_url = os.environ['templateUrl']
conn_name = os.environ['connName']
time_field = os.environ['timeField']
bucket_name = os.environ['bucketName']
num_past_days = os.environ['numPastDays']

def parse_params():
  start_date = datetime.today() - timedelta(days=num_past_days-1)
  print (start_date)
  start_date = start_date.date().strftime('%s') + '000'
  end_date = datetime.today()
  print (end_date)
  end_date = end_date.date().strftime('%s') + '000'
  current_ts = datetime.now().isoformat().split('.')[0].replace(':','-')
  flow_name = 'ajedailyflow' + current_ts
  
  template_params = [
        {
            'ParameterKey': 'flowname',
            'ParameterValue': flow_name,
        },
        {
            'ParameterKey': 'connname',
            'ParameterValue': conn_name,
        },
        {
            'ParameterKey': 'timefield',
            'ParameterValue': time_field,
        },
        {
            'ParameterKey': 'startdate',
            'ParameterValue': start_date,
        },
        {
            'ParameterKey': 'enddate',
            'ParameterValue': end_date,
        },
        {
            'ParameterKey': 'bucketname',
            'ParameterValue': bucket_name,
        },
    ]
  print (template_params)
  return template_params

def launch_stack():
  cfn = boto3.client('cloudformation')
  current_ts = datetime.now().isoformat().split('.')[0].replace(':','-')
  stackname = 'mystackflow' + current_ts
  capabilities = ['CAPABILITY_IAM', 'CAPABILITY_AUTO_EXPAND']
  try:
    template_params = parse_params()
    stackdata = cfn.create_stack(
      StackName=stackname,
      DisableRollback=True,
      TemplateURL=template_url,
      Parameters=template_params,
      Capabilities=capabilities)
  except Exception as e:
    print(str(e))
  return stackdata  

def handler(event, context):
  print("Received event:")
  stack_result=launch_stack()
  print(stack_result)