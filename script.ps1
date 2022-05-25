<#
    Updated 1 Jan 2022
    !!!Instructions!!!
        - This uses relative path so it mustin the directory storing the incident folder
        - Navigate to the folder inthe commaompt below or programitcally
        - ENSURE all files are closed, could get error from trying to read/edit files that are open
        - This is just a starting point, this function will pull the list of .txt files only
#>
cls

# Returns ID names for all .txt files in '.\Incidents' folder as array of string
function idNameList {

    $fileList = Get-ChildItem ".\Incidents" -Filter *.txt  #-Filter limits the lines returned
    $idList = @()

    foreach ($incident in $fileList) {
        $idList += $incident.Name   #removes the aditional data from the system.io file to provide a list of just .txt es
    }
    #$idList
    return $idList
}

#Demo of what this function returns
$fileList = idNameList
$fileList