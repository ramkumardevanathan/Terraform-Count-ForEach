provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
}

locals {
  serverconfig = [
    for srv in var.configuration : [
      for i in range(1, srv.no_of_instances + 1) : {
        instance_name   = "${srv.application_name}-${i}"
        instance_type   = srv.instance_type
        subnet_id       = srv.subnet_id
        ami             = srv.ami
        security_groups = srv.vpc_security_group_ids
      }
    ]
  ]
}

// We need to Flatten it before using it
locals {
  instances = flatten(local.serverconfig)
}

resource "aws_instance" "web" {

  for_each = { for server in local.instances : server.instance_name => server }

  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  vpc_security_group_ids = each.value.security_groups
  user_data              = <<EOF
#!/bin/bash
echo "Copying the SSH Key to the remote server"
echo -e "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC51A6eXRWqa3s20Y30/2pvXWbJ6pyv9NvuUiPY1WDASu6TuDaRhv+NZ6T6Kr6iY1huXYeMJj+Tv/uZtDp5zfjZkD7URnNhsQ2srcLpOheVwcjgGqRnFXAY5lnPlXHQuAwLGRFONW7wngO1pHQQSZGMSpcgehdRQvbc0Pw/+xwsLMylKJMGymKle/8+1iWrxIj9C2Ipt/6EVbbLQ6zZ660sfwXEX/V2SYsVWLD3CSsBq46lV7UzL3qZz7MHs/xkNBmKEHJ4ZVvu4sYieqVza9DaJV+9u9S+9NpomcasBhzXZv9RfL45hr6PWgqwL9rfP95utn0BpglrpykQeUxicZD3 cmpdev@centos7" >> /home/ubuntu/.ssh/authorized_keys

echo "Changing the hostname to ${each.value.instance_name}"
hostname ${each.value.instance_name}
echo "${each.value.instance_name}" > /etc/hostname

EOF
  subnet_id              = each.value.subnet_id
  tags = {
    Name = "${each.value.instance_name}"
  }
}

output "instances" {
  value       = aws_instance.web
  description = "All Machine details"
}
