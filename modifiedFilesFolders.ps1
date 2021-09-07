# Author: Inez Hernandez Fuerte   Date: 8/17/2021
# Description: Gets a report of any files in the user inputed folders and their subfolder
# that have been newly created or modified since the user inputted date ticket: https://tpgrp.teamwork.com/desk/tickets/5579297
# Source: Conver user input to date: https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/converting-user-input-to-date
# Itterate through folder: https://community.spiceworks.com/topic/2143488-powershell-script-to-list-folders-that-have-files-with-date-modified-in-a-range

# User Input: using -as flag to check valid user input and then conver to DateTime
$date = Read-Host 'Enter modified since date:'
if (($date -as [DateTime]) -ne $null) {
  $date = [DateTime]::Parse($date)
} else {
  'Error in date, format as: MM/DD/YYYY'
}

# $edate = Read-Host 'Enter the last date to check for files:'
# if (($edate -as [DateTime]) -ne $null) {
#   $edate = [DateTime]::Parse($edate)
# } else {
#   'Error in date, format as: MM/DD/YYYY'
# }

# User Input: get the folder path
# get the file path from the user and store in $location variable
$location = Read-Host "Enter path as: Drive:\somefolder\somefolder\ <-backslash at the end"
$folders = Get-ChildItem -LiteralPath $location -Directory

# Let the user know the process is starting
Write-Host "Starting process, a message will appear once finished"

# Return: now that we have the user inputs, return the file(s)
# can do an -and $_.LastWriteTime -le to a specified date
Get-ChildItem $location -Recurse -File |
    Where-Object { $_.LastWriteTime -ge $date } | Select-Object Directory, LastWriteTime, Name | Export-Csv -Path $env:USERPROFILE\Desktop\results1.csv -NoTypeInformation

# let user know we are done.
Write-Host "Process completed"
