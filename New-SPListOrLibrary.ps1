<#
.Synopsis
    Creates a new document library or custom/ generic list
.DESCRIPTION
    Creates a new document library or custom/ generic list
.EXAMPLE
    In this example, a document library is created

    $web = Get-SPWeb -Identity http://content.contoso.local/sites/project-x
    New-SPListOrLibrary -Web $web -Name "Project Docs" -Description "Project documentation" -AsDocumentLibrary
.EXAMPLE
    In this example, a generic list is created

    $web = Get-SPList -Identity http://content.contoso.local/sites/project-x
    New-SPListOrLibrary -Web $web -Name "Project Expenses" -Description "Project Expenses" -AsList
#>
function New-SPListOrLibrary
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
        [string]$Name,

        [Parameter(Mandatory=$true,
                    Position=2)]
        [string]$Description,

        [Parameter(Mandatory=$false,
                    Position=3)]
        [switch]$AsDocumentLibrary,

        [Parameter(Mandatory=$false,
                    Position=4)]
        [switch]$AsList
    )
    
    Begin
    {
        Start-SPAssignment -Global
        $webObj = $Web
        $ListTemplate = [Microsoft.SharePoint.SPListTemplateType]::GenericList
        $LibraryTemplate = [Microsoft.SharePoint.SPListTemplateType]::DocumentLibrary
    }

    Process
    {
        if($webObj.Lists[$Name] -ne $null)
        {
            Write-Error "Cannot continue, list or library name already exists in this web" -RecommendedAction "Change the name of the list or library that you are requesting"
        }
        else
        {
            if ($AsDocumentLibrary)
            {
                $webObj.Lists.Add($Name, $Description, $LibraryTemplate)        
            }
            else 
            {
                $webObj.Lists.Add($Name, $Description, $ListTemplate)
            }
        }
    }

    End
    {
        Stop-SPAssignment -Global
    }
}
