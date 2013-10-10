$Results=@()
Get-ChildItem -recurse "D:\Documents\Visual Studio 2010\Projects\AesSample\AesSample\bin\Debug\"|
Where-Object {	($_.Extension -EQ ".dll") -or ($_.Extension -eq ".exe")} | 
ForEach-Object {
		$AssemblyName= $_.FullName; try {$Assembly = [Reflection.Assembly]::LoadFile($AssemblyName);} catch{ "***ERROR*** Error when loading assembly: " +  $AssemblyName} $Assembly | Format-Table; $Assembly.GetTypes() |
		%{
			$Type=$_;$_.GetMembers() | Where-Object {$_.MemberType -eq "Constructor"-or $_.MemberType -EQ "Method" } | 
			%{
				$ObjectProperties = @{	'Assembly' = $AssemblyName;
										'ClassName' = $Type.Name;
										'ClassPublic' = $Type.IsPublic;
										'ClassStatic' = $Type.IsAbstract -and $Type.IsSealed;
										'MemberType' = $_.MemberType;
										'Member' = $_.ToString();
										'Changed' = $Changed;
										'MemberPublic' = $_.IsPublic;
										'MemberStatic' =$_.IsStatic;
													}
					$ResultsObject = New-Object -TypeName PSObject -Property $ObjectProperties
					$Results+=$ResultsObject
				}
			}
}
$Results | Select-Object Assembly,ClassPublic,ClassStatic,ClassName,MemberType,Member,MemberPublic,MemberStatic |  Sort-Object Assembly,ClassName,MemberType,Member| Out-GridView -Title "Reflection"
