$RGName = 'RS06UE2DInformationPlatform-RG01'
$Location = 'East US 2'
$keyVaultName = 'devhditest'
 
Import-Csv -Path /home/rajat/sample.csv -delimiter "," | ForEach-Object {
 
 
$secret = Get-AzKeyVaultSecret -VaultName $keyVaultName -Name $_.SecretName;
$name = $secret.Name;
$b = Write-Output $secret.SecretValue;
if($b -ne $null)
{
$StandardString = ConvertFrom-SecureString -AsPlainText $b;
 
if( $name -eq $_.SecretName -and $StandardString -eq $_.secretvalue)
{
 Write-Output "SECRET ALREADY EXISTS"
}
elseif($name -eq $_.SecretName -and $StandardString -ne $_.secretvalue)
{
 Remove-AzKeyVaultSecret -vaultname $keyVaultName -name $_.SecretName -Force -PassThru 
 
 Remove-AzKeyVaultSecret -vaultname $keyVaultName -name $_.SecretName -InRemovedState -Force -PassThru 
 
$secret = ConvertTo-SecureString -string $_.secretvalue -asplaintext -force 
 
 set-azkeyvaultsecret -vaultname $keyVaultName -Name $_.SecretName -secretvalue $secret
 Write-Output "UPDATING SECRET VALUE"
}
}
else{
$secret1 = ConvertTo-SecureString -string $_.secretvalue -asplaintext -force
 set-azkeyvaultsecret -vaultname $keyVaultName -name $_.SecretName -secretvalue $secret1
 Write-Output "NEW SECRET ADDED"
}
}
 
# Import-Csv -Path /home/rajat/sample1.csv -delimiter "," | ForEach-Object {
# $key = Get-AzKeyVaultKey -VaultName $keyVaultName
# if( $key.Name -eq $_.KeyName )
# {
# Write-Output "exists" 
# }
# else{
# Add-AzKeyVaultKey -VaultName $keyVaultName -Name $_.KeyName -Destination 'Software'
# }
# }
