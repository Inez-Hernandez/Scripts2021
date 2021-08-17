# Author: Inez Hernandez Fuerte   Date: 8/17/2021
# Description: Gets a report of any files in the user inputed folders and their subfolder
# that have been newly created or modified since the user inputted date ticket: https://tpgrp.teamwork.com/desk/tickets/5579297
# Source: Conver user input to date: https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/converting-user-input-to-date
# Itterate through folder: https://community.spiceworks.com/topic/2143488-powershell-script-to-list-folders-that-have-files-with-date-modified-in-a-range

# $a = NULL
# $a = Get-ChildItem \\server\lll\Received_Orders\*.* | Where{$_.LastWriteTime -ge (Get-Date).AddDays(-7)}
# if ($a = (Get-ChildItem \\server\llll\Received_Orders\*.* | Where{$_.LastWriteTime -ge (Get-Date).AddDays(-7)}))
# {
# }
# Else
# {
#   'STORE lll HAS NOT RECEIVED ANY ORDERS IN THE PAST 7 DAYS'
# }

# User Input: using -as flag to check valid user input and then conver to DateTime
$date = Read-Host 'Enter modified since date:'
if (($date -as [DateTime]) -ne $null) {
  $date = [DateTime]::Parse($date)
} else {
  'Error in date, format as: MM/DD/YYYY'
}

# User Input: get the folder path
# get the file path from the user and store in $location variable
$location = Read-Host "Enter path as: Drive:\somefolder\somefolder\ <-backslash at the end"


# Return: now that we have the user inputs, return the file(s)
Get-ChildItem $location -File -Recurse |
    Where-Object { $_.LastWriteTime -gt $date } |
    select-Object FullName, LastWriteTime
