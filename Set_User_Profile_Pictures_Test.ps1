# ....For testing purposes....
# $Core variable should be set to the username of the account you want to modify.
# $Person variable should be set to the full name of the user.

# Examples: 
# $Core = "JulianTesting99"
# $Person = "Julian Testing"
# ....End for testing purposes....

# This script is designed for testing purposes to create a new local user account with specific privileges and set a profile picture for that account.

$Core = "JulianTesting99"
$Person = "Julian Testing"

Write-Host "  Creating new $Core login account with appropriate privileges" -ForegroundColor DarkRed
        New-LocalUser -Name $Core -FullName $Person -Password (ConvertTo-SecureString 'PASSWORD' -AsPlainText -Force) -PasswordNeverExpires -UserMayNotChangePassword -Description 'Tenant access account' | Out-Null
        Add-LocalGroupMember -Member $Core -Group 'Administrators'
        Add-LocalGroupMember -Member $Core -Group 'Remote Desktop Users'

        # Instantiate CORE profile
        $Password = ConvertTo-SecureString 'PASSWORD' -AsPlainText -Force
        $TenantCredential = New-Object System.Management.Automation.PSCredential($Core, $Password)
        Start-Process cmd.exe -Credential $TenantCredential -ArgumentList '/c whoami & timeout 1'
        
# Copy Shield.bmp from the current user's Pictures folder to $Core's Pictures folder
$sourceShield = "$env:USERPROFILE\Pictures\Shield.png"
$destShield = "C:\Users\$Core\Pictures\Shield.png"
Copy-Item -Path $sourceShield -Destination $destShield -Force


# Set variables
$pictureName = "Shield.png"
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

Write-Host "Sign-in picture set. Please log off or restart for changes to take effect." -ForegroundColor Green
