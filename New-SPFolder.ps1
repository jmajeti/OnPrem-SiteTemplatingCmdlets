<#
.Synopsis
   Adds a folder to an existing document library.
.DESCRIPTION
   Adds a folder to an existing document library.
.EXAMPLE
   The example below creates three folders in a document library:

   $webSite = Get-SPWeb -Identity "http://content.contoso.local"
   $list = Get-SPListOrLibrary -Web $webSite -ListOrLibraryName "Project Documentation"

   New-SPFolder -ListOrLibrary $list -FolderName "Project Risks"
   New-SPFolder -ListOrLibrary $list -FolderName "Project Issues"
   New-SPFolder -ListOrLibrary $list -FolderName "Project Meetings"
#>
function New-SPFolder
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
        [string]$FolderName
    )

    Begin
    {
        Start-SPAssignment -Global
    }

    Process
    {
        $ListOrLibrary.EnableFolderCreation = $true
        $ListOrLibrary.Update()
        $folderObj = $ListOrLibrary.AddItem("", [Microsoft.SharePoint.SPFileSystemObjectType]::Folder, $FolderName)
        $folderObj["Title"] = $FolderName
        $folderObj.Update()
    }

    End 
    {
        Stop-SPAssignment -Global
    }
}
