# This script is used to set the profile picture for the current user (Administrator) in Windows.
# It copies a specified image file to the appropriate directory and converts it to the necessary formats.
# Ensure the script is run with administrative privileges
# and that the image file exists at the specified path.

# Path to the new profile picture
$PicturePath = "C:\Users\Administrator\Pictures\Shield.bmp"

# Destination path for the account picture
$AccountPicturesPath = "C:\ProgramData\Microsoft\User Account Pictures"
$TargetFiles = @(
    "Administrator.bmp",
    "Administrator.png",
    "Administrator.dat"
)

# Copy the new picture to the account pictures directory (as .png)
# Convert to .png if necessary
$pngPath = "$AccountPicturesPath\Administrator.png"
if (!(Test-Path $AccountPicturesPath)) {
    New-Item -Path $AccountPicturesPath -ItemType Directory -Force
}

# Convert to PNG if not already
if ($PicturePath -notlike "*.png") {
    Add-Type -AssemblyName System.Drawing
    $img = [System.Drawing.Image]::FromFile($PicturePath)
    $img.Save($pngPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $img.Dispose()
} else {
    Copy-Item $PicturePath $pngPath -Force
}

# Optionally, copy as .bmp and .dat for legacy support
Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile($pngPath)
$img.Save("$AccountPicturesPath\Administrator.bmp", [System.Drawing.Imaging.ImageFormat]::Bmp)
$img.Dispose()
Copy-Item $pngPath "$AccountPicturesPath\Administrator.dat" -Force

# Write-Host "Profile picture for 'Administrator' has been updated. You may need to sign out and sign in to see changes."