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

#
# Sourced: https://stackoverflow.com/questions/9738535/powershell-test-for-noninteractive-mode
#
function IsNonInteractiveShell {
    # Test each Arg for match of abbreviated '-NonInteractive' command.
    $NonInteractive = [Environment]::GetCommandLineArgs() | Where-Object{ $_ -like '-NonI*' }

    if ([Environment]::UserInteractive -and -not $NonInteractive) {
        # We are in an interactive shell.
        return $false
    }

    return $true
}

function Get-Script-Location
{
    # Script invocation directory: directory in which script resides, not necessarily current directory
    $scriptInvocation = (Get-Variable MyInvocation -Scope 1).Value
    return Split-Path $scriptInvocation.MyCommand.Path
}

Set-Variable -Name ScriptLocation (Get-Script-Location) -Option Private
Set-Variable -Name T1RexxPath (-join ($ScriptLocation, "\", "t1.rexx")) -Option Private
Set-Variable -Name T2RexxPath (-join ($ScriptLocation, "\", "t2.rexx")) -Option Private
Set-Variable -Name T3RexxPath (-join ($ScriptLocation, "\", "t3.rexx")) -Option Private

# Ensure all test framework Rexx source files co-located with current script
foreach ($PathName in @($T1RexxPath,$T2RexxPath,$T3RexxPath)) {
    if (-not (Test-Path -Path $PathName -Type Leaf)) {
        throw [System.IO.FileNotFoundException] "Error: Missing test suite component - $PathName"
    }
}

# Assume target location is the current directory (present working directory or PWD)
Set-Variable -Name TargetLocation (Get-Location) -Option Private
Set-Variable -Name TestScriptNamePath (-join ($TargetLocation, "\", $TestScriptName, ".rexx")) -Option Private
Set-Variable -Name SourceFileNamePath (-join ($TargetLocation, "\", $SourceFileName, ".rexx")) -Option Private

# Test runner name and path
Set-Variable -Name Runner "t.rexx" -Option Private
Set-Variable -Name RunnerFileNamePath (-join ($TargetLocation, "\", $Runner)) -Option Private

# Ensure both test script and source file exist
if (-not (Test-Path -Path $TestScriptNamePath -Type Leaf)) {
    throw [System.IO.FileNotFoundException] "Error: Missing test script - $TestScriptNamePath"
}

if (-not (Test-Path -Path $SourceFileNamePath -Type Leaf)) {
    throw [System.IO.FileNotFoundException] "Error: Missing source file - $SourceFileNamePath"
}

# Assemble test runner from components and supplied files
Get-Content $T1RexxPath, $TestScriptNamePath,
            $T2RexxPath, $SourceFileNamePath,
            $T3RexxPath | Set-Content $RunnerFileNamePath

# Execute test runner with output option
if ($TAPOutput) {
    rexx $RunnerFileNamePath "TAP"     # Emit TAP-compliant output
} else {
    rexx $RunnerFileNamePath           # else report format output
}

# Need to capture return code of test suite run for return to caller
Set-Variable -Name RC -Value $LastExitCode -Option Private

# Unless KEEP option is set, delete the test runner
if (-not $Keep) {
    Remove-Item $RunnerFileNamePath
}

# Return code only needed in a non-interactive shell
if (IsNonInteractiveShell) {
    [Environment]::Exit($RC)
}

