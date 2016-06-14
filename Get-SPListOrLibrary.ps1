<#
.Synopsis
   Gets a list or libary object
.DESCRIPTION
   Gets a list or library object
.EXAMPLE
   This example returns a document library called 'Project Documents'
   
   $webSite = Get-SPWeb -Identity "http://content.contoso.local"
   $library = Get-SPListOrLibrary -Web $webSite -ListOrLibraryName "Project Documents"
#>
function Get-SPListOrLibrary
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0,
                   HelpMessage="Please pass in a SPWeb object, e.g. the output from Get-SPWeb")]
        [Microsoft.SharePoint.SPWeb]$Web,

        [Parameter(Mandatory=$true,
                   Position=1)]
        [string]$ListOrLibraryName
    )

    Begin
    {
        Start-SPAssignment -Global
        $webObj = $Web
        $listObj = $webObj.Lists[$ListOrLibraryName]
    }
    
    Process
    {
        if ($listObj -eq $null)
        {
            Write-Error "Cannot continue, list or library cannot be found" -RecommendedAction "Check spelling, or create list/ library"
        }
        else
        {
            return $listObj
        }
    }
    
    End
    {
        Stop-SPAssignment -Global
    }
}
