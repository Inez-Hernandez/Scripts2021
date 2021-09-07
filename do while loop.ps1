# Inez Hernandez Fuerte    Date: 9/7/2021
# Description: Test a do while loop in powershell to better optimize scripts, copied and pasted from countfolders script
# Source: https://devblogs.microsoft.com/scripting/powershell-looping-understanding-and-using-do-while/

# First, we set the variable for our do while loop control
$a = 1
# we will be using x to store file name
$x
# if x = 1, then we stop the loop, otherwise if x = 2 then we loop again
DO
{
  # here we reset the loop counter, otherwise would infinitely loop
  $a = 1

  # Do the stuff
  # get the file path from the user and store in $location variable
  Write-Host "Enter path, please note formating does matter, please insclude a \ at the end: Ex: drive:\somefolder\somefolder\ <-backslash at the end"
  $location = Read-Host -Prompt 'Enter Path'
  #$location = "' - $location - '"
  # get the top level folders in the current directory
  $folders = Get-ChildItem -Path $location -Directory

  # Let the user know the process is starting
  Write-Host "Starting process, a message will appear once finished"
  # Declare our array for use
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
  # set a variable for file name:
  $x = Read-Host "Enter file name to save as: "
  $array | Export-Csv -Path $env:USERPROFILE\Desktop\$x.csv -NoTypeInformation

  # let user know we are done.
  Write-Host "Process completed"
  # Once we are done, prompt the user for an action, should do an assert, but since this isn't user facing I expect our IT team to be able to follow prompts.
  $a = Read-Host "Do you wish to continue? Enter 1 for No OR Enter 2 for Yes"

} While ($a -eq 2)
