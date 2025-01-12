# IoT-Enabled RFID Access Control System

This repository contains the source code and documentation for an IoT-enabled RFID access control system. The project integrates an RFID scanner, a Raspberry Pi, and a cloud platform (ThingSpeak) to provide a secure and real-time solution for managing access to restricted areas.

## Features

- **Real-Time Monitoring**: Logs RFID scans and updates access data on ThingSpeak.
- **Access Decisions**: Validates RFID UIDs against a local SQLite database.
- **Data Analytics**: Provides visualizations such as pie charts, bar charts, and scatter plots via ThingSpeak.
- **Secure Design**: Implements encryption for data transmission and secure storage practices.

## Technologies Used

- **Hardware**:
  - Raspberry Pi
  - Arduino with MFRC522 RFID Module
  - Relay Module for door control
  - LEDs for feedback

- **Software**:
  - Python (Raspberry Pi)
  - Arduino IDE
  - SQLite3 (Local database)
  - ThingSpeak API (Cloud platform)

- **Tools**:
  - Visio for circuit diagrams

## Getting Started

### Prerequisites

1. **Hardware Setup**:
   - Assemble the circuit as described in the project documentation.

2. **Software Installation**:
   - Install Python and required libraries:
     ```bash
     sudo apt update
     sudo apt install python3 python3-pip
     pip3 install sqlite3 requests RPi.GPIO
     ```
   - Install the Arduino IDE and upload the RFID reader sketch to the Arduino.

3. **ThingSpeak Configuration**:
   - Create a ThingSpeak channel and obtain the Write API Key.
   - For purposes of marking this assignment the API Keys have been left in the code but they will be revoked straight after
    the marking process is complete.

4. **Database Setup**:
   - RFID Database is included with demonstration UIDs.
   - Add valid UIDs to the `valid_uids` table.

### Running the Project

1. Start the Python script on the Raspberry Pi:
   ```bash
   python3 rfid_controller.py
2. The Arduino will power up and run automatically when the Pi gets external power.
