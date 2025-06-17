# ....For testing purposes....
# $Core variable should be set to the username of the account you want to modify.
# $Person variable should be set to the full name of the user.

# Examples: 
# $Core = "JulianTesting99"
# $Person = "Julian Testing"
# ....End for testing purposes....


# Begin R's code...
Write-Host "  Creating new $Core login account with appropriate privileges" -ForegroundColor DarkRed
        New-LocalUser -Name $Core -FullName $Person -Password (ConvertTo-SecureString 'PASSWORD' -AsPlainText -Force) -PasswordNeverExpires -UserMayNotChangePassword -Description 'Tenant access account' | Out-Null
        Add-LocalGroupMember -Member $Core -Group 'Administrators'
        Add-LocalGroupMember -Member $Core -Group 'Remote Desktop Users'

        # Instantiate CORE profile
        $Password = ConvertTo-SecureString 'PASSWORD' -AsPlainText -Force
        $TenantCredential = New-Object System.Management.Automation.PSCredential($Core, $Password)
        Start-Process cmd.exe -Credential $TenantCredential -ArgumentList '/c whoami & timeout 1'
# End R's code...

# Start Julian's code...
# Set variables
$pictureName = "inspect.bmp"
$picturePath = "C:\Users\$Core\Pictures\$pictureName"
$accountPicturesPath = "C:\Users\$Core\AppData\Roaming\Microsoft\Windows\AccountPictures"
$publicAccountPictures = "C:\ProgramData\Microsoft\User Account Pictures"

# Create destination folder if needed
if (-not (Test-Path $accountPicturesPath)) {
    New-Item -ItemType Directory -Path $accountPicturesPath | Out-Null
}

# Copy the picture to the user's account pictures folder
Copy-Item -Path $picturePath -Destination "$accountPicturesPath\$pictureName" -Force

# Optionally update the public account picture (fallback)
Copy-Item -Path $picturePath -Destination "$publicAccountPictures\user.bmp" -Force

# Get the SID of the user
$sid = (Get-LocalUser -Name $Core).SID.Value

# Set registry keys for the account picture
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AccountPicture\Users\$sid"
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
Set-ItemProperty -Path $regPath -Name "Image32" -Value "$accountPicturesPath\$pictureName"
Set-ItemProperty -Path $regPath -Name "Image40" -Value "$accountPicturesPath\$pictureName"
Set-ItemProperty -Path $regPath -Name "Image48" -Value "$accountPicturesPath\$pictureName"
Set-ItemProperty -Path $regPath -Name "Image64" -Value "$accountPicturesPath\$pictureName"
Set-ItemProperty -Path $regPath -Name "Image96" -Value "$accountPicturesPath\$pictureName"
Set-ItemProperty -Path $regPath -Name "Image192" -Value "$accountPicturesPath\$pictureName"
Set-ItemProperty -Path $regPath -Name "Image200" -Value "$accountPicturesPath\$pictureName"
Set-ItemProperty -Path $regPath -Name "Image208" -Value "$accountPicturesPath\$pictureName"
Set-ItemProperty -Path $regPath -Name "Image240" -Value "$accountPicturesPath\$pictureName"
Set-ItemProperty -Path $regPath -Name "Image424" -Value "$accountPicturesPath\$pictureName"
Set-ItemProperty -Path $regPath -Name "Image448" -Value "$accountPicturesPath\$pictureName"
Set-ItemProperty -Path $regPath -Name "Image1080" -Value "$accountPicturesPath\$pictureName"

# End Julian's code...