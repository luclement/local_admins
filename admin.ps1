# Type this before running script: Set-ExecutionPolicy unrestricted

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
if(Test-Path $scriptPath\offline.txt){
    Clear-Content $scriptPath\offline.txt
}

function get-localusers { 
    param( 
        [Parameter(Mandatory=$true,valuefrompipeline=$true)] 
        [string]$strComputer)
    begin {} 
    Process { 
        $path = "$scriptPath\offline.txt"
        $adminlist ="" 
        # $powerlist =""
        $found = $TRUE
        $computer = [ADSI]("WinNT://" + $strComputer + ",computer")
        
        try{
	        $AdminGroup = $computer.psbase.children.find("Administrators") 
            # $powerGroup = $computer.psbase.children.find("Power Users") 
        } catch {
            Write-Host " * " $strComputer "not found." -foregroundcolor "red"
            $strComputer | Out-File -FilePath $scriptPath\offline.txt -Append
            $found = $FALSE
        }
        if($found){
            Write-Host " * " $strComputer
            $Adminmembers= $AdminGroup.psbase.invoke("Members") | %{$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)} 
            # $Powermembers= $PowerGroup.psbase.invoke("Members") | %{$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)} 
            foreach ($admin in $Adminmembers) { 
                if(($admin.CompareTo("Administrator") -ne 0) -and ($admin.CompareTo("Domain Admins") -ne 0) -and ($admin.CompareTo("Computing Services") -ne 0) -and ($admin.CompareTo("Computing Student Admins") -ne 0) -and ($admin.CompareTo("Enterprise Admins") -ne 0)){
                    $adminlist = $adminlist + $admin + ", "
                }
            } 
            # foreach ($poweruser in $Powermembers) { $powerlist = $powerlist + $poweruser + ", " } 
            $Computer = New-Object psobject 
            $computer | Add-Member noteproperty ComputerName $strComputer 
            $computer | Add-Member noteproperty Administrators $adminlist 
            # $computer | Add-Member noteproperty PowerUsers $powerlist 
            Write-Output $computer
        }
        
    } 
    end {} 
} 

Get-Content $scriptPath\computers.txt | get-localusers | Export-Csv $scriptPath\localusers.csv