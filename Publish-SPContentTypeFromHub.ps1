<#
.Synopsis
   Publishes all content types
.DESCRIPTION
   Long description
.EXAMPLE
   Publishes all content types in a group:

   $cth = Get-SPSite -Identity http://content.contoso.local/sites/content-type-hub
   Publish-SPContentTypeFromHub -ctHubUrl $cth -ContentTypeGroupName "Contoso Custom Content Types"

.EXAMPLE
   Another example of how to use this cmdlet
#>
function Publish-SPContentTypeFromHub
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [Microsoft.SharePoint.SPSite]$ctHubUrl,

        [Parameter(Mandatory=$false,
                   Position=1)]
        [string]$ContentTypeGroupName
        
    )

    Begin
    {
        Start-SPAssignment -Global
        $webObj = $ctHubUrl.RootWeb
        $ctColl = $webObj.ContentTypes | where {$_.Group -eq $ContentTypeGroupName}
    }

    Process
    {
        if ([Microsoft.SharePoint.Taxonomy.ContentTypeSync.ContentTypePublisher]::IsContentTypeSharingEnabled($ctHub))
        {
            $ctPublishingObj = New-Object Microsoft.SharePoint.Taxonomy.ContentTypeSync.ContentTypePublisher($ctHub)
            $ctColl | ForEach-Object {
                $ctPublishingObj.Publish($_)
            }
        }
        else
        {
            Write-Error -Message "ctHub object is not a content type hub" -RecommendedAction "Check that you have the correct site collection"
        }
    }
    
    End
    {
        Stop-SPAssignment -Global
    }
}
