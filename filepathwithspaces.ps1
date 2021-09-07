$path = Read-Host 'Enter Path'

'before changing variable'
$path

''
$path = $path -replace '"'

'after removing quotes'
$path
