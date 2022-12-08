variable "name" {
  type = string
}

variable "subnet_id" {
  type        = string
  description = "Subnet id for the ec2 instance"
}

variable "ec2_instance_type" {
  type        = string
  description = "Ec2 instance type for the DSF base instance"
}

variable "ebs_details" {
  type = object({
    disk_size        = number
    provisioned_iops = number
    throughput       = number
  })
  description = "Compute instance volume attributes"
}

variable "public_ip" {
  type        = bool
  description = "Create public IP for the instance"
}

variable "key_pair" {
  type        = string
  description = "key pair for DSF base instance. This key must be generated by by the hub module and present on the local disk."
}

variable "web_console_cidr" {
  type        = list(any)
  description = "List of allowed ingress cidr patterns for the DSF instance for web console"
  default     = []
}

variable "sg_ingress_cidr" {
  type        = list(any)
  description = "List of allowed ingress cidr patterns for the DSF instance for ssh and internal protocols"
}

variable "iam_instance_profile_id" {
  type        = string
  default     = null
  description = "DSF base ec2 IAM instance profile id"
}

variable "ami_name_tag" {
  type = string
}

variable "resource_type" {
  type = string
  validation {
    condition     = contains(["hub", "gw"], var.resource_type)
    error_message = "Allowed values for dsf type \"hub\" or \"gw\"."
  }
  nullable = false
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Admin password"
  validation {
    condition     = length(var.admin_password) > 8
    error_message = "Admin password must be at least 8 characters"
  }
  nullable = false
}

variable "ssh_key_path" {
  type        = string
  description = "SSH key path"
  nullable    = false
}

variable "additional_install_parameters" {
  default = ""
}

variable "installation_location" {
  type = object({
    s3_bucket = string
    s3_key    = string
  })
  description = "S3 DSF installation location"
  nullable    = false
}

variable "proxy_address" {
  type        = string
  description = "Proxy address used for ssh"
  default     = null
}

variable "proxy_private_key" {
  type        = string
  description = "Proxy private ssh key"
  default     = null
}

variable "sonarw_public_key" {
  type        = string
  description = "SSH public key for sonarw user"
  nullable    = false
}

variable "sonarw_secret_name" {
  type        = string
  description = "Secret name for sonarw ssh key"
  default     = ""
}

variable "sonarw_secret_region" {
  type        = string
  description = "Region for sonarw ssh key"
  default     = null
}
