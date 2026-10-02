Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
Dim sDir, sRoot, sPython, sScript
sDir = Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\"))
sRoot = fso.GetParentFolderName(Left(sDir, Len(sDir) - 1))
sPython = sRoot & "\W64\Python\python.exe"
sScript = sDir & "fix_paths.py"
WshShell.Run Chr(34) & sPython & Chr(34) & " " & Chr(34) & sScript & Chr(34) & " " & Chr(34) & sRoot & Chr(34), 0, True
