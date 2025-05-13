# Download and extract NGINX manually 
$nginxUrl = "https://nginx.org/download/nginx-1.24.0.zip"
$nginxZip = "$env:TEMP\nginx-1.24.0.zip"
$nginxPath = "C:\tools\nginx"

Invoke-WebRequest -Uri $nginxUrl -OutFile $nginxZip
Expland-Archive -Path $nginxZip -DestinationPath $nginxPath -Force
Rename-Item -Path "$nginxPath\nginx-1.24.0" -NewName "nginx"

# Verify the installation
if (!(Test-Path "$nginxPath\nginx\nginx.exe")) {
    Write-Error "NGINX installation failed."
    exit 1
}