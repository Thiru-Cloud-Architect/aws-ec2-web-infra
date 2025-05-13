# EC2 + NGINX + HTTPS with Terraform, Packer, and Ansible

This project provisions a simple cloud infrastructure on AWS with:
- **2 Linux EC2 instances** running NGINX with HTTPS using self-signed certificates
- **1 Windows EC2 instance** (ready for RDP or further provisioning)
- Custom **VPC**, **subnet**, **IAM roles**, **security groups**, and **internet access**
- Built using **Terraform (infra)**, **Packer (custom AMIs)**, and **Ansible (NGINX provisioning)**

---

## Project Structure

```
ec2-nginx-https/
├── ansible/
│   └── playbook.yml             # Installs and configures NGINX with SSL
├── packer/
│   ├── linux.json               # Builds a Linux AMI using Ansible
│   └── windows.json             # Builds a basic Windows AMI
├── terraform/
│   ├── main.tf                  # Deploys EC2 instances using AMIs
│   ├── variables.tf
│   ├── outputs.tf
│   └── modules/
│       └── network/
│           ├── main.tf         # VPC, Subnet, IGW, SGs, IAM roles
│           ├── variables.tf
│           └── outputs.tf
```

---

## Requirements

- AWS CLI configured (`aws configure`)
- Terraform v1.3+
- Packer v1.8+
- Ansible v2.14+
- SSH Key Pair for EC2 access (if not using SSM)

---

## 1. Build AMIs with Packer

### Linux AMI with NGINX & SSL

```bash
cd packer
packer init linux.json
packer build linux.json
```

### Windows AMI (basic setup, extend with PowerShell if needed)

```bash
packer build windows.json
```

> Note the output AMI IDs and use them in Terraform as inputs.

---

## 2. Provision Infrastructure with Terraform

### Set variables and deploy

```bash
cd terraform
terraform init

terraform apply \
  -var="linux_ami=ami-xxxxxxxxxx" \
  -var="windows_ami=ami-yyyyyyyyy" \
  -var="key_name=my-key-pair"
```

---

## 3. Access

### Linux (NGINX)

- Access the NGINX web server via:
  ```
  https://<linux1_public_ip>
  https://<linux2_public_ip>
  ```
- Browser will warn about the **self-signed SSL cert** — proceed anyway.

### Windows

- RDP access via:
  ```
  mstsc -> <windows_public_ip>
  ```

- Use your key pair or credentials retrieved from EC2 console (if encrypted password method is used).

---

## 4. Components Explained

### Terraform

- Deploys EC2, custom VPC, subnet, route tables, internet gateway
- Security Groups:
  - **Linux**: Port 443 (HTTPS)
  - **Windows**: Port 3389 (RDP)
- IAM roles allow access via SSM if extended

### Packer

- Builds custom AMIs:
  - Linux: baked with NGINX + self-signed HTTPS
  - Windows: extendable with Chocolatey or PowerShell scripts

### Ansible

- Linux role:
  - Installs NGINX
  - Creates `/etc/nginx/ssl/nginx.crt` and `nginx.key` with `openssl`
  - Configures NGINX to serve via HTTPS

---

## 5. Optional Enhancements

- Use **SSM Session Manager** instead of key pair login
- Add **Auto Scaling Groups and Load Balancer**
- Extend Windows AMI with IIS or NGINX using PowerShell/WinRM
- Add **NACLs** if stateless traffic filtering is needed

---

## Clean-Up

To destroy all resources:

```bash
cd terraform
terraform destroy
```



