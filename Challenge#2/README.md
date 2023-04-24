# Challenge #2
A python script to query the meta data of an instance within AWS.

# Script Behaviour:

The script lists all the instance id's if no argument is passed.

Example output -
```
$ python3 metadata.py                    
[
    "i-0828670c4e3bb7c0f",
    "i-0f9e08bafc6134adf"
]
```

If instance id is passed as 1st argument it will output all metadata of that instance as JSON formatted output

Example output (truncated) -
```
$ python3 metadata.py i-0828670c4e3bb7c0f
{
    "AmiLaunchIndex": 0,
    "ImageId": "ami-016c2e7c8b793cd9c",
    "InstanceId": "i-0828670c4e3bb7c0f",
    "InstanceType": "t2.micro",
    ...
    ...
    ...
    "MaintenanceOptions": {
        "AutoRecovery": "default"
    },
    "CurrentInstanceBootMode": "legacy-bios"
}
```

If we need to retrieve a specific key from the instance metadata the 1st argument should be instance ID and 2nd argument should be the key we would like to retrieve

Example output -
```
$ python3 metadata.py i-0828670c4e3bb7c0f RootDeviceName 
/dev/sda1
```


