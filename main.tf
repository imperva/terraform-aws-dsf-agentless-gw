locals {
  security_groups_config = [ # https://docs.imperva.com/bundle/v4.11-sonar-installation-and-setup-guide/page/78702.htm
    {
      name            = ["other"]
      internet_access = true
      udp             = []
      tcp             = [22]
      cidrs           = concat(var.allowed_ssh_cidrs, var.allowed_all_cidrs)
    },
    {
      name            = ["hub"]
      internet_access = false
      udp             = []
      tcp             = [22, 8443]
      cidrs           = concat(var.allowed_hub_cidrs, var.allowed_all_cidrs)
    },
    {
      name            = ["agentless", "gw", "replica", "set"]
      internet_access = false
      udp             = []
      tcp             = [3030, 27117, 22]
      cidrs           = concat(var.allowed_agentless_gw_cidrs, var.allowed_all_cidrs)
    },
    {
      name            = ["cte", "agents"]
      internet_access = false
      udp             = []
      tcp             = [11570, 10570] # syslog TLS port 11570, TCP is 10570
      cidrs           = concat(var.allowed_cte_agents_cidrs, var.allowed_all_cidrs)
    }
  ]
}

resource "random_string" "gw_id" {
  length  = 8
  special = false
}

module "gw_instance" {
  source                            = "./_modules/aws/sonar-base-instance"
  resource_type                     = "agentless-gw"
  name                              = var.friendly_name
  subnet_id                         = var.subnet_id
  security_groups_config            = local.security_groups_config
  security_group_ids                = var.security_group_ids
  key_pair                          = var.ssh_key_pair.ssh_public_key_name
  ec2_instance_type                 = var.instance_type
  ebs_details                       = var.ebs
  ami                               = var.ami
  instance_profile_name             = var.instance_profile_name
  additional_install_parameters     = var.additional_install_parameters
  password                          = var.password
  password_secret_name              = var.password_secret_name
  ssh_key_path                      = var.ssh_key_pair.ssh_private_key_file_path
  binaries_location                 = var.binaries_location
  tarball_url                       = var.tarball_url
  hub_sonarw_public_key             = var.hub_sonarw_public_key
  hadr_dr_node                      = var.hadr_dr_node
  main_node_sonarw_public_key       = var.main_node_sonarw_public_key
  main_node_sonarw_private_key      = var.main_node_sonarw_private_key
  proxy_info                        = var.ingress_communication_via_proxy
  skip_instance_health_verification = var.skip_instance_health_verification
  terraform_script_path_folder      = var.terraform_script_path_folder
  use_public_ip                     = var.use_public_ip
  attach_persistent_public_ip       = false
  sonarw_private_key_secret_name    = var.sonarw_private_key_secret_name
  sonarw_public_key_content         = var.sonarw_public_key_content
  volume_attachment_device_name     = var.volume_attachment_device_name
  tags                              = var.tags
  base_directory                    = var.base_directory
  cloud_init_timeout                = var.cloud_init_timeout
  send_usage_statistics             = var.send_usage_statistics
}
