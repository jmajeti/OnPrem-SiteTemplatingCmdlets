<#
.Synopsis
   Adds a content type to an existing document library.
.DESCRIPTION
   Adds a content type to an existing document library.
.EXAMPLE
   Adds the content type 'Contoso Meeting' to a document library called 'Test DocLib1':
   
   Add-SPContentType -WebUrl http://content.contoso.local -ListOrLibraryName "Test Doclib1" -ContentTypeName "Contoso Meeting"
#>

function Add-SPContentType
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
                   Position=3)]
        [string]$ContentTypeName
    )
    
    Begin 
    {
        Start-SPAssignment -Global
        $listObj = $Web.Lists[$ListOrLibraryName]
        $contentTypeObj = $Web.ContentTypes[$ContentTypeName]
    }

    Process
    {
        if ($listObj -eq $null)
        {
            Write-Error "Cannot find list or library, cannot continue" -RecommendedAction "Check spelling and check list exists"
        }
        if ($listObj.ContentTypesEnabled -ne $true)
        {
            $listObj.ContentTypesEnabled = $true
            $listObj.Update()
        }
        if ($contentTypeObj -eq $null)
        {
            Write-Error "Cannot find content type, cannot continue" -RecommendedAction "Check content type exists in site collection"
        }
        else
        {
            $listObj.ContentTypes.Add($contentTypeObj)
            $listObj.Update()
        }
    }

    End
    {
        Stop-SPAssignment -Global
    }
}
