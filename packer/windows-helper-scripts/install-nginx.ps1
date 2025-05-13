#Install NGINX and OpenSSL
choco install nginx -y
Start-Sleep -s 10

New-Service -Name "nginx" -BinaryPathName "C:\tools\nginx\nginx.exe" -DisplayName "NGINX" -StartupType Automatic
Start-Service nginx

# choco install openssl.light -y

# #Create SSL directory
# New-Item -ItemType Directory -Force -Path "C:\tools\nginx\ssl"

# #Validating the installation - Adding due to the existing error - Monitoring installation
# Get-ChildItem -Recurse "C:\tools\nginx | Out-File C:\nginx-debug.txt