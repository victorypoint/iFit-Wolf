# iFit-Wolf
Experimental iFit Workout Data Capture

iFit-Wolf – Experimental iFit Workout Data Capture - NordicTrack C2950 iFit Embedded Wifi Treadmill (2021 model)

Note: The NordicTrack C2950 iFit Embedded Wifi Treadmill is not a “smart treadmill” in the sense that it does not have iFit Bluetoothenabled technology. That is, it does not transmit speed and inclination data via Bluetooth to applications such as Zwift. Nor does it use 
WebSockets to communicate over Wifi as older NordicTrack treadmills have.

The NT C2950 treadmill, and perhaps other NT iFit-embredded treadmills (I’ve only tested the C2950 model), record individual workouts 
to a local text log in a sequential streaming format. Workout data is recorded to a single log file for each day and is easily identified by the
filename – e.g. 2022-05-24_logs.txt. Each days log file contains data for all workouts for that given day. The file naming scheme is 
therefore: YYYY-MM-DD_logs.txt. Each logged workout event is identified in a single or multiple lines by a unique ID and timestamp 
derived from the time/date settings within the users iFit configuration. Workout events, including changes to speed and inclination, are 
recorded in real-time to the log file and can be parsed to isolate current speed and inclination for use in applications such as Zwift.
For example, the log file 2022-05-24_logs.txt can contain real-time speed and inclination events which can be identified as follows:

- [11] 1758734 14:01:58.8047 [Trace:FitPro] Changed KPH to: 2.1
- [7] 1759006 14:01:59.0763 [Trace:FitnessConsole] Kph changed from 2 to 2.1
- [10] 1783494 14:02:23.5646 [Trace:FitPro] Changed Grade to: 0.5
- [12] 1783763 14:02:23.8342 [Trace:FitnessConsole] Grade changed from 0 to 0.5

The NT C2950 treadmills embedded iFit console runs Android (currently v9 on my model). The workout logs are located in: 
\sdcard\.wolflogs\. An example of the full workout log path for a given day is as follows:

- \sdcard\.wolflogs\2022-05-24_logs.txt

Workout events are recorded sequentially as they occur - top to bottom. To obtain the most recent speed and inclination values, look for 
the last occurrence of the events towards the bottom of the log file.

I've written a Windows VBscript which accesses the latest workout log and displays the real-time speed and inclination values in a MS 
Edge browser window. The log is accessed via an ADB connection to the treadmill. The VBscript assumes an ADB connection has already 
been established with the treadmill, and proceeds to copy the log, parse the current speed and inclination values, and display and refresh 
the real-time values in Edge. My testing environment is a Surface Book 2 running Windows 11 Pro.

I’ve not including documentation here on how to configure the NT C2950 treadmill for ADB communication, but it involves accessing the 
machines “Privileged Mode”, turning on “Developer Options” in Android settings, and enabling “USB Debugging” mode. Accessing 
Privileged Mode is well documented on many websites, dependent on the treadmill model, and version of Android and iFit.

Files included:
- adb-connect.bat (commands to initiate an ADB connection with the treadmill – change the IP to that of the treadmill)
- get-speed-incline.vbs (VBscript)
- cscript_get-speed-incline.bat (commands to launch VBscript in CScript window)
- Not included – ADB

ADB stands for Android Debug Bridge used by developers to connect their development computer with an Android device via a USB cable
(and over Wifi in this case). If you don't have Android SDK installed on your PC, ADB may not be recognized. It's recommended you 
download the latest version.

Obviously, this Windows ADB solution is not ideal and real-time feedback is a bit slow. With this documentation and code, it is hoped that 
it can be used as a basis to write faster processes to access the treadmills local workout logs and parse the speed and inclination values
for transmit to Zwift and other applications.
