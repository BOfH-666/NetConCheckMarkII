

function ConvertTo-TransposedData($InputData, $PrimaryKey, $Label) {
    # transposing labels
    $propertyList = 
    $InputData."$PrimaryKey" | 
    Select-Object -unique
    $nameList = 
    (
        $InputData | 
        Select-Object -First 1 | 
        Get-Member -MemberType NoteProperty | 
        Where-Object { $_.Name -ne $PrimaryKey }
    ).Name
    # transposing data
    foreach ($Name in $nameList) {
        $row = [ordered]@{}
        foreach ($property in $propertyList) {
            $row."$Label" = $Name
            $row."$property" = $InputData | Where-Object { $_."$PrimaryKey" -eq "$property" } | ForEach-Object { $_."$Name" }
        }
        New-Object -TypeName psobject -Property $row
    }
}
