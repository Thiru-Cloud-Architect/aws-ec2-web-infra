#install chocolatey silently
Set-ExecutionPolicy Bypass -Scope Process -Force

#Install Chocolatey
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#Set Chocolatey install directory for NGINX
$env:ChocolateyInstall = "C:\ProgramData\chocolatey"
if (-not (Test-Path "$env:ChocolateyInstall\bin\choco.exe")) {
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}


#Verify Chocolatey is installed - Adding due to installation issues
choco --version
if ($LASTEXITCODE -ne 0) {
    Write-Error "Chocolatey installation failed."
    exit 1
}