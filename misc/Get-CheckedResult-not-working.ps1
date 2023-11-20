# This method is not wroking when the scheduled tasks run, it looks like the cache created by cachemanger GetNamedInstance will be deleted after few minutes, so every time it will be recreated and you will see the [Deployment-Get-CachedResult] Cashe is recreated in the logs 
Function Get-CachedResult {
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $Key,
        [ScriptBlock]
        $ScriptBlock,
        [switch] $Reset,
        $cachExpSeconds = 1230
    )
    $CACHE_VARIABLE_NAME = "SPE_Scripting_Cache"
    $cache = [Sitecore.Caching.CacheManager].GetMethod('FindCacheByName').MakeGenericMethod([System.String]).Invoke($null, $CACHE_VARIABLE_NAME)
    if(-not $cache){
        $cacheSize = [Sitecore.StringUtil]::ParseSizeString("100KB")
        $cache = [Sitecore.Caching.CacheManager]::GetNamedInstance($CACHE_VARIABLE_NAME, $cacheSize, $true);
        $cache.Scavengable = $false;
        Write-Log "[Deployment-Get-CachedResult] Cashe is recreated"
    }
    $cachedValue = $cache.GetEntry($Key).Data
    if ($cachedValue -and (-not $Reset)) {
        return $cachedValue
    }
    try {
        if(-not $ScriptBlock){
            return $null
        }

        $cachedValue = &$ScriptBlock
        if ($null -ne $cachedValue) {
            $date = Get-Date
            $exp = $date.AddSeconds($cachExpSeconds)
            Write-Log "[Deployment-Get-CachedResult] Adding $Key with exp: $cachExpSeconds"
            $cache.Add($Key, $cachedValue, $exp) | Out-Null 
        }
    }
    catch {
        Write-Log "[Deployment-Get-CachedResult] Executing script failed. $($_)" -Log Error
    } 

    $cachedValue
}