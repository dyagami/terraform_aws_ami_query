# declare OS name with at least 2 words

variable "os" {
  type        = string
  description = "Enter 1 or more keywords for AMI image name search"
  validation {
    condition     = length(regexall("\\w", var.os)) > 0
    error_message = "Enter at least one keyword for search"
  }
}

# declare desired architecture of the image

variable "architecture" {
  type        = string
  description = "Provide a valid OS architecture that should be queried ( i386 | x86_64 | arm64 | x86_64_mac )"
  validation {
    condition     = contains(["i386", "x86_64", "arm64", "x86_64_mac"], var.architecture)
    error_message = "ERROR: Wrong architecture provided. Provide one of the following architectures: ( i386 | x86_64 | arm64 | x86_64_mac )"
  }

}

# parse OS name to a list and join elements to variable containing case-insensitive regex string

locals {
  os_split              = split(" ", var.os)
  ami_name_regex_string = format(".*(?i)%s.*", join(".*", local.os_split))
}

# fetch all ami ids for the region specified through regex keywords provided by user input

data "aws_ami_ids" "ami_list" {
  owners     = ["amazon"]
  region     = var.aws_region
  name_regex = local.ami_name_regex_string
  filter {
    name   = "architecture"
    values = ["${var.architecture}"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "is-public"
    values = [true]
  }
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

# parse the ami ids to export their corresponding names

data "aws_ami" "parse_amis" {
  for_each = toset(data.aws_ami_ids.ami_list.ids)
  filter {
    name   = "image-id"
    values = ["${each.key}"]
  }
}

# output map of ami names to ami ids

output "aws_ami_map" {
  value = tomap({ for key, value in data.aws_ami.parse_amis : value.image_id => value.name })
}
