' Called from windows command line like this:
'   > Cscript.exe getWebFile1.vbs "http://www.cygwin.com/setup.exe" "C:\cygwin\setup.exe"

' Get the command line arguments
    Set objArgs = WScript.Arguments

' Set your settings
    strFileURL = objArgs(0)
    strHDLocation = objArgs(1)
    'strHDLocation = "C:\Temp\cygwin_setup.exe"

' Fetch the file
    Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP")

    objXMLHTTP.open "GET", strFileURL, false
    objXMLHTTP.send()

If objXMLHTTP.Status = 200 Then
Set objADOStream = CreateObject("ADODB.Stream")
objADOStream.Open
objADOStream.Type = 1 'adTypeBinary

objADOStream.Write objXMLHTTP.ResponseBody
objADOStream.Position = 0    'Set the stream position to the start

Set objFSO = Createobject("Scripting.FileSystemObject")
If objFSO.Fileexists(strHDLocation) Then objFSO.DeleteFile strHDLocation
Set objFSO = Nothing

objADOStream.SaveToFile strHDLocation
objADOStream.Close
Set objADOStream = Nothing
End if

Set objXMLHTTP = Nothing

