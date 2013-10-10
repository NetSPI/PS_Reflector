#Load all .NET binaries in the folder
Get-ChildItem -recurse "D:\Documents\Visual Studio 2010\Projects\AesSample\AesSample\bin\Debug\"|Where-Object {($_.Extension -EQ ".dll") -or ($_.Extension -eq ".exe")} | ForEach-Object { $AssemblyName=$_.FullName; Try {[Reflection.Assembly]::LoadFile($AssemblyName)} Catch{ "***ERROR*** Not .NET assembly: " + $AssemblyName}}
#Call constructor
$Instance= New-Object "AesSample.AesLib" ("a","b")
 
# Find private nonstatic method. If you want to invoke static private method, replace Instance with Static
$BindingFlags= [Reflection.BindingFlags] "NonPublic,Instance"
 
$Instance.GetType().GetMethods($BindingFlags) |  Where-Object Name -eq DecryptStringPrivate| ForEach-Object{
	$PrivateMethod=$_
	$MethodParams=$PrivateMethod.GetParameters() 
	$MemberSignature = $MethodParams | Select -First 1 | Select-Object Member
	$MemberSignature.Member.ToString()
	If ($MemberSignature.Member.ToString() -eq "System.String DecryptStringPrivate(Byte[])"){
		[byte[]]$Bytes =@(70,1,65,70,155,197,95,238,85,79,190,34,158,69,125,233,53,212,111,19,248,209,147,180,19,172,150,25,97,41,127,175)
		[Object[]] $Params=@(,$Bytes)
 
		# You will need to pass the Instance here instead of $null
		$PrivateMethod.Invoke($Instance,$Params)
	}
 }