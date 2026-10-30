$ip='87.250.60.120'
Get-NetFirewallRule -DisplayName 'Dell-PG-6023' -ErrorAction SilentlyContinue | Remove-NetFirewallRule
New-NetFirewallRule -DisplayName 'Dell-PG-6023' -Direction Inbound -Protocol TCP -LocalPort 6023 -RemoteAddress $ip -Action Allow | Out-Null
Get-NetTCPConnection -LocalPort 6023 -State Listen -ErrorAction SilentlyContinue | % { "LISTEN " + $_.LocalAddress + ":" + $_.LocalPort }
Get-NetFirewallRule -DisplayName 'Dell-PG-6023' | Get-NetFirewallAddressFilter | % { "rule remote=" + $_.RemoteAddress }
Get-NetFirewallProfile | % { $_.Name + ' enabled=' + $_.Enabled }
Write-Host "DONE"
