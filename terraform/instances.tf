data "aws_ami" "linux_custom" {
    most_recent = true
    owners = ["self"]
    filter {
        name = "name"
        values = ["nginx-linux-*"]
    }
}

data "aws_ami" "windows_custom" {
    most_recent = true
    owners = ["self"]
    filter {
        name = "name"
        values = ["Windows2019-nginx-*"]
    }
}

resource "aws_instance" "linux_1" {
    ami                         = data.aws_ami.linux_custom.id
    instance_type               = "t2.micro"
    subnet_id                   = module.network.subnet_id
    vpc_security_group_ids      = [module.network.linux_sg_id]
    associate_public_ip_address = true
    key_name                    = "key-for-ssh-connection"    
    tags = {
        "Name" = "nginx-linux-1"
    }
}

resource "aws_instance" "linux_2" {
    ami                         = data.aws_ami.linux_custom.id
    instance_type               = "t3.micro"
    subnet_id                   = module.network.subnet_id
    vpc_security_group_ids      = [module.network.linux_sg_id]
    associate_public_ip_address = true
    key_name                    = "key-for-ssh-connection"   
    tags = {
        "Name" = "nginx-linux-2"
    }
}

resource "aws_instance" "windows" {
    ami                         = data.aws_ami.windows_custom.id
    instance_type               = "t3.micro"
    subnet_id                   = module.network.subnet_id
    vpc_security_group_ids      = [module.network.windows_sg_id]
    associate_public_ip_address = true
    key_name                    = "key-for-RDP-connection"
    tags = {
        "Name" = "windows-nginx"
    }
}