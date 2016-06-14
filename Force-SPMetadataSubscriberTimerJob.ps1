<#
.Synopsis
   Forces timer job responsible for distributing content type changes to site collections
.DESCRIPTION
   Long description
.EXAMPLE
   Force-SPMetadataSubscriberTimerJob -WebApplicationUrl "http://content.contoso.local"
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Force-SPMetadataSubscriberTimerJob
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   Position=0)]
        [string]$WebApplicationUrl
    )

    Begin
    {
        Start-SPAssignment -Global
    }

    Process
    {
        $ctHubTJ = Get-SPTimerJob "MetadataSubscriberTimerJob" -WebApplication $WebApplicationUrl
        $ctHubTJ.RunNow()
    }

    End
    {
        Stop-SPAssignment -Global
    }
}
