[CmdletBinding()]
param (
[Parameter(Mandatory = $true)]
[String] $tenant)


# swap a key/value in AppSettings
Function swapAppSetting {
  param([string]$key,[string]$value )
  $obj = $doc.configuration.appSettings.add | where {$_.Key -eq $key }
  
	 #Update node value if exist else add the node 
	  if($obj.value)
	  {
		$obj.value = $value
	  }else
	  {
		AddAppSetting $key $value
	  }
  
}

Function AddAppSetting {
	param([string]$key,[string]$value )
	$newEl=$doc.CreateElement("add");                               # Create a new Element 
    $nameAtt1=$doc.CreateAttribute("key");                         # Create a new attribute "key" 
    $nameAtt1.psbase.value=$key				  ;                    # Set the value of "key" attribute 
    $newEl.SetAttributeNode($nameAtt1);                              # Attach the "key" attribute 
    $nameAtt2=$doc.CreateAttribute("value");                       # Create "value" attribute  
    $nameAtt2.psbase.value=$value;                       # Set the value of "value" attribute 
    $newEl.SetAttributeNode($nameAtt2);                               # Attach the "value" attribute 
    $doc.configuration.appSettings.AppendChild($newEl);    # Add the newly created element to the right position
}

#get all the path in which web.config exists
$configFiles = dir -Path $PSScriptRoot -Filter web.config -Recurse | %{$_.FullName}

foreach($configfile in $configFiles)
{
	#$configfile
	#$webConfig = "web.config"
	if  (-not (Test-Path $configfile)) {
		Write-Host 'file not found:' $configfile
	}else{
		Write-Host 'Read config file at path: ' $configfile
		$doc = [Xml](Get-Content $configfile)
	}

	$parentPath = Split-Path -parent $configfile
	#$parentPath
	$config = $parentPath +"\CustomConfig\"+ $tenant +".config"

	#$config
	if  (-not (Test-Path $config)) {
		Write-Host 'file not found:'  $config
	}else{
		Write-Host 'Read config file at path: ' $config
		$docappSetting = [Xml] (Get-Content $config)
	}
	


	$obj2 = $docappSetting.configuration.appSettings.add

	swapAppSetting 'tenant' $tenant	  							#to identify the configuration generated for which particular "tenant"
	foreach($node in $obj2)
	{
		swapAppSetting $node.key $node.value
	}

	$doc.Save($configfile)
}
