<#
.Synopsis
   Gets a content type
.DESCRIPTION
   Gets a content type
.EXAMPLE
   In this example, the user returns a content type with the name 'Contoso Meeting'

   $web = Get-SPWeb -Identity http://content.contoso.local
   Get-SPContentType -Web $web -Name "Contoso Meeting"

.EXAMPLE
   In this example, the user returns a content type with the name 'Contoso Meeting'

   $web = Get-SPWeb -Identity http://content.contoso.local
   $cType = Get-SPContentType -Web $web -Name "Contoso Meeting"

#>
function Get-SPContentType
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
        [string]$Name
    )

    Begin
    {
        Start-SPAssignment -Global
        $contentTypeObj = $Web.ContentTypes[$Name]
    }

    Process
    {
        if ($contentTypeObj -eq $null)
        {
            Write-Error "Cannot find content type" -RecommendedAction "Check spelling"
        }
        else
        {
            return $contentTypeObj
        }
    }

    End
    {
        Stop-SPAssignment -Global
    }
}
