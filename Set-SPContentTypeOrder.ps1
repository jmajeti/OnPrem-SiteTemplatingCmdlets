<#
.Synopsis
   Sets the content type order for a document library or list
.DESCRIPTION
   Sets the content type order for a document library or list
.EXAMPLE
   This example sets the order of available content types on a list or library:

   $web = Get-SPWeb -Identity http://content.contoso.local
   $library = Get-SPListOrLibrary -Web $web -ListOrLibraryName "Project Documents"
   Set-SPContentTypeOrder -Web $web -ListOrLibraryName $library -ContentTypeNames "Contoso project update", "Contoso project meeting agenda"

.EXAMPLE
   This example removes the 'Document' content type:

   $web = Get-SPWeb -Identity http://content.contoso.local
   $library = Get-SPListOrLibrary -Web $web -ListOrLibraryName "Project Documents"
   Set-SPContentTypeOrder -Web $web -ListOrLibraryName $library -ContentTypeNames "Contoso project update", "Contoso project meeting agenda" -RemoveDocumentContentType
#>
function Set-SPContentTypeOrder
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
        [string]$ListOrLibraryName,

        [Parameter(Mandatory=$true,
                   Position=2)]
        [array]$ContentTypeNames,

        [Parameter(Mandatory=$true,
                   Position=3)]
        [switch]$RemoveDocumentContentType
    )

    Begin
    {
        Start-SPAssignment -Global
        $listObj = $Web.Lists[$ListOrLibraryName]
        $desiredOrder = New-Object System.Collections.Generic.List[Microsoft.SharePoint.SPContentType]
        $currentOrder = $listObj.RootFolder.ContentTypeOrder
    }

    Process
    {
        foreach ($c in $ContentTypeNames)
        {
            $ct = $listObj.ContentTypes[$c]
            $desiredOrder.Add($ct)
        }
        $listObj.RootFolder.UniqueContentTypeOrder = $desiredOrder
        if ($RemoveDocumentContentType)
        {
            $listObj.ContentTypes["Document"].Delete()
            $listObj.Update()
        }
    }

    End
    {
        Stop-SPAssignment -Global
    }
}
