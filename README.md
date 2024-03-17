## H2 This is a very simple setup based on the following assumptions:

 - an application is hosted in AWS
 - an application can be accessed from 3 different locations
 - an application can write data to the database and send them over the internet to the client

<img width="715" alt="image" src="https://github.com/acibis/comeon_task/assets/13216011/4dc52ba6-0bd6-4148-89d3-666b37e6e0a5">

This implementation assumes that:
 - the database is hosted in the same VPC and is a MySQL database
 - the app is hosted by an EC2
 - the app is accessible with a public IP

### H3 Comments:

- the `local.clients` variable contains a list of IP addresses created by using `toset`, `flatten` and `for` functions:

<img width="228" alt="image" src="https://github.com/acibis/comeon_task/assets/13216011/0a45b314-9aa5-4d43-b97f-e42b652197d7">

- tags would be a list containing the following info:
```
        + tags_all         = {
          + "Name"        = "resource_name"
          + "environment" = "sandbox"
          + "provenance"  = "terraform"
        }
```



### H3 What can/should be done better in case there is more time:

 - make terraform state remote
 - place the EC2 in the private network, remove public IP address adding NAT gateway and load balancer to route the traffic
 - create ssh key for the instance using terraform
 - consider using fargate instead of EC2
 - consider using the autoscaling group
