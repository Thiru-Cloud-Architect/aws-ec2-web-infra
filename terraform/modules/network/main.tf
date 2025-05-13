resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "${var.vpc_name}-vpc"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.vpc_name}-igw"
    }
}

resource "aws_subnet" "public" {
    vpc_id                      = aws_vpc.main.id
    cidr_block                  = var.public_subnet_cidr 
    map_public_ip_on_launch     = true
    availability_zone           = "${var.region}a"
    tags = {
        Name = "${var.vpc_name}-public-subnet"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "${var.vpc_name}-public-route-table"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "linux_sg" {
    name        = "${var.vpc_name}-linux-sg"
    description = "Allow HTTP, HTTPS inbound traffic for public instance"
    vpc_id      = aws_vpc.main.id

    ingress {
        description      = "HTTPS from Anywhere"
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress {
        description      = "SSH from Anywhere"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.vpc_name}-linux-sg"
    }
}

resource "aws_security_group" "windows_sg" {
    name        = "${var.vpc_name}-windows-sg"
    description = "Allow RDP inbound traffic for public instance"
    vpc_id      = aws_vpc.main.id

    ingress {
        description      = "RDP from Anywhere"
        from_port        = 3389
        to_port          = 3389
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.vpc_name}-windows-sg"
    }
}

