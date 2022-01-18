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
