

output "vpc-id" {
   value = aws_vpc.tfvpc.id 
}

output "aws_subnet-web1-id"  {

   value = aws_subnet.web1.id
}

output "aws_subnet-web2-id"  {

   value = aws_subnet.web2.id
}


