$disk = Get-Disk | Where partitionstyle -eq 'raw' | sort number
$existing_disk_count = Get-Disk | Where partitionstyle -ne 'raw' | sort number | measure
$existing_disk_count = $existing_disk_count.Count

$letters = 69..89 | ForEach-Object { [char]$_ }
$label = "Local Disk"

$driveLetter = $letters[$existing_disk_count].ToString()
$disk | 
Initialize-Disk -PartitionStyle MBR -PassThru |
New-Partition -UseMaximumSize -DriveLetter $driveLetter |
Format-Volume -FileSystem NTFS -NewFileSystemLabel $label -Confirm:$false -Force
