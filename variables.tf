variable "access_key" {}

variable "secret_key" {}

variable "region" {}

variable "configuration" {
  description = "The total configuration, List of Objects/Dictionary"
  type =   list(object({
    application_name = string
    ami = string
    no_of_instances = string
    instance_type = string
    subnet_id = string
    vpc_security_group_ids = list(string)
  }))
  default     = [{ "application_name" : "appdev1", "ami" : "ami-088c153f74339f34c", "no_of_instances" : "2", "instance_type" : "t2.micro", "subnet_id" : "subnet-dfd9c299", "vpc_security_group_ids" : ["sg-0027e5711e491f61a"] }, { "application_name" : "appdev2", "ami" : "ami-088c153f74339f34c", "no_of_instances" : "2", "instance_type" : "t2.micro", "subnet_id" : "subnet-dfd9c299", "vpc_security_group_ids" : ["sg-0027e5711e491f61a"] }]
}
