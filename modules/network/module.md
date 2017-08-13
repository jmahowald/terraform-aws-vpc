
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| ami |  | string | - | yes |
| availability_zone_count |  | string | `1` | no |
| aws_region |  | string | - | yes |
| bastion_server_count |  | string | `1` | no |
| delete_jump_host_volume_on_termination |  | string | `true` | no |
| environment |  | string | - | yes |
| image_user |  | string | - | yes |
| instance_type |  | string | `t2.micro` | no |
| key_name |  | string | - | yes |
| owner |  | string | - | yes |
| private_subnet_cidrs |  | list | - | yes |
| public_subnet_cidrs |  | list | - | yes |
| ssh_keypath |  | string | - | yes |
| vpc_cidr | /** Network information **/ | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| all_sg_ids |  |
| availabity_zones |  |
| bastion_ips |  |
| bastion_user |  |
| private_route_table_ids |  |
| private_sg_id | NOTE.  I swear when I tested, if I used the name of private_security_group_id I got the value for the public instance |
| private_subnet_ids |  |
| public_sg_id |  |
| public_subnet_ids |  |
| vpc_cidr |  |
| vpc_id |  |

