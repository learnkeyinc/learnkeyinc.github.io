$console = $host.ui.rawui
$console.backgroundcolor = "Black"
clear-host

# Part 1: 
# $courseName = "IC3 GS5"
$courseName = "Communication Skills for Business (CSB)"
# Part 2:
# $sessionIds = @("281119","281129")
$sessionIds = @("063239","063249","063259","063269","063279","063289")
# Part 3: 
# $fileNames = @(("H0001","M0001"),("H0001","FM001","C0001"))
$fileNames = @(("C0001","C0002","C0003","C0004","C0005","C0006","C0007","C0008","C0009","C0010","C0011","C0012","F0001","C0013","C0014","C0015","C0016","C0017","C0018","C0019","C0020","C0021","C0022","C0023","C0024","C0025","C0026","C0027"),("C0001","C0002","F0001","C0003","C0004","C0005","C0006","C0007","C0008","F0002","C0009","C0010","C0011","C0012","F0003","C0013","F0004","F0005","C0014","F0006","C0015","F0007","C0016"),("C0001","C0002","C0003","C0004","C0005","C0006","C0007","M0001","C0008","C0009","C0010","F0001","C0011","C0012","F0002","C0013","F0003","C0014"),("C0001","C0002","C0003","C0004","C0005","C0006","C0007","C0008","C0009"),("C0001","C0002","C0003","F0001"),("C0001","C0002","C0003","C0004","C0005","C0006","C0007","C0008","F0001","C0009","C0010","C0011","F0002"))
# Part 4:
# $rootAssets = @("ic3-gs5-start.html","ic3-gs5-domain-1.html")

# $commonAssets = 

$destination = ".\media"
$destinationResolved = Resolve-Path $destination -ErrorAction SilentlyContinue -ErrorVariable _destinationTemp
if (!$destinationResolved) {
  $destinationResolved = $_destinationTemp[0].TargetObject
}

function Wait-AnyKey {
  $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
  Write-Host
}

function Write-Result {
  param (
    $bool
  )
  if ($bool) {
    Write-Host "`tSuccess" -ForegroundColor Cyan -NoNewLine
  } else {
    Write-Host "`tFailure" -ForegroundColor Red -NoNewLine
  }
}

Write-Host "This script will download and replace the media for the " -NoNewLine
Write-Host $courseName -ForegroundColor Cyan -NoNewLine
Write-Host " course."
Write-Host "`nAffected parent directory:"
Write-Host "`t$destinationResolved" -ForegroundColor Cyan
Write-Host "`nAffected subfolders:"
Write-Host "`t" -NoNewLine
Write-Host $sessionIds -Separator ", " -ForegroundColor Cyan
Write-Host "`nExisting files in these subfolders will be removed and overwritten." -ForegroundColor Red
Write-Host "`nPress any key to continue" -ForegroundColor Cyan -NoNewLine
Wait-AnyKey


# Delete existing subdirectories and create new ones
$fso = New-Object -ComObject scripting.filesystemobject
Write-Host "`n`tSession`tDelete`tCreate"
Write-Host   "`t-------`t------`t------"
Foreach ($i in $sessionIds)
{  
  Write-Host "`t$i" -NoNewLine
  $delete = $true
  try {
    # Only delete method that works with OneDrive
    $fso.DeleteFolder("$destination\$i*")
  } catch {
    $delete = $false
  }
  Write-Result($delete)
  
  $create = $true
  try {
    $null = New-Item -ItemType "directory" -Path "$destination\$i\CD\WinFlash"
  } catch {
    $create = $false
  }
  Write-Result($create)
  Write-Host
}

Write-Host "`nPress any key to begin downloading" -ForegroundColor Cyan -NoNewLine
Wait-AnyKey

Write-Host "`nDownloading." -ForegroundColor Red
Write-Host "`n`tSession`tPrefix`tResult`tSize"
Write-Host   "`t-------`t------`t-------`t--------"

$i = 0
foreach ($session in $sessionIds) {
  foreach ($file in $fileNames[$i]) {
    $download = $true
    $url = "https://media-aws.onlineexpert.com/realcbt/$session/CD/WinFlash/$file.mp4"
    $destinationFilename = "$destination\$session\CD\WinFlash\$file.mp4"
    Write-Host "`t$session`t$file" -NoNewLine
    $filesize = "N/A"
    try {
      $client = new-object System.Net.WebClient
      $client.DownloadFile($url,$destinationFilename)
    } catch {
      $download = $false
    }
    Write-Result($download)
    try {
      $destinationFile = Get-ChildItem $destinationFilename -ErrorAction Stop
      $filesize = "$(% {([int]($destinationFile.length / 104857.6))/10}) MB"
    } catch {}
    
    Write-Host "`t$filesize"
    Write-Host
  }
  $i = $i + 1
}
Write-Host "`n`nDownload complete. Press any key to exit" -ForegroundColor Cyan
Wait-AnyKey
