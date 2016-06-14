<#
.Synopsis
   Creates a new publishing page
.DESCRIPTION
   Creates a new publishing page
.EXAMPLE
   $web = Get-SPWeb -Identity "http://content.contoso.local/sites/project-awesome"

   New-SPPage -Web $web -PageLayoutTitle "Blank web part page" -PageTitle "Project-Launch"

   This will create a new publishing page titled 'project-launch.aspx' 
.EXAMPLE
   Another example of how to use this cmdlet
#>
function New-SPPage
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [Microsoft.SharePoint.SPWeb]$Web,

        [Parameter(Mandatory=$true,
                   Position=1)]
        [string]$PageLayoutTitle,

        [Parameter(Mandatory=$true,
                   Position=2)]
        [string]$PageTitle
    )

    Begin
    {
        Start-SPAssignment -Global
        $pubWebObj = [Microsoft.SharePoint.Publishing.PublishingWeb]::GetPublishingWeb($Web)
        $pageLayoutObj = $pubWebObj.GetAvailablePageLayouts() | where {$_.Title -eq $PageLayoutTitle}
        $newPageTitle = $PageTitle + ".aspx"
    }

    Process
    {
        $page = $pubWebObj.AddPublishingPage($newPageTitle, $pageLayoutObj)
        $page.Title = $PageTitle
        $page.Update()
        $page.CheckIn("Page created by template engine.")
        $page.ListItem.File.Publish("Page published by template engine.")
    }

    End
    {
        Stop-SPAssignment -Global
    }
}