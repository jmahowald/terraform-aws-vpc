
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| ca_common_name |  | string | `myorg` | no |
| docker_preinstalled | Set to empty string to hve docker be installed | string | `` | no |
| host_address |  | string | - | yes |
| host_user |  | string | - | yes |
| nopassword | Set this to anything if you want to disable passwords for the ca cert for openvpn | string | `` | no |
| remote_script_dir |  | string | `/var/openvpn` | no |
| script_folder | This module will output scripts.  Where should they go | string | `bin` | no |
| security_group_id |  | string | - | yes |
| ssh_keypath |  | string | - | yes |
| vpn_cidr |  | string | - | yes |
| vpn_image |  | string | `kylemanna/openvpn` | no |

