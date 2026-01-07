#!/bin/bash

# Define the source URL and the local filename
URL="https://avtshare01.rz.tu-ilmenau.de/avt-vqdb-uhd-1/test_1/segments/bigbuck_bunny_8bit_15000kbps_1080p_60.0fps_h264.mp4"
OUTPUT="sample.mp4"

echo "Downloading video from TU Ilmenau servers..."

# Use curl to download the file
# -L: Follow redirects if the server moves the file
# -o: Specify the output filename
# --progress-bar: Shows a simple progress bar
curl -L "$URL" -o "$OUTPUT" --progress-bar

# Check if the download was successful
if [ $? -eq 0 ]; then
    echo "Successfully saved as $OUTPUT"
else
    echo "Download failed. Please check your internet connection or the URL."
    exit 1
fi
