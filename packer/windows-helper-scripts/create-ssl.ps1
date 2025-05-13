$sslPath    = "C:\tools\nginx\ssl"
New-Item -ItemType Directory -Force -Path $sslPath -Force

$cert       = New-SelfSignedCertificate -DnsName "localhost" -CertStoreLocation "cert:\LocalMachine\My"
$pwd        = ConvertTo-SecureString -String "MyPassword" -Force -AsPlainText
Export-PfxCertificate -Cert $cert -FilePath "$sslPath\nginx.pfx" -Password $pwd
Export-Certificate -Cert $cert -FilePath "$sslPath\nginx.crt"

# Convert to PEM format 
$certContent = Get-Content "$sslPath\nginx.crt" 
Set-Content "$sslPath\nginx.pem" $certContent

# Append SSL config to nginx.conf
$configPath = "C:\tools\nginx\conf\nginx.conf"
(gc $configPath) -replace "listen\s+80:", "listen 443 ssl;" | Set-Content $configPath

Add-Content $configPath "`nssl_certificate $sslPath\nginx.pem;"
Add-Content $configPath "ssl_certificate_key $sslPath\nginx.pfx;"