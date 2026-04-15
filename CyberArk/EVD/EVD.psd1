@{
    Environments = @{
        Dev  = @{
            ServerName        = '<DEV_SERVER_NAME>'
            Database          = 'CyberArk'
            Port              = 11001
            TrustedServerCert = $true
            ConnectionTimeout = 30
        }
        UAT  = @{
            ServerName        = '<UAT_SERVER_NAME>'
            Database          = 'CyberArk'
            Port              = 11001
            TrustedServerCert = $true
            ConnectionTimeout = 30
        }
        Prod = @{
            ServerName        = '<PROD_SERVER_NAME>'
            Database          = 'CyberArk'
            Port              = 11001
            TrustedServerCert = $true
            ConnectionTimeout = 30
        }
    }
}
