@ECHO OFF
REM ** This batch file searches though all .MKV files and list any files with tracks 
REM ** (video, audio, subtitles) which do not match the language specified.  If a file 
REM ** has more than one track which meets the search criteria the filename is listed 
REM ** with each individual match.
REM **
REM ** This can be use to find foreign language tracks as well as tracks which have
REM ** not had a language defined.  This is especially useful for finding tracks which
REM ** fail to load as expected in Plex (generally undefined tracks) - tracks can
REM ** be undefined if you forget to set them when creating your .mkv files.
REM **
REM ** This batch file uses DOS commands and the CLI of mkvinfo.exe from MKVToolNix 
REM ** utilities which can be found at: https://mkvtoolnix.download/
REM **
REM ** Execute this batch file from the top level directory from which you 
REM ** want to start the searches.  If the .MKV files are on a server share,
REM ** you will need to map it to a drive letter for this work.

REM ** This will cause variables within a batch file to be expanded at execution time 
REM ** rather than at parse time.  Any variable taking advantage of this needs 
REM ** to be referenced with !variable! not %variable%.
SETLOCAL enabledelayedexpansion

REM ** Define your language setting here.  To get your language code, run mkvinfo.exe
REM ** on a correctly configured MKV file and look for the following entries: 
REM ** (eng is used in this example) "|  + Language: eng"
SET language="eng"

REM ** Define the name of your report file here, remember to use DOS 
REM ** naming conventions i.e. 8.3 characters.
SET logfile="log.txt"

REM ** Define the counters and set them as Zero.
SET /A counter=0
SET /A found=0

REM ** Ensure that the log file is not present at the start.
IF EXIST %logfile% DEL %logfile% > NUL

REM ** Display processing message to screen:
ECHO:
ECHO: Processing... Please Wait...
ECHO:

REM ** Prepare Report Header
ECHO: >> %logfile%
ECHO: This scan was run on %date%, at %time%. >> %logfile%
ECHO:  >> %logfile%
ECHO: List of all .MKV files which have a track within them which is not %language%  >> %logfile%
ECHO: This includes all tracks which are also undefined (i.e. no language assigned). >> %logfile%
ECHO: >> %logfile%

REM ** Start the FOR loop, which will run the commands listed for all .mkv files in 
REM ** the current directory and all sub-directories.
FOR /R %%f IN (*.mkv) DO (

REM ** Display progress to screen. Why?  Because, flashing a cursor on a blank screen 
REM ** is annoying and doesn't give any indication if the process has crashed.
ECHO: Checking: %%f

REM ** Run mkvinfo.exe to display the technical and tag data from the .MKV file.
REM ** We then pipe this output to FIND searching for all lines stating "Language" or "language".
REM ** This is then pipped to FIND to find all lines which don't match to %language%.
REM **
REM ** This process will then send the results into the variable %result%, and it will
REM ** either be "+" (tokens=2) or blank.  If "+" we want to save the .MKV filename, along
REM ** with the language found (tokens=4).

FOR /F "tokens=2,4" %%a IN ('c:\PROGRA~1\MKVToolNix\mkvinfo.exe "%%f" ^| FIND /I "Language" ^| FIND /v %language%') DO (
SET /A found=found+1
SET result=%%a
IF !result!==+ ECHO: %%f : %%b >> %logfile%
)

REM ** Do a count of the amount of files checked.
SET /A counter=counter+1
)

REM ** Make it clear in the log that the process has finished cleanly.
ECHO: >> %logfile%
ECHO: In total !counter! files were scanned, and !found! tracks met the search criteria. >> %logfile%
ECHO: >> %logfile%
ECHO: Process Finished... >> %logfile%

REM ** Exit cleanly.
rem EXIT

REM ** Additional Notes:
REM ** If you ware just checking for mis-labeled languages, and then want to correct 
REM ** the entries, you can use one of the MKVToolNix utilities found at:
REM ** https://mkvtoolnix.download/
REM **
REM ** The command below will update the language to eng (if that is your preference)
REM **
REM ** mkvpropedit.exe <mkv file> --edit track:<track type><track number> --set language=<language>
REM **
REM ** <track type> a = audio, v = video, s = subtitle
REM **
REM ** i.e. mkvpropedit.exe e:\test.mkv --edit track:a1 --set language=eng
