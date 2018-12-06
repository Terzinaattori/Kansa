<#
.SYNOPSIS
Get-PrefetchParse.ps1
When run via Kansa.ps1 with -Pushbin flag, this module will copy PECMD.exe to the remote system, then run PECmd.exe -d $PathToParse --csv $PrefetchParserOutputPath on the remote system, 
and return the output data as a powershell object.

AppCompatCacheParser.exe can be downloaded from http://ericzimmerman.github.io/

.NOTES
Kansa.ps1 directives
OUTPUT CSV
BINDEP .\Modules\bin\PECmd.exe
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True,Position=0)]
        [String]$PathToParse
)

#Setup Variables
$PrefetchParserPath = ($env:SystemRoot + "\PECmd.exe")
$Runtime = ([String] (Get-Date -Format yyyyMMddHHmmss))
$suppress = New-Item -Name "PECmd-$($Runtime)" -ItemType Directory -Path $env:Temp -Force
$PrefetchParserOutputPath = $($env:Temp + "\PECmd-$($Runtime)")

if (Test-Path ($PrefetchParserPath)) {
    #Run PECmd.exe
    $suppress = & $PrefetchParserPath -d $PathToParse --csv $PrefetchParserOutputPath

    #Output the data.
    Import-Csv -Delimiter "`t" "$PrefetchParserOutputPath\*.csv"
    
    #Delete the output folder.
    # $suppress = Remove-Item $PrefetchParserOutputPath -Force -Recurse
        
} else {
    Write-Error "PECmd.exe not found on $env:COMPUTERNAME"
}