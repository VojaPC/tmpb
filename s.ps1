Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Set-Service sshd -StartupType Automatic
Start-Service sshd
Get-NetFirewallRule -Name '*OpenSSH*' -ErrorAction SilentlyContinue | Disable-NetFirewallRule
New-NetFirewallRule -Name 'ssh-owner-ip' -DisplayName 'SSH from owner IP only' -Direction Inbound -Protocol TCP -LocalPort 22 -Action Allow -RemoteAddress 87.250.60.120 | Out-Null
New-ItemProperty -Path HKLM:\SOFTWARE\OpenSSH -Name DefaultShell -Value 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' -PropertyType String -Force | Out-Null
Restart-Service sshd
Get-Service sshd | Format-Table Name,Status | Out-String | Set-Content C:\ssh-install.log
Get-NetFirewallRule -Name ssh-owner-ip | Get-NetFirewallAddressFilter | Out-String | Add-Content C:\ssh-install.log
