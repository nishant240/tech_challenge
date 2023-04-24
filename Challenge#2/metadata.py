import boto3
import json
import sys
from datetime import datetime

# Function to convert datetime objects to strings
def datetime_converter(o):
    if isinstance(o, datetime):
        return o.__str__()

# Create a Boto3 EC2 client using the default profile from the AWS CLI config
session = boto3.Session(profile_name='default')
ec2_client = session.client('ec2')

# Retrieve metadata for all instances
response = ec2_client.describe_instances()
instances_metadata = []
for reservation in response['Reservations']:
    for instance in reservation['Instances']:
        instances_metadata.append(instance)

# Check the number of arguments passed
if len(sys.argv) > 1:

    # If only one argument is passed, assume it's an instance ID and print its metadata
    instance_id = sys.argv[1]
    for metadata in instances_metadata:
        if metadata['InstanceId'] == instance_id:
            if len(sys.argv) == 2:
                print(json.dumps(metadata, indent=4, default=datetime_converter))
            elif len(sys.argv) == 3:

                # If a second argument is passed, assume it's a key name and print its value for the instance ID
                key_name = sys.argv[2]
                if key_name in metadata:
                    print(metadata[key_name])
                else:
                    print(f"{key_name} not found in instance metadata")
            break
    else:
        print(f"{instance_id} is not a valid instance id")
else:
    
    # Print the JSON-formatted output for all instance IDs
    instance_ids = [metadata['InstanceId'] for metadata in instances_metadata]
    print(json.dumps(instance_ids, indent=4))
