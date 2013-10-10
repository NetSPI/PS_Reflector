#Load all .NET binaries in the folder
Get-ChildItem -recurse "D:\Documents\Visual Studio 2010\Projects\AesSample\AesSample\bin\Debug\"|Where-Object {($_.Extension -EQ ".dll") -or ($_.Extension -eq ".exe")} | ForEach-Object { $AssemblyName=$_.FullName; Try {[Reflection.Assembly]::LoadFile($AssemblyName)} Catch{ "***ERROR*** Not .NET assembly: " + $AssemblyName}}
#Search for private method based on name
$PrivateMethods = [AesSample.AesLibStatic].GetMethods($bindingFlags) | Where-Object Name -eq DecryptStringPrivate
 
 
$PrivateMethods | ForEach-Object{
	$PrivateMethod=$_
	$MethodParams=$PrivateMethod.GetParameters()
	$MemberSignature = $MethodParams | Select -First 1 | Select-Object Member
	#This will list all the method signatures
	$MemberSignature.Member.ToString()
 
	#Choose the correct method based on parameter list
	If ($MemberSignature.Member.ToString() -eq "System.String DecryptStringPrivate(Byte[])"){
		[byte[]]$Bytes =@(70,1,65,70,155,197,95,238,85,79,190,34,158,69,125,233,53,212,111,19,248,209,147,180,19,172,150,25,97,41,127,175)
		[Object[]] $Params=@(,$Bytes)
 
		#Call with the right arguments
		$PrivateMethod.Invoke($null,$Params)
	}
}