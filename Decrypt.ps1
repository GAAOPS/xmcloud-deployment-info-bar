Param(
    
    [Parameter(
        Mandatory=$True,
        Position=0,
        ValueFromPipeLine=$true
    )]
    [Alias("String")]
    [String]$Encrypted,
    
    [Parameter(
        Mandatory=$True,
        Position=1
    )]
    [Alias("Key")]
    [String]$EncryptionKey
)

$aesKey = $EncryptionKey.Split(",")          # example: 20,11,0,4,54,32,144,23,5,3,1,41,36,31,18,175,6,17,1,9,5,1,76,23
# create new object using $encrypted and $aeskey
$secureObject = ConvertTo-SecureString -String $Encrypted -Key $aesKey
 
# perform decryption from secure object
$decrypted = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureObject)
$decrypted = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($decrypted)

Write-Host "Encrypted:`n$decrypted`n"