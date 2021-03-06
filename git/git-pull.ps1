# I am a lazy engineer and don't want to do this stuff all the time

function Pull-GitFolders {
    # git pull for every sub-folder of current location
    $start_location = Get-location
    $subfolders = Get-ChildItem -Directory

    foreach ($folder in $subfolders) {
        $foldername = $folder.Name
        Set-Location $folder
        $is_git_project = Test-Path ".git"
        if ($is_git_project -eq "true") {
            Write-Output "Pulling updates for $foldername"
            try {
                $current_branches = git branch
                if ($current_branches -like "*main") {
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
        } else {
            Write-Output "$folder is just a folder, not a real git project. There may be git projects under this sub-folder."
        }
        Set-Location $start_location
    }
}

# end of line
