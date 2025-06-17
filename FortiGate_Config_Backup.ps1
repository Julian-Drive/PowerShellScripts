# Requires: Posh-SSH module
# Install-Module -Name Posh-SSH -Force

function Is-ValidIP($ip) {
    return $ip -match '^\d{1,3}(\.\d{1,3}){3}$'
}

while ($true) {
    $hostname = Read-Host "Fortigate IP address"
    if (Is-ValidIP $hostname) { break }
    Write-Host "Please enter a valid IP address."
}

$fortiName = Read-Host "Fortigate Name"
$username = Read-Host "Username"
$password = Read-Host "Password" -AsSecureString
$cred = New-Object System.Management.Automation.PSCredential ($username, $password)

# Format: yyyyMMdd_FortiName.conf
$date = Get-Date -Format "yyyyMMdd"
$fileName = "${date}_${fortiName}.conf"

try {
    $session = New-SSHSession -ComputerName $hostname -Credential $cred -AcceptKey
    $output = Invoke-SSHCommand -SessionId $session.SessionId -Command 'show full-configuration'
    $output.Output | Out-File -FilePath $fileName -Encoding utf8
    Write-Host "Backup saved to $fileName"
    Remove-SSHSession -SessionId $session.SessionId
} catch {
    Write-Host "Error: $_"
}
