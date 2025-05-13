variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_id" {
  type = string
  default = "vpc-076e5ea4f529de872"
}

variable "subnet_id" {
  type = string
  default = "subnet-075182c5d93cb8372"
}

source "amazon-ebs" "windows" {
  region                      = var.region
  vpc_id                      = var.vpc_id
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  instance_type               = "t3.medium"
  communicator                = "winrm"
  winrm_username              = "Administrator"
  winrm_use_ssl               = false
  winrm_insecure              = true
  winrm_port                  = 5985
  ami_name                    = "Windows2019-nginx-{{timestamp}}"
  pause_before_connecting     = "2m"
  user_data                   = <<EOF
    <powershell>
    winrm quickconfig -q
    winrm set winrm/config/service @{AllowUnencrypted="true"}
    winrm set winrm/config/service/auth @{Basic="true"}
    Set-Item WSMan:\localhost\Service\AllowUnencrypted -Value $true
    Enable-PSRemoting -Force

    #Allow Winrm through windows firewall and RDP
    New-NetFirewallRule -DisplayName "Allow WinRM" -Direction Inbound -Protocol TCP -LocalPort 5985 -Action Allow 
    New-NetFirewallRule -DisplayName "Allow RDP" -Direction Inbound -Protocol TCP -LocalPort 3389 -Action Allow 
    
    </powershell> 
    EOF


  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "Windows_Server-2019-English-Full-Base-*"
      root-device-type    = "ebs"
    }
    owners      = ["801119661308"]
    most_recent = true
  }

  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = 30
    volume_type           = "gp2"
    delete_on_termination = true
  }
}

build {
  name    = "windows-nginx"
  sources = ["source.amazon-ebs.windows"]

  provisioner "powershell" {
    inline = ["Write-Host 'WinRM connected and Running!'"]
  }
  provisioner "powershell" {
    scripts = [
      "windows-helper-scripts/install-choco.ps1",
      "windows-helper-scripts/install-nginx.ps1",
      "windows-helper-scripts/create-ssl.ps1"
    ]
  }
}