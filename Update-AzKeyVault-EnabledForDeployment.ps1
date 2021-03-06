$subs = @( "subid"
    )
    
    foreach ($sub in $subs) {

        $subName = az account show -s $sub --query name -o tsv
        Write-Output "Setting context to $subName"
        az account set -s $sub
        az account show -o table

        $keyVaults = az keyvault list --query "[?starts_with(name, 'kvd-')] || [?starts_with(name, 'kvp-')] || [?starts_with(name, 'kvs-')] || [?starts_with(name, 'kvt-')]" | ConvertFrom-Json

        foreach ($keyVault in $keyVaults) {
            Write-Output "Updating $($keyVault.name) in $($keyVault.resourceGroup)"
            $result = az keyvault update --enabled-for-deployment true --name $keyVault.name | ConvertFrom-Json
            Write-Output "Enabled for Deployment on $($result.name) is set to $($result.properties.enabledForDeployment)"
        }
    }
