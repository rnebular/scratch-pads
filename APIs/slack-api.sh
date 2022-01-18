
## Stuff to report in as online in Slack feed channel.
# webhook for proj-gitlab-upgrade:
export webhook="<webhook_here>"

instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)

aws_asgname=$(aws autoscaling --region us-west-2 describe-auto-scaling-instances --query=AutoScalingInstances[].AutoScalingGroupName --instance-ids="$instance_id" --output text | cut -d'"' -f 2)

aws_instance_refresh=$(aws autoscaling --region us-west-2 describe-instance-refreshes --auto-scaling-group-name $aws_asgname)
echo $aws_instance_refresh

aws_instance_refresh_status=$(echo $aws_instance_refresh | jq -r '.InstanceRefreshes[].Status' --max-records 1)
echo $aws_instance_refresh_status

aws_instance_refresh_percentage=$(echo $aws_instance_refresh | jq -r '.InstanceRefreshes[].PercentageComplete')
echo $aws_instance_refresh_percentage

instance_desc=$(aws ec2 --region us-west-2 describe-instances --instance-id $instance_id)
app_group_tag=$(echo $instance_desc | jq -r '.Reservations[].Instances[].Tags[] | select(.Key == "application-group")' | jq .Value | tr -d '"')
echo $app_group_tag


# should we report percentage or not
if [ $aws_instance_refresh_status = "InProgress" ]
then
  echo "Refresh in progress, sending status and percentage."
  payload_data='{"text":":robocop: *Gitlab Runner Status Update* \n_ASG: '"$aws_asgname"'_ \nApplication group: '"$app_group_tag"' \nRunner Description: '"$runner_description"' \nInstance Refresh Status: '"$aws_instance_refresh_status"'\nRefresh Percentage: '"$aws_instance_refresh_percentage"'"}'
else
  echo "Refresh not running, sending status only."
  payload_data='{"text":":robocop: *Gitlab Runner Status Update* \n_ASG: '"$aws_asgname"'_ \nApplication group: '"$app_group_tag"' \nRunner Description: '"$runner_description"' \nInstance Refresh Status: '"$aws_instance_refresh_status"'"}'
fi

# send it
curl -X POST -H 'Content-type: application/json' --data "$payload_data" $webhook
