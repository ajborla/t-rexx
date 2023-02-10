<#
.SYNOPSIS
.DESCRIPTION
.PARAMETER TestScriptName
.PARAMETER SourceFileName
.INPUTS
.OUTPUTS
.EXAMPLE
.LINK
.NOTES
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
    [switch]
    $Keep,

    [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
    [switch]
    $TAPOutput,

    [Parameter(Mandatory = $true, ValueFromPipeline = $false)]
    [ValidateNotNullOrEmpty()]
    [String]
    $TestScriptName,

    [Parameter(Mandatory = $true, ValueFromPipeline = $false)]
    [ValidateNotNullOrEmpty()]
    [String]
    $SourceFileName
)

function Get-Script-Location
{
    # Script invocation directory: directory in which script resides, not necessarily current directory
    $scriptInvocation = (Get-Variable MyInvocation -Scope 1).Value
    return Split-Path $scriptInvocation.MyCommand.Path
}

Set-Variable -Name ScriptLocation (Get-Script-Location) -Option Private
Set-Variable -Name TestScriptNamePath (-join ($ScriptLocation, "\", $TestScriptName, ".rexx")) -Option Private
Set-Variable -Name SourceFileNamePath (-join ($ScriptLocation, "\", $SourceFileName, ".rexx")) -Option Private

# Ensure both test script and source file exist
if (-not (Test-Path -Path $TestScriptNamePath -Type Leaf)) {
    throw [System.IO.FileNotFoundException] "Error: Missing test script - $TestScriptNamePath"
}

if (-not (Test-Path -Path $SourceFileNamePath -Type Leaf)) {
    throw [System.IO.FileNotFoundException] "Error: Missing source file - $SourceFileNamePath"
}

