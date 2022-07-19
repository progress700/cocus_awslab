# Introduction
This lab creates an infrastructure in AWS cloud. The infrastructure presented in this lab contains a VPC, a public subnet and a private subnet.Two ec2 instances were deployed, one to public subnet and the other to a private subnet, the ec2 instance deployed to the public subnet serves as the web server and the ec2 instance deployed to the private subnet serves as the database server.Both server can communicate with each other.
The lab was build using terraform as infrastructure as a code.
This repository contains all the codes used in the lab.

# Deploy notes:
Terraform deployment into aws. You can deploy this lab using the main.tf file in this repository.
The keypair is created using terraform.
