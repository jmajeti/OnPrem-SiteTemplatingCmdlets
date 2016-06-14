<#
.Synopsis
   Sets the page layout of a page
.DESCRIPTION
   Use this Cmdlet to change the page layout of a publishing page
.EXAMPLE
   
   $web = Get-SPWeb -Identity "http://content.contoso.local/sites/project-wicked"
   Set-SPPageLayout -Web $web -PageTitle "HomePage" -PageLayoutTitle "Blank Web Part Page"

.EXAMPLE
   Another example of how to use this cmdlet
#>
function Set-SPPageLayout
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [Microsoft.SharePoint.SPWeb]$web,

        [Parameter(Mandatory=$true,
                   Position=1)]
        [string]$PageTitle,

        [Parameter(Mandatory=$true,
                   Position=2)]
        [string]$PageLayoutTitle
    )

    Begin
    {
        Start-SPAssignment -Global
        $publishingSiteObj = New-Object Microsoft.SharePoint.Publishing.PublishingSite($web.Site)
        $publishingWebObj = [Microsoft.SharePoint.Publishing.PublishingWeb]::GetPublishingWeb($web)
        $page = $publishingWebObj.GetPublishingPages() | where {$_.Title -eq $PageTitle}
        $newPageLayout = $publishingWebObj.GetAvailablePageLayouts() | where {$_.Title -eq $PageLayoutTitle}
        $spFileObj = $publishingWebObj.PagesList.GetItems() | where {$_.Title -eq $PageTitle}
    }

    Process
    {
        if ($page.ListItem.File.CheckOutStatus -ne "None")
        {
            $page.CheckIn("Page checked in by template engine.")
        }
        else
        {
            $page.CheckOut()
            $page.Layout = $newPageLayout
            $page.Update()
            $page.CheckIn("Page layout updated by template engine.")
            $page.ListItem.File.Publish("Page layout updated by template engine.")
        }  
    }

    End
    {
        Stop-SPAssignment -Global
    }
}