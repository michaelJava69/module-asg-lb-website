##
#
#  Terraform Website deployment using asg, lb , 
#      ec2 instances, router, and internet gateway
#
#####################################

```
Terraform code that created a Load Balanced / Auto Scaling Group controlled Web Application that would run in AWS. across two availability zones in a non default VPC
```

```

Note:

With instructions below please bear in mind what role Arn has ben assigned to you. Also bear in mind new security tags restrictions newly implemented in AWS

Key Pairs
---------

So in order to give users the ability to ssh onto the newly crated Linux vms we ae going to use the aws_key_pair resource we have to create a key up front in AWS.

Goto the Key Pairs screen in AWS
    click Create key pair button top right
        Give your key a name i.e chapter5
                leave pem radio button
        Click create key pair

    Your key will be downloaded to your pc
    Store in the following directory for thus exercide [ ~/certification/keypair/keypair/]

    Create a corresponding public key from your pem/private key
            Follow this link  :  https://docs.jamcracker.com/latest/Knowledge%20Hub/topic/public_key.html

                ssh-keygen -y -f <private_key1.pem > <public_key1.pub>
                [rem to chmod your private key 400 - to restrict access to it ]

            Place this in the same folder.
            Call it chapter5.pub


```


```

#################################################################
#How to use mfa Assumed role script : start_aws_profile.sh
#Used to aget access to AWS profile
#####################################

Step 1:
------

How to set up ~/.aws/config
---------------------------
[profile default]
#region = eu-west-2
region = us-east-2

[profile dev]
region = us-east-2
#region = eu-west-2
source_profile = mfa
role_arn = arn:aws:iam::904806826062:role/OrganizationEngineerAccessRole

How to set up ~/.aws/credentials
---------------------------------

[default]
aws_access_key_id = <default key id>
aws_secret_access_key = <default access key>

[mfa]




Step 2:
-------

export AWS_PROFILE=dev
export AWS_SDK_LOAD_CONFIG=1


Step 3:
-------

./start_aws_profile.sh mfa michalugbechie <mfa number from fob>

Your ~/.aws/credentials file will be automatically updated with assumed role key id and access key

```




```
#########################
#  Structure
#
############################################

git clone  https://github.com/michaelJava69/module-asg-lb-website.git
 


Folder		Description
------		-----------
Global :        sets up the intial bucket to store Remote state
stage  :        developement environment
prod   :        prod like environment
modules :       modules 


.
├── global
│   └── s3
│       ├── main.tf
│       ├── outputs.tf
│       ├── terraform.tfstate
│       ├── terraform.tfvars
│       └── variables.tf
├── modules
│   ├── compute
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── iam
│   ├── lb
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   └── network
│       ├── main.tf
│       ├── output.tf
│       └── variables.tf
├── prod
│   └── services
│       └── webcluster
│           ├── graph.svg
│           ├── main.tf
│           ├── outputs.tf
│           ├── provider.tf
│           ├── terraform.tfvars
│           ├── tfplan
│           └── variables.tf
├── README.md
├── stage
│   └── services
│       └── webcluster
│           ├── graph1.svg
│           ├── graph.svg
│           ├── main.tf
│           ├── notes.txt
│           ├── outputs.tf
│           ├── provider.tf
│           ├── terraform.tfvars
│           ├── tfplan
│           └── variables.tf
└── start_aws_profile.txt


#####
#
#  Modules
#################


module "compute"  {

    -------------------
    required parameters
    -------------------------------------------

    parameter
    ---------
    vpc-id
    image
    vpc-zone-identifier
    target-group-arns

    -------------------
    Optional parameters
    These parameters have reasonable defaults.
    -------------------------------------------

    parameter           type            default
    ---------           ----            -------
    user-data           string          null
    cluster-name"       string          cluster
    enable_autoscaling  bool            false          # changing scaling at different time of day
    min-size                            2
    max-size                            2
    type                string          t2.micro
}



module  "lb"  {

    -------------------
    required parameters
    -------------------------------------------

    parameter
    ---------
    vpc-id
    sub

    -------
    output
    -------
   
    output              awsinstance.label.item          description
    ------              ----------------------          -----------
    alb_dns_name        aws_lb.nlb.dns_name             The domain name of the loadbalancer
    target_group_arn    aws_lb_target_group.pool.arn    lb target pool arn
}



module  "network"  {

    -------------------
    required parameters
    -------------------

    parameter           type
    ---------           ----
    vpc
    sub
    az                 list

    -------
    output
    -------

    output              awsinstance.label.item          description
    ------              ----------------------          -----------
    vpc-id		aws_vpc.tfvpc.id                non default vpc_id
    aws_subnet-web1-id  aws_subnet.web1.id              ist subnet id 
    aws_subnet-web2-id  aws_subnet.web2.id		2nd subnet id
}

