<#
.Synopsis
   Enables the publishing features on both the target web and its parent site collection.
.DESCRIPTION
   Enables the publishing features on both the target web and its parent site collection.
.EXAMPLE
   
   $webSite = Get-SPWeb -Identity http://content.contoso.local/sites/project-y
   Enable-SPPublishingFeature -Web $webSite

.EXAMPLE

#>
function Enable-SPPublishingFeature
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [Microsoft.SharePoint.SPWeb]$Web
    )

    Begin
    {
        Start-SPAssignment -Global
        $parentSiteObj = $Web.Site
    }

    Process
    {
        Enable-SPFeature "PublishingSite" -Url $parentSiteObj.Url
        Enable-SPFeature "PublishingWeb" -Url $Web.Url   
    }

    End
    {
        Stop-SPAssignment -Global
    }
}
