function New-ServiceNowTableEntry{
    Param
    (
        # Name of the table we're inserting into (e.g. incidents)
        [parameter(mandatory=$true)]
        [parameter(ParameterSetName='SpecifyConnectionFields')]
        [parameter(ParameterSetName='UseConnectionObject')]
        [parameter(ParameterSetName='SetGlobalAuth')]
        [string]$Table,
        
        # Hashtable of values to use as the record's properties
        [parameter(mandatory=$false)]
        [parameter(ParameterSetName='SpecifyConnectionFields')]
        [parameter(ParameterSetName='UseConnectionObject')]
        [parameter(ParameterSetName='SetGlobalAuth')]
        [hashtable]$Values,
        
        # Credential used to authenticate to ServiceNow  
        [Parameter(ParameterSetName='SpecifyConnectionFields', Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [PSCredential]
        $ServiceNowCredential, 

        # The URL for the ServiceNow instance being used  
        [Parameter(ParameterSetName='SpecifyConnectionFields', Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ServiceNowURL, 

        #Azure Automation Connection object containing username, password, and URL for the ServiceNow instance
        [Parameter(ParameterSetName='UseConnectionObject', Mandatory=$True)] 
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $Connection
    )


    #Get credential and ServiceNow REST URL
    if ($Connection -ne $null)
    {
        $SecurePassword = ConvertTo-SecureString $Connection.Password -AsPlainText -Force
        $ServiceNowCredential = New-Object System.Management.Automation.PSCredential ($Connection.Username, $SecurePassword)
        $ServiceNowURL = 'https://' + $Connection.ServiceNowUri + '/api/now/v1'
        
    } 
    elseif ($ServiceNowCredential -ne $null -and $ServiceNowURL -ne $null)
    {
        $ServiceNowURL = 'https://' + $ServiceNowURL + '/api/now/v1'
    }
    elseif((Test-ServiceNowAuthIsSet))
    {
        $ServiceNowCredential = $Global:ServiceNowCredentials
        $ServiceNowURL = $global:ServiceNowRESTURL
    } 
    else 
    {
        throw "Exception:  You must do one of the following to authenticate: `n 1. Call the Set-ServiceNowAuth cmdlet `n 2. Pass in an Azure Automation connection object `n 3. Pass in an endpoint and credential"
    }

    
    $Body = $Values | ConvertTo-Json;

    #Convert to UTF8 array to support special chars such as the danish "??????","??????","??????"
    $utf8Bytes = [System.Text.Encoding]::UTf8.GetBytes($Body)

    # Fire and return
    $Uri = $ServiceNowURL + "/table/$Table?sysparm_input_display_value=true"
    return (Invoke-RestMethod -Uri $uri -Method Post -Credential $ServiceNowCredential -Body $utf8Bytes -ContentType "application/json" -UseBasicParsing).result
}