# mkv-track-language-checker
This batch file searches though all .MKV files and list any files with tracks (video, audio, subtitles) which do not match the language specified. 

If a file.MKV has more than one track which meets the search criteria the filename is listed with each individual match.

This canbatch file be use to find foreign language tracks as well as tracks which have not had a language defined (called undefined).  This is especially useful for finding tracks which fail to load as expected in Plex (generally undefined tracks) - tracks can be undefined if you forget to set them when creating your .mkv files.

This batch file uses DOS commands and the CLI of mkvinfo.exe from MKVToolNix utilities which can be found at: https://mkvtoolnix.download/

Execute this batch file from the top level directory from which you want to start the searches.  If the .MKV files are on a server share, you will need to map it to a drive letter for this work.
