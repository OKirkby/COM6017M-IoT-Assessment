#include <SPI.h>
#include <MFRC522.h>

#define RST_PIN 9
#define SS_PIN 10
#define LED 2

MFRC522 rfid(SS_PIN, RST_PIN);

unsigned long lastScanTime = 0;           // Track the last successful scan time
const unsigned long resetTimeout = 5000;  // 5 seconds timeout for reset

void setup() {
  Serial.begin(9600);
  SPI.begin();
  rfid.PCD_Init();
  pinMode(LED, OUTPUT);
  Serial.println("Ready to scan RFID cards...");
  lastScanTime = millis();
}

void loop() {
  // Reset the module if it's been too long since the last scan
  if (millis() - lastScanTime > resetTimeout) {
    Serial.println("Resetting RFID module...");
    rfid.PCD_Init();  // Reinitialize the RC522
    lastScanTime = millis();
  }

  // Look for new cards
  if (!rfid.PICC_IsNewCardPresent() || !rfid.PICC_ReadCardSerial()) {
    return;
  }

  // Print UID of the card
  Serial.print("Card UID: ");
  for (byte i = 0; i < rfid.uid.size; i++) {
    Serial.print(rfid.uid.uidByte[i] < 0x10 ? " 0" : " ");
    //Serial.print(rfid.uid.uidByte[i] < 0x10 ? "0" : "");
    Serial.print(rfid.uid.uidByte[i], HEX);
  }
  Serial.println();
  digitalWrite(LED, HIGH);
  delay(1000);
  digitalWrite(LED, LOW);

  // Update last scan time
  lastScanTime = millis();

  // Halt PICC (card)
  rfid.PICC_HaltA();
}
