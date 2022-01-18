$cron="0 19 * * 2#3"
#$cron_timezone="Pacific Time (US & Canada)"
$cron_timezone="America/Los_Angeles"
$token = "<token_here>"
$project_uri = "https://gitlab.getty.cloud/api/v4/projects/<project_number>"

# pipeline schedule vars
$description = "nonprod-getty-api-apidb"

$var = "ACCOUNT"
$value = "nonprod"

$var = "APPGROUP"
$value = "getty-api"

$var = "APPLICATION"
$value = "apidb"

$var = "DRY_RUN"
$value = "true"

# get project using Invoke-WebRequest instead of RestMethod
$Form = @{
    cron = "$cron"
    cron_timezone = "$cron_timezone"
    description = "$description"
    ref = 'master'
    active = 'false'
}


$Parameters['id'] = $prj.id
$Request_uri = $project_uri+"/pipeline_schedules/"


$new_schedule = Invoke-WebRequest -Uri $request_uri -Method Put -Form $Form

-Headers @{ 'PRIVATE-TOKEN'="$token" }

# get project
Invoke-RestMethod -Headers @{ 'PRIVATE-TOKEN'="$token" } -Uri $nonprod_project_uri

# get project schedules
Invoke-RestMethod -Headers @{ 'PRIVATE-TOKEN'="$token" } -Uri "$nonprod_project_uri/pipeline_schedules"

# get the schedule
$schedule = Invoke-RestMethod -Headers @{ 'PRIVATE-TOKEN'="$token" } -Uri "$nonprod_project_uri/pipeline_schedules/$schedule_id"

# create a schedule
$new_uri = "$nonprod_project_uri/pipeline_schedules?description="+"$description"+"&ref=master&active=false&cron=$cron"
$new_schedule=Invoke-RestMethod -Method Post -Headers @{ 'PRIVATE-TOKEN'="$token" } -Uri $new_uri
$schedule_id = $new_schedule.id

# set vars
$var_uri = "$nonprod_project_uri/pipeline_schedules/$new_schedule_id/variables?key=$var&value=$value"
$add_var=Invoke-RestMethod -Method Post -Headers @{ 'PRIVATE-TOKEN'="$token" } -Uri $var_uri

# set timezone - I will win this battle

$fix_tz=Invoke-RestMethod -Method Post -Headers @{ 'PRIVATE-TOKEN'="$token" } -Uri $tz_uri