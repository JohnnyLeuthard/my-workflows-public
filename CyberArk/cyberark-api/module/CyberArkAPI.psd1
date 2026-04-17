#
# Module manifest for CyberArkAPI
#
@{
    # Module metadata
    ModuleVersion     = '0.1.0'
    GUID              = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'   # Replace with: [System.Guid]::NewGuid()
    Author            = 'CyberArk Ops'
    Description       = 'Direct REST API module for CyberArk PVWA. Provides PowerShell advanced functions that wrap PVWA REST endpoints without requiring the psPAS module.'
    PowerShellVersion = '5.1'

    # Entry point
    RootModule        = 'CyberArkAPI.psm1'

    # Exports — the .psm1 handles dynamic export at load time.
    # Set to '*' here; the psm1 calls Export-ModuleMember with the actual function list.
    FunctionsToExport = '*'
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()

    # Private data
    PrivateData = @{
        PSData = @{
            Tags         = @('CyberArk', 'PAM', 'REST', 'API', 'PVWA')
            ProjectUri   = ''
            ReleaseNotes = '0.1.0 — Initial scaffold. No functions yet.'
        }
    }
}
