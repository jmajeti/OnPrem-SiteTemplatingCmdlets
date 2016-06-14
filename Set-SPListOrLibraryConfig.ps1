<#
.Synopsis
   Set-SPListOrLibraryConfig sets properties of the list or library
.DESCRIPTION
   This Cmdlet sets the configuration (properties) of the list or library
.EXAMPLE
   In this example, we use the Set-SPListOrLibraryConfig Cmdlet to set two properties on a list   
   
   $webSite = Get-SPWeb -Identity http://content.contoso.local
   $list = Get-SPListOrLibrary -Web $webSite -ListOrLibraryName "Project Risks"

   Set-SPListOrLibraryConfig -ListOrLibrary $list -PropertyName OnQuickLaunch -Value $true
   Set-SPListOrLibraryConfig -ListOrLibrary $list -PropertyName Title -Value "Risk Log" -ExecuteQuery

   Using -Update forces the configuration updates back to SharePoint.
   Use this if setting multiple properties on the last instance to reduce server calls.
.EXAMPLE
   
#>
function Set-SPListOrLibraryConfig
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        $ListOrLibrary,

        [Parameter(Mandatory=$true,
                   Position=1)]
        [string]$Property,

        [Parameter(Mandatory=$true,
                   Position=1)]
        $Value,

        [Parameter(Mandatory=$false,
                   Position=2)]
        [switch]$ExecuteQuery
    )

    Begin
    {
        Start-SPAssignment -Global
    }

    Process
    {
        $ListOrLibrary.$Property = $Value
        
        if ($ExecuteQuery)
        {
            $ListOrLibrary.Update()   
        }
    }

    End
    {
        Stop-SPAssignment -Global
    }
}
