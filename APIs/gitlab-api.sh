$token='<token_here>'

curl --header "PRIVATE-TOKEN: $token" "https://gitlab.sandbox-getty.cloud/api/v4/projects/29/pipeline_schedules"

curl --request POST --header "PRIVATE-TOKEN: $token" --form "key=DRY_RUN" --form "value=$var_value_dry_run" "$nonprod_project_uri/pipeline_schedules/$new_sched_id/variables"


curl --request PUT --header "PRIVATE-TOKEN: $token" \
     --form active="TRUE" "https://gitlab.getty.cloud/api/v4/projects/$project_id/pipeline_schedules/$schedule_id"

