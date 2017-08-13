
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aurora_password |  | string | - | yes |
| aurora_username |  | string | `root` | no |
| backup_retention_period |  | string | `30` | no |
| db_security_group |  | string | - | yes |
| db_subnet_group_name |  | string | - | yes |
| dbname |  | string | `` | no |
| identifier_prefix | Stat all instances with this | string | - | yes |
| instance_class |  | string | `db.t2.small` | no |
| multi_az |  | string | `true` | no |
| num_azs | How many AZs should this be in | string | `2` | no |
| num_instances |  | string | `1` | no |
| port |  | string | `3306` | no |
| username |  | string | `root` | no |

## Outputs

| Name | Description |
|------|-------------|
| database_address |  |
| rds_identifier |  |

