[CmdletBinding()]
param(
  [Parameter($Mandatory = $true)][object]$scriptParams
)

$disk = Get-Disk | Where partitionstyle -eq 'raw' | sort number

$label = "Local Disk"

if ([int]$scriptParams.diskSize - ge 2048){
  $partitionStyle = "GPT"
}
else{
  $partitionStyle = "MBR"
}

$driveLetter = $scriptParams.driveLetter.ToString()

$disk | 
Initialize-Disk -PartitionStyle $partitionStyle -PassThru |
New-Partition -UseMaximumSize -DriveLetter $driveLetter |
Format-Volume -FileSystem NTFS -NewFileSystemLabel $label -Confirm:$false -Force
