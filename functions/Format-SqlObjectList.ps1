function Format-SqlObjectList {
<#
.SYNOPSIS
    Sanitize inputs from pipeline. Return consituent parts for downstream use. Add servers.
    
.DESCRIPTION
    We assume object names are coming in as simple 3-part-qualified' strings.
    Split them into identifier parts and prepend default Server 
        for requested environment based on local config. 

.EXAMPLE
    Format-SqlObjectList -objList @("foo.bar.blah","bork..bork") -env "prod"

.TODO
    1) Add support for inferred DB name?
#>
    [CmdletBinding()]Param(
         [string[]]$objList
        ,[Parameter(Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$env
        ,$config = $sqlCodeReview_DefaultServerConfig
    )

    $objList | ForEach-Object {
        $DatabaseName = $PSItem.Split(".")[0]
        $schemaName   = $PSItem.Split(".")[1]
        $objectName   = $PSItem.Split(".")[2]
        
        if([string]::IsNullOrWhiteSpace($schemaName)){$schemaName="dbo"}      
        
        [PSCustomObject] @{
            Server   = (Get-SqlServerFromConfig -Database $DatabaseName -config $config).$env
            Database = $DatabaseName
            Schema   = $schemaName
            Name     = $objectName
            RawName  = $PSItem
        }
    }
}