// Duemilanove code.

#include <VirtualWire.h>

int inByte;
char firstRead = 0;
int inValue = -1;
int ledPin = 13;
int hingeCWPin = 2;
int hingeCWReversePin = 3;
int headingPin = 4;
int millisForPointOneInch = 100;
int millisForOneDegree = 50;
int lastHingeCW = 0;
int lastHeading = 0;

void setup() {
  Serial.begin(9600);  
  pinMode(11, OUTPUT);
  pinMode(13, OUTPUT);
  pinMode(hingeCWPin, OUTPUT);
  pinMode(hingeCWReversePin, OUTPUT);
  pinMode(headingPin, OUTPUT);
  // Initialise the IO and ISR
  vw_set_ptt_inverted(true);    // Required for RX Link Module
  vw_setup(2000);                   // Bits per sec
  vw_set_rx_pin(3);           // We will be receiving on pin 3 ie the RX pin from the module connects to this pin. 
  vw_rx_start();                      // Start the receiver 
}

void loop() {
  uint8_t buf[VW_MAX_MESSAGE_LEN];
  uint8_t buflen = VW_MAX_MESSAGE_LEN;
  
  if (vw_get_message(buf, &buflen)) {
//    digitalWrite(11, HIGH);
//    delay(1000);
//    digitalWrite(11, LOW);
    int i;
    for (i = 0; i < buflen; i++) {
      inByte = buf[i];
      if (firstRead == 0) {
        char inChar = (char) inByte;
        Serial.print(inChar);
        if (inChar == 'f') {
          fire();
        } else if (inChar == 'a') {
          armed(true);
        } else if (inChar == 'u') {
          armed(false);
        } else {
          firstRead = inChar;
        }
      } else if ((char) inByte == ' ') {
        if (firstRead != 0) push(firstRead, inValue);
        inValue = -1;
        firstRead = 0;
        continue; // if we have a space, then 
      } else {
        if (inValue == -1) {
          inValue = inByte - 48; // converts from ASCII to int
        } else {
          inValue *= 10;
          inValue += inByte - 48;
        }
      }
    }
  }
}

void fire() {
  // TODO fire
  Serial.print("fire");
  digitalWrite(13, HIGH);
  delay(1000);
  digitalWrite(13, LOW);
  delay(1000);
  digitalWrite(13, HIGH);
  delay(1000);
  digitalWrite(13, LOW);
  delay(1000);
  digitalWrite(13, HIGH);
  delay(1000);
  digitalWrite(13, LOW);
  delay(1000);
  digitalWrite(13, HIGH);
  delay(1000);
  digitalWrite(13, LOW);
  delay(1000);
  digitalWrite(13, HIGH);
  delay(1000);
  digitalWrite(13, LOW);
  delay(1000);
  digitalWrite(13, HIGH);
}

void armed(boolean stat) {
  digitalWrite(13, HIGH);
  
  if (!stat) {
    digitalWrite(13, LOW);
}
  // TODO set the armed status
}

void push(char command, int measurement) {
  if (command == 'd') {
    if (measurement == 0) { // reset
      digitalWrite(hingeCWReversePin, HIGH);
      digitalWrite(hingeCWPin, HIGH);
      delay(millisForPointOneInch * 200); // pretend we're reversing 20 inches (i know that our distance is less than that)
      digitalWrite(hingeCWPin, LOW);
      digitalWrite(hingeCWReversePin, LOW);
      return;
    }
    boolean reverse = (measurement < lastHingeCW);
    digitalWrite(hingeCWReversePin, reverse ? HIGH : LOW);
    digitalWrite(hingeCWPin, HIGH);
    delay(millisForPointOneInch * abs(measurement - lastHingeCW);
    digitalWrite(hingeCWPin, LOW);
    digitalWrite(hingeCWReversePin, LOW);
    lastHingeCW = measurement;
  } else {
    if (measurement == 0) {
      digitalWrite(headingPin, HIGH);
      delay(millisForOneDegree * 360); // pointless, but we can change it later
      digitalWrite(headingPin, LOW);
      return;
    }
    int distance = measurement - lastHeading;
    if (measurement < lastHeading) {
      distance += 360;
    }
    digitalWrite(headingPin, HIGH);
    delay(millisForOneDegree * distance);
    digitalWrite(headingPin, LOW);
  }
}
