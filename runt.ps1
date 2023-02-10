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
    [String]
    $TestScriptName,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $SourceFileName
)

