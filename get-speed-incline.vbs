
'to debug - enable wscript.echo and run by cscript in command line
'on error resume next 

'initialize
dim arrfilelines()

'create html page
set fsohtml = createobject("scripting.filesystemobject")

'launch edge
set wso = createobject("wscript.shell")
wso.run "msedge file:///C:/Temp/treadmill.html --edge-kiosk-type=public-browsing"

'construct wolflog filename
dy = right(string(2,"0") & day(now), 2)
mo = right(string(2,"0") & month(now), 2)
yr = year(now)
infilename = yr & "-" & mo & "-" & dy & "_logs.txt"
infilename2 = "/sdcard/.wolflogs/" & infilename
'wscript.echo infilename2

oldspeed = "-1"
oldincline = "-1"

'loop - get wolflog and process
do

  'pull wolflog
  cmdstring = "adb pull " & infilename2
  'wscript.echo cmdstring 
  set oexec = wso.exec("cmd /c " & cmdstring)

  'wait until pull complete
  wscript.sleep 1500

  'open wolflog
  set fso = createobject("scripting.filesystemobject")
  fullpath = fso.getabsolutepathname(infilename)
  'wscript.echo fullpath

  if fso.fileexists(fullpath) then

    'write html page
    set htmlfile = fsohtml.createtextfile("c:\temp\treadmill.html",true)
    htmlfile.writeline("<html>")
    htmlfile.writeline("<head>")
    htmlfile.writeline("<title>NordicTrack C2950 Treadmill</title>")
    htmlfile.writeline("</head>")
    htmlfile.writeline("<body>")

    'read wolflog from bottom up into array
    Set f = fso.opentextfile(fullpath)
    i = 0
    do until f.atendofstream
      redim preserve arrfilelines(i)
      arrfilelines(i) = f.readline
      i = i + 1
    loop
    f.close

    'process wolflog array
    sstat = false
    istat = false

    for l = ubound(arrfilelines) to lbound(arrfilelines) step -1

      'get latest speed
      if not (sstat) and (instr(arrfilelines(l),"[Trace:FitPro] Changed KPH to: ")) <> 0 then
        instart = instr(arrfilelines(l),"[Trace:FitPro] Changed KPH to: ")
        speed = mid(arrfilelines(l),instart + 31)
        if csng(speed) <> csng(oldspeed) then
          'wscript.echo "Speed: " & formatnumber(csng(speed),1)
          htmlfile.writeline("<p><span style=""font-size:32px"">" & "Speed: " & formatnumber(csng(speed),1) & "</span></p>")
          htmlfile.writeline("<p></p>")
          oldspeed = speed
        else
          'wscript.echo "Speed: " & formatnumber(csng(oldspeed),1)
          htmlfile.writeline("<p><span style=""font-size:32px"">" & "Speed: " & formatnumber(csng(oldspeed),1) & "</span></p>")
          htmlfile.writeline("<p></p>")
        end if
        sstat = true
      end if

    next

    for l = ubound(arrfilelines) to lbound(arrfilelines) step -1

      'get latest incline
      if not (istat) and (instr(arrfilelines(l),"[Trace:FitPro] Changed Grade to: ")) <> 0 then
        instart = instr(arrfilelines(l),"[Trace:FitPro] Changed Grade to: ")
        incline = mid(arrfilelines(l),instart + 33)
        if csng(incline) <> csng(oldincline) then
          'wscript.echo "Incline: " & formatnumber(csng(incline),1)
          htmlfile.writeline("<p><span style=""font-size:32px"">" & "Incline: " & formatnumber(csng(incline),1) & "</span></p>")
          oldincline = incline
        else
          'wscript.echo "Incline: " & formatnumber(csng(oldincline),1)
          htmlfile.writeline("<p><span style=""font-size:32px"">" & "Incline: " & formatnumber(csng(oldincline),1) & "</span></p>")
          htmlfile.writeline("<p></p>")
        end if
        istat = true
      end if

    next

    'finish html page and refresh
    htmlfile.writeline("</body>")
    htmlfile.writeline("</html>")
    htmlfile.close
    wso.sendkeys "{F5}" 

  else
    wscript.echo infilename & " was not found"
  end if

loop









