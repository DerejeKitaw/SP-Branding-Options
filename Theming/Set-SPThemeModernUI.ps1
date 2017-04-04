<#
.REQUIREMENTS
Requires PnP-PowerShell version 2.7.1609.3 or later
https://github.com/OfficeDev/PnP-PowerShell/releasess

Based on article:
https://msdn.microsoft.com/en-us/pnp_articles/modern-experience-customizations-customize-sites

.SYNOPSIS
Set a custom theme for a specific web. 

.EXAMPLE
PS C:\> .\Set-SPThemeModernUI.ps1 -TargetWebUrl "https://intranet.mydomain.com/sites/targetSite/marketing"

.EXAMPLE
PS C:\> $creds = Get-Credential
PS C:\> .\Set-SPTheme.ps1 -TargetWebUrl "https://intranet.mydomain.com/sites/targetSite" -Credentials $creds
#>

[CmdletBinding()]
param
(
    [Parameter(Mandatory = $true, HelpMessage="Enter the URL of the target web, e.g. 'https://intranet.mydomain.com/sites/targetWeb'")]
    [String]
    $targetWebUrl,

    [Parameter(Mandatory = $false, HelpMessage="Optional administration credentials")]
    [PSCredential]
    $Credentials
)

if($Credentials -eq $null)
{
	$Credentials = Get-Credential -Message "Enter Admin Credentials"
}
$targetSiteUrl = $targetWebUrl

Write-Host -ForegroundColor White "--------------------------------------------------------"
Write-Host -ForegroundColor White "|                   Set Custom Theme                   |"
Write-Host -ForegroundColor White "--------------------------------------------------------"
Write-Host ""
Write-Host -ForegroundColor Yellow "Target web: $($targetWebUrl)"
Write-Host -ForegroundColor Yellow "Target asset location : $($targetSiteUrl)"
Write-Host ""

try
{
	Connect-PnPOnline $targetSiteUrl -Credentials $Credentials

	Write-Host -ForegroundColor White "Provisioning asset files to $($targetSiteUrl)"

	Add-PnPFile -Path .\custom.theme.spcolor -Folder SiteAssets
	Add-PnPFile -Path .\custom.theme.bg.jpg -Folder SiteAssets

	$web = Get-PnPWeb
	$colorPaletteUrl = $web.ServerRelativeUrl + "/SiteAssets/custom.theme.spcolor"
	$bgImageUrl = $web.ServerRelativeUrl + "/SiteAssets/custom.theme.bg.jpg
	
	https://pixelmill.sharepoint.com/sites/demopnpprovisioning/SiteAssets/custom.theme.bg.jpg"

	Write-Host -ForegroundColor White "Setting theme for $($targetWebUrl)"

	#https://github.com/OfficeDev/PnP-PowerShell/blob/master/Documentation/SetSPOTheme.md
	#Set-PnPTheme -ColorPaletteUrl $colorPaletteUrl -BackgroundImageUrl $bgImageUrl

	$web.ApplyTheme($colorPaletteUrl, [NullString]::Value, $bgImageUrl, $true)
	$web.Update()


	Write-Host ""
	Write-Host -ForegroundColor Green "Theme applied"
}
catch
{
    Write-Host -ForegroundColor Red "Exception occurred!" 
    Write-Host -ForegroundColor Red "Exception Type: $($_.Exception.GetType().FullName)"
    Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
}