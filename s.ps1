$ErrorActionPreference='Stop'
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 | Out-Null
Set-Service sshd -StartupType Automatic
Start-Service sshd
Get-NetFirewallRule -Name '*OpenSSH*' -ErrorAction SilentlyContinue | Disable-NetFirewallRule
Get-NetFirewallRule -DisplayName 'SSH from owner IP only' -ErrorAction SilentlyContinue | Remove-NetFirewallRule
New-NetFirewallRule -DisplayName 'SSH from owner IP only' -Direction Inbound -Protocol TCP -LocalPort 22 -Action Allow -RemoteAddress 87.250.60.120 | Out-Null
New-ItemProperty -Path HKLM:\SOFTWARE\OpenSSH -Name DefaultShell -Value 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' -PropertyType String -Force | Out-Null
Restart-Service sshd
Get-Service sshd | % { 'sshd ' + $_.Status }
Write-Host DONE4
