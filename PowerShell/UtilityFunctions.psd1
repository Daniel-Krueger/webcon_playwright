@{
    ModuleVersion = '1.0'
    GUID = '44B65504-7FA6-4D59-9596-A1BD3351FC36'
    Author = 'Your Name'
    Description = 'Description of your module'

    # Dependencies
    RequiredModules = @(
        @{
            ModuleName = 'ClassesWebcon'
            Guid = '9716C5F8-6C46-4C0C-BE5D-43B1684A9A32'  # GUID of the module
            ModuleVersion = '1.0.0.0'  # Version of the module            
        },
        @{
            ModuleName = 'ClassesFormDataGeneration'
            Guid = 'F9E2C574-CBAF-4BF3-AFB7-EF3A0FAD9D1C'
            ModuleVersion = '1.0.0.0'
        }
    )

    # Other manifest properties...
}