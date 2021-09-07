#Author: Cody Herb, Inez Hernandez  Date: 4/6/2021
# To Run: Run ps as admin and cd to file location. Enter: .\psfilename.ps1
# then after the prompt enter path - ex: \\tpgrp.com\companies\Benefits
# Description: This script is meant to count the number of files found inside the folders inside of a user specified directory. Note that to be able to successfully
# Find the files of the subfolders within a single folder the path provided by the user must end with a backslash \ otherwise will not work.
# Sources: https://techbloggingfool.com/2019/01/25/powershell-folder-report-with-file-count-and-size/

# get the file path from the user and store in $location variable
$location = Read-Host "Enter path, please note formating does matter, please insclude a \ at the end: Ex: drive:\somefolder\somefolder\ <-backslash at the end"
# get the top level folders in the current directory
$folders = Get-ChildItem -LiteralPath $location -Directory

# Let the user know the process is starting
Write-Host "Starting process, a message will appear once finished"
# Declare array, set to empty
$array = @()

# this does, for each folder within the folders found at the user specified location loop through
# Each itteration will concatinate the location name with the folder name so it can recurse through each subfolder within the folder
# saves the top level folder name and the count of how many files are found to the array, prints at the very end out side the loop.
foreach ($folder in $folders)
{
  # there is a file path limit of 260, some of the files exceed that so to overcome thought I could use: but doesn't work....$extendPath = "\\?"
  # Because of powershell limitations with get-childitem when it comes to more than one subfolder inside a folder, had to concatinate to get directory name
  $subDir = $location + $folder

  # reset fileCount with each itteration, otherwise will have previously stored data.
  $fileCount = $NULL

  # do the recursion of each subfolder, literalpath is required, recurse tells it to check each subfolder, and the file flag tells it to return just files
  # and not to cound the names of folders or subdirectories. the .Count tells it to return just a number value
  $fileCount = (Get-ChildItem -LiteralPath $subDir -Recurse -File).Count
  # writes to the screen the number, helpful for error checking and just to let us know its doing something.
	Write-Host $fileCount

  #store the information into our array
  $array += [pscustomobject] @{
    Folder = $folder
    Count = $fileCount
  }
}

# prints out results to results.csv file on users desktop.
$array | Export-Csv -Path $env:USERPROFILE\Desktop\results1.csv -NoTypeInformation

# let user know we are done.
Write-Host "Process completed"
