# Stage
# =====


prefix     = "stage"
stage-az   = ["us-east-2a", "us-east-2b", "us-east-2c" ]
stage-type = "t2.micro"
stage-user = "John"

# cidrsubnet() function used to determine subnet range
vpc-stage   = "172.40.0.0/16"


# variable "stage-sub"  {
#default = ["172.40.10.0/24" ,"172.40.20.0/24"]
#}


