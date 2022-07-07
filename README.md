# terraform-demo-project
This repository contains a terrform configuration files(s) for the demo mini-project.
The following components are created 

-[ Amazon VPC](https://aws.amazon.com/vpc " Amazon VPC") - Virtual Private Network on AWS

- [Subnet](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html "Subnet") - Subnetwork, logical subdivision of IP network

-[Route Table](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html "Route Table") - Configuring Network Traffic

-[Internet Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html "Internet Gateway") - a VPC component

-[Security Group](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html "Security Group") - Virtual Firewall

-[ Amazon EC2](https://aws.amazon.com/ec2 " Amazon EC2") - Virtual Server

**Note** : During the create of a VPC,  some components are created by default, such as, route-table,  NACL, security group, etc.
Therefore, in this TF file, default components are used instead of creating new resouces, however,  file also contains the TF code (see commented code-sections) to create these resources from scratch.
