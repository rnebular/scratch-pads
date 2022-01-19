# I am a lazy engineer and don't want to do this stuff all the time

# git pull for every sub-folder of current location
$start_location = Get-location

$subfolders = Get-ChildItem -Directory

foreach ($folder in $subfolders) {
    $foldername = $folder.Name
    Write-Output "Pulling updates for $foldername"
    Set-Location $folder
    try {
        $current_branches = git branch
        if ($current_branches -contains "main") {
            git checkout main
            git pull
        } else {
            git checkout master
            git pull
        }
    } catch {
        Write-Output "Git command(s) failed, perhaps this folder isn't a git clone?"
        Write-Output $Error[0]
    }
    Set-Location $start_location
}

# end of line
