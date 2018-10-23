Push-Location $PSScriptRoot

if(-not (Test-Path object-type-map.csv)){Copy-Item object-type-map.EXAMPLE.csv object-type-map.csv }

if(-not (Test-Path default.config.json)){
    # Copy-Item default.config.EXAMPLE.json default.config.json
    
    $project_config = Get-Content default.config.EXAMPLE.json | ConvertFrom-Json 

    #TODO: do some stuff here to set the vals
    Write-Error "Some lazy developer didn't finish this..."

    $project_config | ConvertTo-Json -Depth 10 | Out-File default.config.json -Encoding ascii
}

if(-not (Test-Path default.config.csv )){
    
    $db_config = Get-DbaDatabase -SqlInstance localhost -ExcludeAllSystemDb | ForEach-Object {
        [PSCustomObject]@{
            Name = $_.Name
            Prod = "localhost"
            QA   = "(local)"
            Dev  = "127.0.0.1"
		}
    }
    
    $default = [PSCustomObject]@{
        Name = "*"
        Prod = "localhost"
        QA   = "(local)"
        Dev  = "127.0.0.1"
    }

    $db_config += $default
    
    $db_config | ConvertTo-Csv -NoTypeInformation | Out-File "default.config.csv" -Encoding ascii
}

Pop-Location
