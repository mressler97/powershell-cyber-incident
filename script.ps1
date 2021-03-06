cls

# Returns ID names for all .txt files in '.\Incidents' folder as array of string
function idNameList {

    $fileList = Get-ChildItem ".\Incidents" -Filter *.txt  #-Filter limits the lines returned
    $idList = @()

    foreach ($incident in $fileList) {
        $idList += $incident.Name   #removes the additional data from the system.io file to provide a list of just .txt es
    }
    #$idList
    return $idList
}

#Demo of what this function returns
$fileList = idNameList
#$fileList
$script:ipArray = @()
$script:attacksChina = @()

$script:ongoingAttack = 0
$script:CHsuccessCount = 0
$script:NKsuccessCount = 0
$script:IRsuccessCount = 0

$script:totalDOS = 0
$script:totalPass = 0
$script:totalSQL = 0
$script:totalMITM = 0

$script:totalJRSS = 0
$script:totalNIC = 0
$script:totalSAC = 0

$script:chinafav = ""
$script:nkfav = ""
$script:iranfav = ""

$script:mainArr = @{}
$script:mainArr["status"] = @()
$script:mainArr["endDate"] = @()
$script:mainArr["system"] = @()
$script:mainArr["vector"] = @()
$script:mainArr["source"] = @()

function mainarray (){
    foreach($file in $filelist) {
        foreach ($line in (gc .\Incidents\$file))
            {
                   $endLine = $line.split(":").Trim()

                    if ($endLine[0] -eq "ADDRESS OF SOURCE")
                   {
                        $script:mainArr.source += $endLine[1]

                   }
                    if ($endLine[0] -eq "EQUIPMENT STATUS")
                   {
                        $script:mainArr.status += $endLine[1]

                   }
                    if ($endLine[0] -eq "TYPE OF ATTACK")
                   {
                        $script:mainArr.vector += $endLine[1]

                   }
                    if ($endLine[0] -eq "DTG ATTACK ENDED")
                   {
                        $script:mainArr.endDate += $endLine[1]

                   }
                    if ($endLine[0] -eq "SOFTWARE/SYSTEM AFFECTED")
                   {
                        $script:mainArr.system += $endLine[1]

                   }

            }
    }
}

mainarray
#$script:mainArr

function iranTypes 
{
    $doscounter =0 
    $sqlcounter = 0
    $passcounter = 0 
    $mitmcounter = 0
    $i = 0 
    $iranIPs = @("2.144.63.10", "2.145.187.130", "2.146.30.3", "2.147.201.178", "2.176.68.158", "2.190.69.197", "5.22.192.80", "5.22.200.252", "5.61.25.22", "5.61.25.211", "5.104.211.55", "5.106.1.59", "5.106.217.61", "5.106.33.221", "5.122.174.28")

  foreach ($ip in $script:mainArr.source)
 {
    foreach ($item in $iranIPs)
    {
        if($ip -eq $item)
            {
        if ($script:mainArr.vector[$i] -eq "DOS") {
            $doscounter++    
            }
        if ($script:mainArr.vector[$i] -eq "Password Attack") {
            $passcounter++    
            }
        if ($script:mainArr.vector[$i] -eq "SQL Injection") {
            $sqlcounter++    
            }
        if ($script:mainArr.vector[$i] -eq "MITM") {
            $mitmcounter++    
            }
        }
        $i++
    }
}

  $temparray = @($doscounter, $sqlcounter, $passcounter, $mitmcounter)
  $tempmax = 0
  $max = 0
  $i = 0
    foreach($num in $temparray) {
        $tempmax = $num
        if ($tempmax -gt $max) {
            $max = $tempmax
            if($i -eq 0)
            {
                $script:iranfav = "DOS"
            }
            if($i -eq 1)
            {
                $script:iranfav = "SQL Injection"
            }
            if($i -eq 2)
            {
                $script:iranfav = "Password attack"
            }
            if($i -eq 3)
            {
                $script:iranfav = "MITM"
            }
        }
        $i++
  }
 }
iranTypes


function countChina
{
 $chinaIPs = @("1.0.2.77", "1.0.55.191", "1.1.14.85", "1.2.2.176", "1.4.66.210", "1.45.3.125", "1.45.3.72", "1.49.46.232", "1.69.170.21", "1.180.144.96", "1.188.90.161", "1.202.118.37", "1.207.185.49", "4.78.172.2", "5.183.254.111")
 $counter = 0
 $i = 0
 foreach ($ip in $script:mainArr.source)
 {
    $i++
    foreach ($item in $chinaIPs)
    {
        if($ip -eq $item)
        {
            if (-not($script:mainArr.status[$i] -eq "OPERATIONAL")) {
                $script:CHsuccessCount++
            }
            $counter++
        }
    }
 }
}
countChina


function countNK
{
 $nkIPs = @("175.45.176.5", "175.45.176.24", "175.45.176.130", "175.45.177.205", "175.45.177.109", "175.45.177.219", "175.45.177.196", "175.45.178.88", "175.45.178.49", "175.45.178.139", "175.45.178.37", "175.45.179.196", "175.45.179.91", "175.45.179.168", "175.45.179.214")
 $counter = 0
 $i = 0
 foreach ($ip in $script:mainArr.source)
 {
    $i++
    foreach ($item in $nkIPs)
    {
        if($ip -eq $item)
        {
            if (-not($script:mainArr.status[$i] -eq "OPERATIONAL")) {
                $script:NKsuccessCount++
            }
            $counter++
        }
    }
 }
}
countNK


function countIran
{
 $iranIPs = @("2.144.63.10", "2.145.187.130", "2.146.30.3", "2.147.201.178", "2.176.68.158", "2.190.69.197", "5.22.192.80", "5.22.200.252", "5.61.25.22", "5.61.25.211", "5.104.211.55", "5.106.1.59", "5.106.217.61", "5.106.33.221", "5.122.174.28") 
 $counter = 0
 $i = 0
 foreach ($ip in $script:mainArr.source)
 {
    $i++
    foreach ($item in $iranIPs)
    {
        if($ip -eq $item)
        {
            if (-not($script:mainArr.status[$i] -eq "OPERATIONAL")) {
                $script:IRsuccessCount++
            }
            $counter++
        }
    }
 }
}
countIran



function ongoing 
{
    foreach ($date in $script:mainArr.endDate) 
    {
        if ($date.Contains('3000'))
        {
            $script:ongoingAttack++
        }

    }
}
ongoing 

function chinatypes{
 $doscounter = 0
 $sqlcounter = 0
 $passcounter = 0
 $mitmcounter = 0
 $i = 0
 $chinaIPs = @("1.0.2.77", "1.0.55.191", "1.1.14.85", "1.2.2.176", "1.4.66.210", "1.45.3.125", "1.45.3.72", "1.49.46.232", "1.69.170.21", "1.180.144.96", "1.188.90.161", "1.202.118.37", "1.207.185.49", "4.78.172.2", "5.183.254.111")
 #$chinaIPs
 foreach ($ip in $script:mainArr.source)
 {
    foreach ($item in $chinaIPs)
    {
        if($ip -eq $item)
            {
        if ($script:mainArr.vector[$i] -eq "DOS") {
            $doscounter++    
            }
        if ($script:mainArr.vector[$i] -eq "Password Attack") {
            $passcounter++    
            }
        if ($script:mainArr.vector[$i] -eq "SQL Injection") {
            $sqlcounter++    
            }
        if ($script:mainArr.vector[$i] -eq "MITM") {
            $mitmcounter++    
            }
        }
      $i++
    }
  
 } 

  $temparray = @($doscounter, $sqlcounter, $passcounter, $mitmcounter)
  $tempmax = 0
  $max = 0
  $i = 0
  foreach($num in $temparray) {
        $tempmax = $num
        if ($tempmax -gt $max) {
            $max = $tempmax
            if($i -eq 0)
            {
                $script:chinafav = "DOS"
            }
            if($i -eq 1)
            {
                $script:chinafav = "SQL Injection"
            }
            if($i -eq 2)
            {
                $script:chinafav = "Password attack"
            }
            if($i -eq 3)
            {
                $script:chinafav = "MITM"
            }
        }
        $i++
  }
 }
Chinatypes

function nktypes{
 $doscounter = 0
 $sqlcounter = 0
 $passcounter = 0
 $mitmcounter = 0
 $i = 0
 $nkIPs = @("175.45.176.5", "175.45.176.24", "175.45.176.130", "175.45.177.205", "175.45.177.109", "175.45.177.219", "175.45.177.196", "175.45.178.88", "175.45.178.49", "175.45.178.139", "175.45.178.37", "175.45.179.196", "175.45.179.91", "175.45.179.168", "175.45.179.214")
 foreach ($ip in $script:mainArr.source)
 {
    foreach ($item in $nkIPs)
    {
        if($ip -eq $item)
            {
        if ($script:mainArr.vector[$i] -eq "DOS") {
            $doscounter++    
            }
        if ($script:mainArr.vector[$i] -eq "Password Attack") {
            $passcounter++    
            }
        if ($script:mainArr.vector[$i] -eq "SQL Injection") {
            $sqlcounter++    
            }
        if ($script:mainArr.vector[$i] -eq "MITM") {
            $mitmcounter++    
            }
        }
      $i++
    }
  
 } 
  $temparray = @($doscounter, $sqlcounter, $passcounter, $mitmcounter)
  $tempmax = 0
  $max = 0
  $i = 0
  foreach($num in $temparray) {
        $tempmax = $num
        if ($tempmax -gt $max) {
            $max = $tempmax
            if($i -eq 0)
            {
                $script:nkfav = "DOS"
            }
            if($i -eq 1)
            {
                $script:nkfav = "SQL Injection"
            }
            if($i -eq 2)
            {
                $script:nkfav = "Password attack"
            }
            if($i -eq 3)
            {
                $script:nkfav = "MITM"
            }
        }
        $i++
  }

 }
nktypes


function countByType 
{
 $i = 0
    foreach ($item in $script:mainArr.status)
    {
        if (-not($script:mainArr.status[$i] -eq "OPERATIONAL")) {
            if ($script:mainArr.vector[$i] -eq "DOS") {
                $script:totalDOS++    
            }
            if ($script:mainArr.vector[$i] -eq "Password attack") {
                $script:totalPass++    
            }
            if ($script:mainArr.vector[$i] -eq "SQL Injection") {
                $script:totalSQL++    
            }
            if ($script:mainArr.vector[$i] -eq "MITM") {
                $script:totalMITM++    
            }
        }
        $i++
    }
}
countByType

function countBySystem 
{
 $i = 0
    foreach ($item in $script:mainArr.status)
    {
        if (-not($script:mainArr.status[$i] -eq "OPERATIONAL")) {
            if ($script:mainArr.system[$i] -eq "JRSS networks") {
                $script:totalJRSS++    
            }
            if ($script:mainArr.system[$i] -eq "DoD Network Information Center") {
                $script:totalNIC++    
            }
            if ($script:mainArr.system[$i] -eq "DLA Systems Automation Center") {
                $script:totalSAC++    
            }
        }
        $i++
    }
}
countBySystem


function print() {
    $totalsuccess = [int]$script:CHsuccessCount + [int]$script:NKsuccessCount + [int]$script:IRsuccessCount 
    $rate = ($totalsuccess)/($script:mainArr.vector.Length)*100
    write-output("Overall successful attacks: $totalsuccess")
    write-output("Overall successful attack rate: $rate")
    write-output("`nMost frequently used attack by nation state`n-------------------------------------------`n")
    write-host("China: $script:chinafav")
    write-host("North Korea: $script:nkfav")
    write-host("Iran: $script:iranfav")
    write-output("`nSuccessful attacks by nation state`n-------------------------------------------`n")
    write-host("China: $script:CHsuccessCount")
    write-host("North Korea: $script:NKsuccessCount")
    write-host("Iran: $script:IRsuccessCount")

    write-output("`nSuccessful attacks by vector`n-------------------------------------------`n")
    write-output("DOS: $script:totalDOS")
    write-output("Password attack: $script:totalPass")
    write-output("SQL Injection: $script:totalSQL")
    write-output("Man in the Middle: $script:totalMITM")
    write-output("`nSuccessful attacks by system`n-------------------------------------------`n")
    write-output("JRSS networks: $script:totalJRSS")
    write-output("DOD network information center: $script:totalNIC")
    write-output("DLA systems automation center: $script:totalSAC")

    write-output("`nOngoing Attacks`n-------------------------------------------`n")
    write-output("$script:ongoingAttack attacks")
}

print
$Null > report.txt
print > report.txt





