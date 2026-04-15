function Invoke-EVDQuery
{
<#
.SYNOPSIS
    Execute a SQL query against the CyberArk EVD database and optionally export results to CSV.

.DESCRIPTION
    Runs a SQL query using Windows Integrated Security. Connection settings are loaded from EVD.psd1
    located in the parent directory of this script.

    The workflow provides all file paths — the user just runs the command as given.

    Required AD group membership:

    Prod:
        <ORG>_Prod_EPVEVD_CyberArk_USR_RO
        <ORG>_Prod_EPVEVD_Reporting_USR_RO

    UAT / Dev:
        <ORG>_UAT_EPVEVD_CyberArk_USR_RO
        <ORG>_UAT_EPVEVD_Reporting_USR_RO

.PARAMETER SQLQuery
    Inline SQL query string.

.PARAMETER SQLFile
    Path to a .sql file.

.PARAMETER ExportPath
    Full path for CSV export. If omitted, results are displayed but not saved.

.PARAMETER QueryName
    Short label for log output. Defaults to the SQL file name when using -SQLFile.

.PARAMETER Environment
    Target environment: Dev | UAT | Prod (default: Prod).

.PARAMETER PassThru
    Return the DataTable object to the pipeline.

.EXAMPLE
    Invoke-EVDQuery -SQLFile '..\stages\01_sql_gen\output\query.sql' -ExportPath '..\stages\02_data_fetch\output\vault_data.csv'

.EXAMPLE
    Invoke-EVDQuery -SQLQuery 'SELECT TOP 10 * FROM CASafes' -Environment Dev -PassThru

#>

    [CmdletBinding(DefaultParameterSetName = 'SQLQuery')]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'SQLQuery')]
        [Alias('Query')]
        [string]$SQLQuery,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'SQLFile')]
        [Alias('File')]
        [string]$SQLFile,

        [string]$ExportPath,

        [string]$QueryName,

        [ValidateSet('Dev','UAT','Prod')]
        [string]$Environment,

        [switch]$PassThru
    )

    begin
    {
        Write-Debug "Begin: loading configuration"

        $EVDDir     = Split-Path $PSScriptRoot -Parent
        $ConfigFile = Join-Path $EVDDir 'EVD.psd1'

        if (-not (Test-Path $ConfigFile)) {
            throw "EVD.psd1 not found at: $ConfigFile"
        }

        $EVDConfig = Import-PowerShellDataFile $ConfigFile
        $ActiveEnv = if ($PSBoundParameters.ContainsKey('Environment')) { $Environment } else { 'Prod' }

        $cfg = $EVDConfig.Environments[$ActiveEnv]

        if (-not $cfg) {
            throw "Environment '$ActiveEnv' not found in EVD.psd1"
        }

        $ConnectionString = "Server=$($cfg.ServerName),$($cfg.Port);Database=$($cfg.Database);Integrated Security=True;TrustServerCertificate=$($cfg.TrustedServerCert);Connection Timeout=$($cfg.ConnectionTimeout)"

        Write-Verbose "Environment: $ActiveEnv"
        Write-Verbose "Server     : $($cfg.ServerName):$($cfg.Port)"
        Write-Verbose "Database   : $($cfg.Database)"
    }

    process
    {
        try
        {
            # Resolve query source
            if ($PSCmdlet.ParameterSetName -eq 'SQLFile')
            {
                if (-not (Test-Path $SQLFile)) {
                    throw "SQL file not found: $SQLFile"
                }

                $Query = Get-Content -Raw $SQLFile

                if (-not $QueryName) {
                    $QueryName = [System.IO.Path]::GetFileNameWithoutExtension($SQLFile)
                }
            }
            else
            {
                $Query = $SQLQuery

                if (-not $QueryName) {
                    $QueryName = 'inline'
                }
            }

            # Execute query
            $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

            $connection = New-Object System.Data.SqlClient.SqlConnection
            $connection.ConnectionString = $ConnectionString
            $connection.Open()

            $command = $connection.CreateCommand()
            $command.CommandText = $Query
            $command.CommandTimeout = 300

            $reader = $command.ExecuteReader()
            $results = New-Object System.Data.DataTable
            $results.Load($reader)

            $stopwatch.Stop()
            $elapsed = $stopwatch.Elapsed

            # Export CSV if path provided
            if ($ExportPath)
            {
                $ExportDir = Split-Path $ExportPath -Parent
                if ($ExportDir -and -not (Test-Path $ExportDir)) {
                    New-Item -ItemType Directory -Path $ExportDir | Out-Null
                }

                $results | Export-Csv -Path $ExportPath -NoTypeInformation -Encoding UTF8
            }

            # Summary
            $summary = "$QueryName $($results.Rows.Count) rows | $($elapsed.ToString())"
            if ($ExportPath) {
                $summary += " | CSV: $(Split-Path $ExportPath -Leaf)"
            }

            Write-Host $summary -ForegroundColor Cyan

            if ($PassThru) {
                $results
            }
        }
        catch
        {
            Write-Error "Query failed [$QueryName]: $_"
            throw
        }
        finally
        {
            if ($reader)     { $reader.Dispose() }
            if ($command)    { $command.Dispose() }
            if ($connection) { $connection.Close() }
        }
    }

    end
    {
        Write-Debug "End: complete"
    }
}
