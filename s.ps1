$d='C:\Program Files\PostgreSQL\17\data'
Write-Host "--- conf"
Select-String -Path "$d\postgresql.conf" -Pattern '^\s*(port|listen_addresses)\s*=' | % { $_.Line.Trim() }
Write-Host "--- pg listen"
Get-NetTCPConnection -State Listen | ? { (Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).ProcessName -like 'postgres*' } | % { "PG LISTEN " + $_.LocalAddress + ":" + $_.LocalPort }
Write-Host "--- hba"
Select-String -Path "$d\pg_hba.conf" -Pattern '^\s*host' | % { $_.Line.Trim() }
Write-Host "--- fw rules for 6023/5432"
Get-NetFirewallRule -Direction Inbound -Action Allow | ? { $_.Enabled -eq 'True' -and (($_ | Get-NetFirewallPortFilter).LocalPort -match '6023|5432') } | % { $_.DisplayName + ' remote=' + (($_ | Get-NetFirewallAddressFilter).RemoteAddress -join ',') }
Write-Host "DONE2"
