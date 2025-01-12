import serial
import sqlite3
import RPi.GPIO as GPIO
import time
import requests

# GPIO setup for door lock
DOOR_LOCK_PIN = 17  
GPIO.setmode(GPIO.BCM)
GPIO.setup(DOOR_LOCK_PIN, GPIO.OUT)
GPIO.output(DOOR_LOCK_PIN, GPIO.LOW)

# ThingSpeak configuration
THINGSPEAK_URL = "https://api.thingspeak.com/update"
API_KEY = "PZ4N53IFX6KDTJYH"  # Write API Key

# SQLite3 database path
DATABASE = "rfid_access.db"

def send_to_thingspeak(uid, status):
    """Send UID and status to ThingSpeak."""
    payload = {
        'api_key': API_KEY,
        'field1': uid,
        'field2': status
    }
    response = requests.post(THINGSPEAK_URL, data=payload)
    if response.status_code == 200:
        print(f"Data sent to ThingSpeak: UID={uid}, Status={status}")
    else:
        print(f"Failed to send data to ThingSpeak. HTTP {response.status_code}")

def validate_uid(uid):
    """Validate UID against the SQLite database and log it."""
    conn = sqlite3.connect(DATABASE)
    cursor = conn.cursor()
    
    # Check if the UID is valid
    cursor.execute("SELECT name FROM valid_uids WHERE uid = ?", (uid,))
    result = cursor.fetchone()
    
    if result:
        status = "Valid"
        print(f"Access granted for {result[0]} (UID: {uid})")
        unlock_door()
    else:
        status = "Invalid"
        print(f"Access denied (UID: {uid})")
    
    # Log the scan
    cursor.execute("INSERT INTO scan_logs (uid, status) VALUES (?, ?)", (uid, status))
    conn.commit()
    conn.close()
    
    # Send data to ThingSpeak
    send_to_thingspeak(uid, status)
    return status

def unlock_door():
    """Unlock the door for a valid scan."""
    GPIO.output(DOOR_LOCK_PIN, GPIO.HIGH)
    print("Door unlocked.")
    time.sleep(5)  # Keep the door unlocked for 5 seconds
    GPIO.output(DOOR_LOCK_PIN, GPIO.LOW)
    print("Door locked.")

def parse_uid(data):
    """Extract the UID from the serial data."""
    if "Card UID:" in data:
        return data.split("Card UID:")[1].strip().replace(" ", "")
    return None

# Main RFID scanning loop
SERIAL_PORT = '/dev/serial0'  # GPIO Serial Port
BAUD_RATE = 9600

with serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1) as ser:
    print("Listening for RFID scans...")
    while True:
        line = ser.readline().decode().strip()
        if line:  # If there's data received
            print(f"Raw data: {line}")
            uid = parse_uid(line)
            if uid:
                print(f"Parsed UID: {uid}")
                validate_uid(uid)
