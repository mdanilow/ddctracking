Skin color tracking system with HTTP PTZ camera control via Zybo Ethernet port. Camera used in this project is AXIS V5915 PTZ.


How to launch:

Step 1. Camera's server setup.

- Open project in Vivado.
- File > Launch SDK.
- camera control project is "clientboys"
- in line 64 of "main.c" define your camera's network location
- in file "tcp_perf_client.c", line 212, edit your camera's request structure

Step 2. Build project
Step 3. Generate bitstream in Vivado
Step 4. Click "Program FPGA" in SDK and then Run
