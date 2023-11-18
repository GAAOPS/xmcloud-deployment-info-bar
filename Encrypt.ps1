
Param(
    
    [Parameter(
        Mandatory=$True,
        Position=0,
        ValueFromPipeLine=$true
    )]
    [Alias("String")]
    [String]$Phrase,
    
    [Parameter(
        Mandatory=$True,
        Position=1
    )]
    [Alias("Key")]
    [String]$EncryptionKey
)
Write-Host "Make sure you are passing the Phrase param with the single quote '' so the special chars(like $) will be ignored, and use the decrypt.ps1 to test the result" -ForegroundColor Yellow
#create aes key - keep this secure at all times
$aesKey = $EncryptionKey.Split(",")          # example: 20,11,0,4,54,32,144,23,5,3,1,41,36,31,18,175,6,17,1,9,5,1,76,23
 
# convert to secure string object
$Secure = ConvertTo-SecureString -String $Phrase -AsPlainText -Force
 
# store secure object - use output in the decryption process. Could be saved to file.
# remember, the aeskey should remain physically secured
$Encrypted = ConvertFrom-SecureString -SecureString $Secure -Key $aesKey
Write-Host "Encrypted:`n$encrypted`n"