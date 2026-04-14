#!/bin/bash

# Install OpenSpeedTest

# Create the speedtest directory
mkdir -p /opt/hiddify-manager/other/speedtest

# Download OpenSpeedTest
wget -O /tmp/speedtest.zip https://github.com/openspeedtest/Speed-Test/archive/refs/heads/main.zip

# Unzip the files
unzip /tmp/speedtest.zip -d /tmp/

# Copy files to the speedtest directory
cp -r /tmp/Speed-Test-main/* /opt/hiddify-manager/other/speedtest/

# Clean up
rm -rf /tmp/speedtest.zip /tmp/Speed-Test-main

# Set permissions
chmod -R 755 /opt/hiddify-manager/other/speedtest/

echo "OpenSpeedTest installed successfully!"
