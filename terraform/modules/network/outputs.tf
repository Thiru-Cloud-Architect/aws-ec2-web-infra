output "vpc_id" {
    value = aws_vpc.main.id
}

output "subnet_id" {
    value = aws_subnet.public.id
}

output "linux_sg_id" {
    value = aws_security_group.linux_sg.id
}

output "windows_sg_id" {
    value = aws_security_group.windows_sg.id 
}