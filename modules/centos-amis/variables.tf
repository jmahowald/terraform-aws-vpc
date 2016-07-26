

 
variable "centos_amis" {
  description = "Base AMI for centos"
  default = {
      "6-aws-us-west-1" = "ami-ac5f2fcc" 
      "6-aws-us-east-1" = "ami-1c221e76"
      # Retrieved from https://aws.amazon.com/marketplace/ordering/ref=dtl_psb_continue?ie=UTF8&productId=b7ee8a69-ee97-4a49-9e68-afaee216db2e&region=us-east-1
      "7-aws-us-west-1" = "ami-af4333cf" 
      "7-aws-us-east-1" = "ami-6d1c2007"
      "7-aws-ap-southeast-2" = "ami-fedafc9d"
      "7-aws-eu-central-1" = "ami-9bf712f4"
    }
}


 
variable "centos_users" {
  description = "Base AMI for centos"
  default = {
  	"6" = "centos"
  	"7" = "centos"
    }
}


