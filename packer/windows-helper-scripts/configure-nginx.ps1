#Append HTTPS server block to nginx.conf
$confPath       = "C:\tools\nginx\conf\nginx.conf"    

#Wait a few sec to make sure install completed - Adding this due to previous errors
Start-Sleep -Seconds 10

if (!(Test-Path $confPath)) {
    Write-Error "NGINX config not found at $confPath. Check nginx installation "
    exit 1
}

$sslCertPath    = "C:/tools/nginx/ssl/nginx.pem"
# Backup the original config file - Adding this due to the previous errors 
Copy-Item $confPath "$confPath.bak" -Force

#Replace with basic HTTPS config
$httpsBlock     = @"
server {
    listen 443 ssl;
    server_name localhost;

    ssl_certificate     $sslCertPath;
    ssl_certificate_key $sslCertPath;

    location / {
        root   html;
        index  index.html index.htm;
    }
}
"@  

Set-Content -Path $confPath -Value $httpsBlock -Force

#Start NGINX
Start-Process -FilePath "C:\tools\nginx\nginx.exe" 