# Copyright (C) 2019 David Duque (aka davness)

# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the Software
# is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#############################################################
# Version 1.0.0
# Prepares skybox images that were generated with Spacescape
# to be uploaded to Roblox;

# Bottom is rotated right, Up is rotated left!
# ASSUMES THEY'RE EXPORTED AS UNITY SKYBOXES
#############################################################

param($name)
$ErrorActionPreference = "Stop"
$Path = $PWD.Path

# The script only works with Windows PowerShell (not Powershell Core).
Try{
    [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    Write-Host "[SUCCESS]:" -nonewline -foregroundcolor Green; Write-Host " Supported PowerShell Edition/Version"
} Catch {
    Write-Host "Make sure you're running this script with Windows PowerShell (the one bundled with Windows) and not a cross-platform version."
    Write-Host "Supported Windows PowerShell versions: v1.0/2.0 and above (Windows 7)"
    Write-Host ""
    Write-Host "[ABORTING]:" -nonewline -foregroundcolor Red; Write-Host " Unsupported PowerShell Edition."
    Read-Host -Prompt "Press Enter to exit"
    exit
}

if ($null -eq $name) {
    Write-Host "[WARNING]:" -nonewline -foregroundcolor Yellow; Write-Host " No file name provided."
    Write-Host "";
    $name = Read-Host -Prompt "Please input the skybox name to be converted"
}

$unity = @("back", "down", "front", "left", "right", "up")
$roblox = @("BK", "DN", "FT", "LF", "RT", "UP")

# Check all files
foreach ($side in $unity) {
    $file = $name + "_$side.png"

    Write-Host "[CHECK]" -nonewline -foregroundcolor yellow; Write-Host " Checking for " -nonewline
    Write-Host "$file" -nonewline -foregroundcolor blue; Write-Host "... " -nonewline

    if(Test-Path -path $($Path + '\' + "$file")){
        Write-Host "Check." -foregroundcolor green
    } else {
        Write-Host "Failure!" -foregroundcolor red

        Write-Output "Please make sure that:", " * The files are in the same folder as the script;", " * The images were exported for the UNITY engine;", " * You typed the name correctly;", " * The skybox hasn't been converted already.",""
        Write-Host "[ABORTING]" -nonewline -foregroundcolor red; Write-Host " File set not found or incomplete."
        Read-Host -Prompt "Press Enter to exit"
        exit
    }
}

Write-Host ""
Write-Host "[PREPARING]" -nonewline -foregroundcolor green; Write-Host " All files existant."
Write-Host ""

for ($i = 0; $i -lt 6; $i++) {
    $uty = $name + "_" + $unity[$i] + ".png"
    $rbx = $name + "_" + $roblox[$i] + ".png"

    Write-Host "[RENAMING]" -nonewline -foregroundcolor green; Write-Host " Renaming to $rbx..."
    Move-Item $uty "temp.TEMP"; Start-Sleep -m 100 # This is because sometimes name changes don't apply if we're only changing from "example" to "EXAMPLE".
    Move-Item "temp.TEMP" $rbx
}

$up = $Path + "\" + $name + "_UP.png"
$dn = $Path + "\" + $name + "_DN.png"
Write-Host ""

Write-Host "[ROTATING]" -nonewline -foregroundcolor green; Write-Host " $up" -foregroundcolor blue
$u = New-Object System.Drawing.Bitmap $up
$u.RotateFlip("Rotate270FlipNone")
$u.Save($up,"png")
Write-Host "[ROTATING]" -nonewline -foregroundcolor green; Write-Host " $dn" -foregroundcolor blue
$d = New-Object System.Drawing.Bitmap $dn
$d.RotateFlip("Rotate90FlipNone")
$d.Save($dn,"png")

Write-Host "","Done."