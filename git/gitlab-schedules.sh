#!/bin/bash

# get project
#curl --header "PRIVATE-TOKEN: $token" "$nonprod_project_uri" | jq

# get project schedules
#curl --header "PRIVATE-TOKEN: $token" "$nonprod_project_uri/pipeline_schedules" | jq

# create new single schedule
#new_sched_id=$(curl --request POST --header "PRIVATE-TOKEN: $token" --form description="$description" --form ref="master" --form cron="$cron" --form cron_timezone="$cron_timezone" --form active="false" "$nonprod_project_uri/pipeline_schedules" | jq --raw-output '.id')

# update variables for single schedule
#curl --request POST --header "PRIVATE-TOKEN: $token" --form "key=$var" --form "value=$value" "$nonprod_project_uri/pipeline_schedules/$new_sched_id/variables"

# eventually do a vault lookup for this token
export token="<token_here>"

export nonprod_cron1="0 19 * * 2#3"
export nonprod_cron2="0 20 * * 2#3"
export cron_timezone="America/Los_Angeles"

#export prod_db_project_uri="https://gitlab.getty.cloud/api/v4/projects/7580"
#export prod_app_project_uri="https://gitlab.getty.cloud/api/v4/projects/8722"
export nonprod_project_uri="https://gitlab.getty.cloud/api/v4/projects/8723"

export var_value_dry_run="true"
export var_value_account="nonprod"

# app group list, format "<app-group>:<application>"
declare -a nonprod_app_groups1=(
    "getty-api:apidb" \
    "ctbsys:ctbdb" \
    "search:searchdb" \
    "entsvc:gmsdb" \
    "entapp-support:icmdb" \
    "asset:distdb" \
    "search:prodcatdb" \
    "infrastructure:admjmp" \
    "financials:esker" \
    "financials:noeapp"
    )

declare -a nonprod_app_groups2=(
    "asset:eddb" \
    "royalties:sqlryl" \
    "uipath:uipathdb" \
    "sabrix:taxdb" \
    "getpaid:gpdb" \
    "noetix:noedb" \
    "financials:taxrpt" \
    "financials:uipath" \
    "financials:uipbot" \
    "finnacials:wtax"
    )

for app_group in "${nonprod_app_groups1[@]}"
do
    # set vars for loop
    var_value_app_group=$(echo $app_group | awk -F':' '{print $1}')
    var_value_application=$(echo $app_group | awk -F':' '{print $2}')

    # create description
    description="$var_value_account-$var_value_app_group-$var_value_application"

    # create schedule
    echo "Creating new schedule for $var_value_app_group..."
    new_sched_id=$(curl --request POST --header "PRIVATE-TOKEN: $token" --form description="$description" --form ref="master" --form cron="$nonprod_cron1" --form cron_timezone="$cron_timezone" --form active="false" "$nonprod_project_uri/pipeline_schedules" | jq --raw-output '.id')
    echo "Schedule $new_sched_id created."

    echo "Setting variables for $new_sched_id"
    # update variables
    curl --request POST --header "PRIVATE-TOKEN: $token" --form "key=ACCOUNT" --form "value=$var_value_account" "$nonprod_project_uri/pipeline_schedules/$new_sched_id/variables"
    curl --request POST --header "PRIVATE-TOKEN: $token" --form "key=APPGROUP" --form "value=$var_value_app_group" "$nonprod_project_uri/pipeline_schedules/$new_sched_id/variables"
    curl --request POST --header "PRIVATE-TOKEN: $token" --form "key=APPLICATION" --form "value=$var_value_application" "$nonprod_project_uri/pipeline_schedules/$new_sched_id/variables"
    curl --request POST --header "PRIVATE-TOKEN: $token" --form "key=DRY_RUN" --form "value=$var_value_dry_run" "$nonprod_project_uri/pipeline_schedules/$new_sched_id/variables"
    echo "Done with schedule for $var_value_app_group."
done

for app_group in "${nonprod_app_groups2[@]}"
do
    # set vars for loop
    var_value_app_group=$(echo $app_group | awk -F':' '{print $1}')
    var_value_application=$(echo $app_group | awk -F':' '{print $2}')

    # create description
    description="$var_value_account-$var_value_app_group-$var_value_application"

    # create schedule
    echo "Creating new schedule for $var_value_app_group..."
    new_sched_id=$(curl --request POST --header "PRIVATE-TOKEN: $token" --form description="$description" --form ref="master" --form cron="$nonprod_cron2" --form cron_timezone="$cron_timezone" --form active="false" "$nonprod_project_uri/pipeline_schedules" | jq --raw-output '.id')
    echo "Schedule $new_sched_id created."

    echo "Setting variables for $new_sched_id"
    # update variables
    curl --request POST --header "PRIVATE-TOKEN: $token" --form "key=ACCOUNT" --form "value=$var_value_account" "$nonprod_project_uri/pipeline_schedules/$new_sched_id/variables"
    curl --request POST --header "PRIVATE-TOKEN: $token" --form "key=APPGROUP" --form "value=$var_value_app_group" "$nonprod_project_uri/pipeline_schedules/$new_sched_id/variables"
    curl --request POST --header "PRIVATE-TOKEN: $token" --form "key=APPLICATION" --form "value=$var_value_application" "$nonprod_project_uri/pipeline_schedules/$new_sched_id/variables"
    curl --request POST --header "PRIVATE-TOKEN: $token" --form "key=DRY_RUN" --form "value=$var_value_dry_run" "$nonprod_project_uri/pipeline_schedules/$new_sched_id/variables"
    echo "Done with schedule for $var_value_app_group."
done

# end of line