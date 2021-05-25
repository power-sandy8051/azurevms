[CmdletBinding()]
param(
    [int]$diskSize,
    [string]$driveLetter
)

$disk = Get-Disk | Where partitionstyle -eq 'raw' | sort number

$driveLetter = $driveLetter.Trim("'")
$driveLetter = $driveLetter.Trim('"')
$result = [char]$driveLetter[0]

$label = "Local Disk"

if ($diskSize -ge 2048){
  $partitionStyle = "GPT"
}
else{
  $partitionStyle = "MBR"
}

$disk | 
Initialize-Disk -PartitionStyle $partitionStyle -PassThru |
New-Partition -UseMaximumSize -DriveLetter $result |
Format-Volume -FileSystem NTFS -NewFileSystemLabel $label -Confirm:$false -Force
