class WEBCONConfig {
    [string]$ClientId
    [string]$ClientSecret
    [string]$Hostname
    [string]$ApiVersion   
    
    [void]UpdateFromConfig([WEBCONConfig] $config) {
        $this.ClientId = $config.ClientId
        $this.ClientSecret = $config.ClientSecret
        $this.Hostname = $config.Hostname
        $this.ApiVersion = $config.ApiVersion
    }
}
