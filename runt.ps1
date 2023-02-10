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
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript(
        {Test-Path -Path (-join (((Get-Location).Path), "\", $_, ".rexx")) -Type Leaf}
    )]
    [String]
    $TestScriptName,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript(
        {Test-Path -Path (-join (((Get-Location).Path), "\", $_, ".rexx")) -Type Leaf}
    )]
    [String]
    $SourceFileName
)

