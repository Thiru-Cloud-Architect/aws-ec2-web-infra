variable "region" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type = string
  default = "vpc-076e5ea4f529de872"
}

variable "subnet_id" {
  type = string
  default = "subnet-075182c5d93cb8372"
}

source "amazon-ebs" "linux" {
  region                      = var.region
  vpc_id                      = var.vpc_id
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  ssh_username                = "ubuntu"
  ami_name                    = "nginx-linux-ami-{{timestamp}}"

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
}

build {
  name    = "nginx-linux"
  sources = ["source.amazon-ebs.linux"]

  provisioner "shell" {
    inline = [
      "sleep 30",
      "sudo apt-get update"
    ]
  }

  provisioner "ansible" {
    playbook_file = "../ansible/playbook.yml"
  }
}