$ErrorActionPreference='Stop'
$allow='45.80.135.63','45.80.135.163','87.250.60.120'
$h='C:\Program Files\PostgreSQL\17\data\pg_hba.conf'
Copy-Item $h ($h + '.bak-20261030') -Force
netsh advfirewall export 'C:\fw-backup-20261030.wfw' | Out-Null
$l=Get-Content $h
$new=@(); $n=0
foreach($x in $l){ if($x -match '^\s*host\s+all\s+all\s+0\.0\.0\.0/0\s+md5'){ $n++; foreach($a in $allow){ $new += ('host    all             all             ' + $a + '/32            md5') } } else { $new += $x } }
Set-Content $h $new -Encoding ASCII
Write-Host ("hba lines replaced: " + $n)
foreach($name in 'PostgreSQL','postgres unlimited db conn'){ Get-NetFirewallRule -DisplayName $name -ErrorAction SilentlyContinue | % { Set-NetFirewallRule -Name $_.Name -RemoteAddress $allow; Write-Host ("fw " + $_.DisplayName + " " + $_.Direction + " -> " + ((Get-NetFirewallAddressFilter -AssociatedNetFirewallRule $_).RemoteAddress -join ',')) } }
Get-Content $h | Select-String '^\s*host' | % { $_.Line.Trim() }
Write-Host "DONE3"
