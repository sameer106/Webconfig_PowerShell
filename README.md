# Webconfig_PowerShell
PS to update web.config based on tenant config present in CustomConfig folder

	-> Put the ps script at the root level of your applications.
	-> PS will search for all the web.config files present in all the different folder.
	-> than it will search for CustomConfig folder to fetch the config file which tenant name. ex: 'tenant1.config' 
	-> it will read all the appSettings from tenant1.config and update/add in web.config

Note: PS will do this recursively for the application present under the root directory of pwershell script.
It is very usefull in case you have more than 40 projects and you don't want to do the web.config changes manually to avouid the human error.
And repository will track the config changes for all the tenant present in seprate files under 'CustomConfig' folder.

