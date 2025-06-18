# Set variables
$pictureName = "Shield.png"
$sourcePicturePath = "C:\Users\Administrator\Pictures\$pictureName"
$CurrentUser = $env:USERNAME
$picturePath = "C:\Users\$CurrentUser\Pictures\$pictureName"
$accountPicturesPath = "C:\Users\$CurrentUser\AppData\Roaming\Microsoft\Windows\AccountPictures"
$publicAccountPictures = "C:\ProgramData\Microsoft\User Account Pictures"

# Copy the picture to the current user's Pictures folder
Copy-Item -Path $sourcePicturePath -Destination $picturePath -Force

# Create destination folder if needed
if (-not (Test-Path $accountPicturesPath)) {
    New-Item -ItemType Directory -Path $accountPicturesPath | Out-Null
}

# Copy the picture to the user's account pictures folder
Copy-Item -Path $picturePath -Destination "$accountPicturesPath\$pictureName" -Force

# Optionally update the public account picture (fallback)
Copy-Item -Path $picturePath -Destination "$publicAccountPictures\user.png" -Force

# Get the SID of the user
$sid = (Get-LocalUser -Name $CurrentUser).SID.Value

# Set registry keys for the account picture
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AccountPicture\Users\$sid"
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
$regValue = "$accountPicturesPath\$pictureName"
Set-ItemProperty -Path $regPath -Name "Image32" -Value $regValue
Set-ItemProperty -Path $regPath -Name "Image40" -Value $regValue
Set-ItemProperty -Path $regPath -Name "Image48" -Value $regValue
Set-ItemProperty -Path $regPath -Name "Image64" -Value $regValue
Set-ItemProperty -Path $regPath -Name "Image96" -Value $regValue
Set-ItemProperty -Path $regPath -Name "Image192" -Value $regValue
Set-ItemProperty -Path $regPath -Name "Image200" -Value $regValue
Set-ItemProperty -Path $regPath -Name "Image208" -Value $regValue
Set-ItemProperty -Path $regPath -Name "Image240" -Value $regValue
Set-ItemProperty -Path $regPath -Name "Image424" -Value $regValue
Set-ItemProperty -Path $regPath -Name "Image448" -Value $regValue
Set-ItemProperty -Path $regPath -Name "Image1080" -Value $regValue
