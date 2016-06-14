<#
.Synopsis
   Set-SPHomePage
.DESCRIPTION
   Sets the home page of a SharePoint web.
.EXAMPLE
    $web = Get-SPWeb -Identity http://content.contoso.local/sites/project-a
    $page = "Pages/Contoso.aspx"
    Set-SPHomePage -Web $web -HomePage $page
       
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Set-SPHomePage
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
        [string]$HomePage
    )

    Begin
    {
        Start-SPAssignment -Global
        $rootFolder = $Web.RootFolder
        $rootFolder.WelcomePage = $HomePage
    }

    Process
    {
        $rootFolder.Update()
    }

    End
    {
        Stop-SPAssignment -Global
    }
}