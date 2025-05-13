#Generate self-signed SSL certificate
$cert           = New-SelfSignedCertificate -DnsName "localhost" -CertStoreLocation "cert:\LocalMachine\My"
$certHash       = $cert.Thumbprint

# Export to PEM for NGINX
$certPath       = "C:\tools\nginx\ssl\"
New-Item -ItemType Directory -Force -Path $certPath

$pwd            = ConvertTo-SecureString -String "nginxpass" -Force -AsPlainText
Export-PfxCertificate -Cert "cert:\LocalMachine\My\$certHash" -FilePath "$certPath\nginx.pfx" -Password $pwd

# Convert PFX to PEM using certutil
$certutil -p nginxpass -exportPFX "$certPath\nginx.pfx" "$certPath\nginx.pem"