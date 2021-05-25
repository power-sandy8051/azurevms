[CmdletBinding()]
param(
    [string]$diskSize,
    [string]$driveLetter
)

$disk = Get-Disk | Where partitionstyle -eq 'raw' | sort number

$label = "Local Disk"

if ([int]diskSize -ge 2048){
  $partitionStyle = "GPT"
}
else{
  $partitionStyle = "MBR"
}

$disk | 
Initialize-Disk -PartitionStyle $partitionStyle -PassThru |
New-Partition -UseMaximumSize -DriveLetter $driveLetter |
Format-Volume -FileSystem NTFS -NewFileSystemLabel $label -Confirm:$false -Force
