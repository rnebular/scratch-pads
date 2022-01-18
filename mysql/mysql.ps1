# install the connector
$uri_path = "https://artifactory.getty.cloud/artifactory/infrastructure-generic/MySQL"
Invoke-WebRequest -Uri "$uri_path/mysql-connector-net-8.0.20.msi" -OutFile ".\mysql-connector-net.msi"
Invoke-Command -ScriptBlock {.\mysql-connector-net.msi /quiet}

# register the DLL
[void][System.Reflection.Assembly]::LoadFrom("C:\Program Files (x86)\MySQL\MySQL Connector Net 8.0.20\Assemblies\v4.5.2\MySql.Data.dll")


# Importing AWS powershell tools
Import-Module AWSPowerShell

# import mysql powershell module (based on github.com/adbertram/MySQL.git)
Import-Module ".\mysql-functions.psm1"

$vault_addr = 'vault.prod-getty.cloud'

$vault_role_assumed=use-stsrole -RoleArn "arn:aws:iam::428203796648:role/infrastructure/infrastructure-gitlab-runner-vault-role" -RoleSessionName "AssumingProdRole"
$env:AWS_ACCESS_KEY=$vault_role_assumed.Credentials.AccessKeyId
$env:AWS_SECRET_ACCESS_KEY=$vault_role_assumed.Credentials.SecretAccessKey
$env:AWS_SESSION_TOKEN=$vault_role_assumed.Credentials.SessionToken
$env:VAULT_ADDR="https://$($vault_addr):8200"
$vault_login = vault login -method=aws "header_value=$vault_addr"
$mysql_pass=(vault read -field=pet_patching secret/infrastructure/patching/mysql)

# set mysql creds
$mysql_secpasswd = ConvertTo-SecureString $mysql_pass -AsPlainText -Force
$mysql_user = "pet_patching"
$mysql_creds = New-Object System.Management.Automation.PSCredential ($mysql_user, $mysql_secpasswd)
$mysql_db_name = "infrastructure-artifactory-mysql.cirrko8pxqgz.us-west-2.rds.amazonaws.com"

Connect-MySqlServer -ComputerName $mysql_db_name -Credential $mysql_creds

[MySql.Data.MySqlClient.MySqlConnection]$Connection = $MySQLConnection

$connection.ChangeDatabase('pet_patching')

# Always using this ^ Schema/DB

# SQL Query Code Source:
# https://www.w3schools.com/sql/default.asp
#Invoke-MySqlQuery -Query ""

# get tables to choose from
Get-MySqlTable

# get info about databases
Invoke-MySqlQuery -Query "DESCRIBE itilwatchlist_sandbox"

# get data
Invoke-MySqlQuery -Query "SELECT * FROM hosts_sandbox"
Invoke-MySqlQuery -Query "SELECT * FROM hosts"

# get maint info
$app_pattern="sdrdw"
$query = "SELECT * FROM main_prod WHERE app_pattern LIKE '%$app_pattern%'"
$results = Invoke-MySqlQuery -Query $query





# get specific instance
Invoke-MySqlQuery -Query "SELECT instance_id FROM hosts_sandbox WHERE instance_id='$instance_id'"
Invoke-MySqlQuery -Query "SELECT * FROM hosts_sandbox WHERE instance_id='$instance_id'"
$app_group_list = Invoke-MySqlQuery -Query "SELECT tag_fqdn FROM hosts_sandbox WHERE tag_app_group='$app_group' AND tag_fqdn REGEXP '$app_pattern'"


Invoke-MySqlQuery -Query "SELECT * FROM hosts_sandbox WHERE x"
Invoke-MySqlQuery -Query "RENAME TABLE hosts TO hosts_prod;"

# clear out hosts table
Invoke-MySqlQuery -Query "TRUNCATE TABLE hosts_sandbox"

# Create new records in table
Invoke-MySqlQuery -Query "INSERT INTO hosts_sandbox (tag_name,instance_id) VALUES ('test-name','fubar-id')"
 

# update info fake
Invoke-MySqlQuery -Query "UPDATE hosts_sandbox SET app_pattern = 'dummy2' WHERE tag_name = 'test2'"


# clear the table
Invoke-MySqlQuery -Query "DELETE FROM hosts_sandbox"

$add_to_mysql = Invoke-MySqlQuery -Query "INSERT INTO hosts_sandbox (tag_account,tag_name,tag_fqdn,tag_app,tag_app_group,instance_id,tag_app_component,platform,state)
          VALUES ('$env:ACCOUNT','$aws_tag_name_value','$aws_tag_fqdn_value','$aws_tag_app_value','$aws_tag_app_group_value','$instance_id','$aws_tag_app_component_value','$platform_value','$instance_state');
          "


# create a test table
Invoke-MySqlQuery -Query "
CREATE TABLE test_table (
    column1 varchar(255),
    column2 varchar(255)
)
"

Invoke-MySqlQuery -Query "INSERT INTO test_table (column1) VALUES ('test'),('test2')"

Invoke-MySqlQuery -Query "DROP TABLE test_table"
Invoke-MySqlQuery -Query "DROP TABLE itilwatchlist_sandbox"

Invoke-MySqlQuery -Query "DROP TABLE hosts_sandbox"

Invoke-MySqlQuery -Query "SELECT * FROM itilwatchlist_sandbox"


# copy/pasta
Invoke-MySqlQuery -Query ""


# Disconnect from MySQL server
Disconnect-MySqlServer -Connection $connection

# checking for existing
$check_itilwatchlist_query = 
"SELECT app_pattern
FROM itilwatchlist_sandbox
WHERE EXISTS
(SELECT app_pattern FROM itilwatchlist_sandbox WHERE app_pattern='$line_app_pattern')
"

$test1 = 
"SELECT app_pattern
FROM itilwatchlist_sandbox
"

$result = Invoke-MySqlQuery -Query $check_itilwatchlist_query


Invoke-MySqlQuery -Query "INSERT INTO itilwatchlist_sandbox (app_pattern,itil_watch_list_members) VALUES ('$line_app_pattern','$line_itil_watch_list')"



```
infrastructure-artifactory-mysql.cirrko8pxqgz.us-west-2.rds.amazonaws.com

ALTER TABLE main_sandbox
ADD COLUMN pager_duty_rule VARCHAR(100) AFTER app_slack_channel NOT NULL;

SHOW CREATE TABLE main_sandbox \G
```





# create tables queries (from Shahryar 5-28-2020)
# hosts
CREATE TABLE IF NOT EXISTS `pet_patching`.`hosts` (
  `hosts_id` BIGINT(8) NOT NULL AUTO_INCREMENT,
  `instance_id` VARCHAR(50) NOT NULL,
  `tag_app_group` VARCHAR(50) NOT NULL,
  `tag_app` VARCHAR(50) NOT NULL,
  `tag_app_component` VARCHAR(50) NULL DEFAULT NULL,
  `tag_fqdn` VARCHAR(50) NOT NULL,
  `tag_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`hosts_id`),
  UNIQUE INDEX `UQ_instance_id` (`instance_id` ASC),
  INDEX `IX_tag_fqdn` (`tag_fqdn` ASC),
  INDEX `IX_tag_app_component` (`tag_app_component` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = utf8
COMMENT = 'The table that houses hosts data for app_patterns.'
ROW_FORMAT = COMPRESSED
KEY_BLOCK_SIZE = 8;
​
# itilwatchlist
CREATE TABLE IF NOT EXISTS `pet_patching`.`itilwatchlist` (
  `itilwatchlist_id` BIGINT(8) NOT NULL AUTO_INCREMENT,
  `app_pattern` VARCHAR(50) NOT NULL,
  `itil_watch_list_members` VARCHAR(1000) NOT NULL,
  PRIMARY KEY (`itilwatchlist_id`),
  INDEX `IX_app_pattern` (`app_pattern` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'The table that houses itilwatchlist data for app_patterns.'
ROW_FORMAT = COMPRESSED
KEY_BLOCK_SIZE = 8;
​
# main
CREATE TABLE IF NOT EXISTS `pet_patching`.`main` (
  `main_id` BIGINT(8) NOT NULL AUTO_INCREMENT,
  `app_pattern` VARCHAR(50) NOT NULL,
  `patch_day_prod` VARCHAR(50) NOT NULL,
  `patch_time_start` VARCHAR(50) NOT NULL,
  `patch_time_stop` VARCHAR(50) NOT NULL,
  `app_friendly_name` VARCHAR(100) NOT NULL,
  `app_slack_channel` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`main_id`),
  INDEX `IX_app_pattern` (`app_pattern` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'The table that houses main lookup data for app_patterns.'
ROW_FORMAT = COMPRESSED
KEY_BLOCK_SIZE = 8;






function Update-MainTable {
  param([string]$account,[string]$pagerduty_id)
  # usage: Update-MainTable $account $mysql_query
  # expected result is mysql db updated with 

  # set table var based on $account
  if ($account -eq "sandbox") {
      $table = "main_sandbox"
  } elseif ($account -eq "prod") {
      $table = "main"
  } else {
      Write-Output "Account needs to be either sandbox or prod. Proper syntax for this function is:"
      Write-Output "Update-MainTable <account>"
      Exit 1
  }

  # loop through the main_content list and update or add each $app_pattern
  foreach ($line in $main_content) {
      $line_string = $line.ToString()
      $line_app_pattern = $line_string.Split(",")[0]
      $line_patch_day_prod = $line_string.Split(",")[1]
      $line_app_friendly_name = $line_string.Split(",")[2]
      Write-Output "Updating: $line_app_pattern"
      Write-Output "Setting patch_day as: $line_patch_day_prod"
      Write-Output "Setting app_friendly_name: $line_app_friendly_name"
      
      $update_query =
          "INSERT INTO $table
          (app_pattern,patch_day_prod,app_friendly_name)
          VALUES
          ('$line_app_pattern','$line_patch_day_prod','$line_app_friendly_name')
          ON DUPLICATE KEY UPDATE
          app_pattern='$line_app_pattern',patch_day_prod='$line_patch_day_prod',app_friendly_name='$line_app_friendly_name';
          "
  
      try {
          Invoke-MySqlQuery -Query $update_query
      } catch {
          Write-Output "Error inserting new record in $table. MySQL error was: $insert_result"
      }
      # end of loop through main_content
  }
  
  foreach ($line in $slack_messaging_content) {
      $line_string = $line.ToString()
      $line_app_pattern = $line_string.Split(",")[0]
      $line_app_slack_channel = $line_string.Split(",")[1]
      Write-Output "Updating: $line_app_pattern"
      Write-Output "Setting slack channel as: $line_app_slack_channel"
      
      $update_query =
          "INSERT INTO $table
          (app_pattern,app_slack_channel)
          VALUES
          ('$line_app_pattern','$line_app_slack_channel')
          ON DUPLICATE KEY UPDATE
          app_pattern='$line_app_pattern',app_slack_channel='$line_app_slack_channel';
          "
  
      try {
          Invoke-MySqlQuery -Query $update_query
      }catch {
          Write-Output "Error inserting new record in $table. MySQL error was: $insert_result"
      }
  }
  # end of function Update-MainTable
}




$update_query =
"INSERT INTO $table
(app_pattern,patch_day_prod,app_friendly_name)
VALUES
('$line_app_pattern','$line_patch_day_prod','$line_app_friendly_name')
ON DUPLICATE KEY UPDATE
app_pattern='$line_app_pattern',patch_day_prod='$line_patch_day_prod',app_friendly_name='$line_app_friendly_name';
"

