# Access nginix from private ec2 instance via load balancer and created from auto scaling group
create VPC,

create 2 subnets, 

one for public network, 

one for private network,

create internet gw and connect to public network,

create nat gateway, and connect to private network,
create Auto scaling group for app, ec2 only private subnet,

create a LB (check Application Load Balancer or Network Load Balancer),

publish a service over LB, ie nginx.
