// Duemilanove code.

#include <VirtualWire.h>

int inByte;
char firstRead = 0;
int inValue = -1;
int ledPin = 11;
int hingeCWPin = 2;
int hingeCWReversePin = 4;
int headingPin = 5;
int releasePin = 6;
int millisForPointOneInch = 1;
int millisForOneDegree = 1;
int millisForReleaseRevolution = 1;
int lastHingeCW = 0;
int lastHeading = 0;

void setup() {
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);
  pinMode(hingeCWPin, OUTPUT);
  pinMode(hingeCWReversePin, OUTPUT);
  pinMode(headingPin, OUTPUT);
  pinMode(releasePin, OUTPUT);
  // Initialise the IO and ISR
  vw_set_ptt_inverted(true);    // Required for RX Link Module
  vw_setup(2000);                   // Bits per sec
  vw_set_rx_pin(3);           // We will be receiving on pin 3 ie the RX pin from the module connects to this pin. 
  vw_rx_start();                      // Start the receiver 
}

void loop() {
  uint8_t buf[VW_MAX_MESSAGE_LEN];
  uint8_t buflen = VW_MAX_MESSAGE_LEN;
  
//  Serial.println(millis()); // this was for debugging purposes only
  
  if (vw_get_message(buf, &buflen)) {
//    digitalWrite(ledPin, HIGH);
//    delay(1000);
//    digitalWrite(ledPin, LOW);
    int i;
    for (i = 0; i < buflen; i++) {
      if (buf[i] == 0) continue;
      byte newByte = buf[i];
      if (newByte == inByte) continue; // if this is the same as the last one, then ignore it
      inByte = buf[i];
      if (firstRead == -1) {
        char inChar = (char) inByte;
        Serial.println("something new");
        if (inChar == 'f') {
          Serial.println("it's fire");
          fire();
          Serial.println("it was fire");
        } else if (inChar == 'a') {
          Serial.println("it's armed");
          armed(true);
          Serial.println("it was armed");
        } else if (inChar == 'u') {
          Serial.println("it's unarmed");
          armed(false);
          Serial.println("it was unarmed");
        } else {
          Serial.println("it's " + inChar);
          firstRead = inChar;
          Serial.println("it was " + inChar);
        }
      } else if ((char) inByte == ' ') {
        if (firstRead != 0) push(firstRead, inValue);
        inValue = -1;
        firstRead = -1;
        continue; // if we have a space, then we can't have anything else
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
  Serial.println("fire");
//  digitalWrite(releasePin, HIGH);
//  delay(millisForReleaseRevolution);
//  digitalWrite(releasePin, LOW);
/*  digitalWrite(ledPin, HIGH);
  delay(1000);
  digitalWrite(ledPin, LOW);
  delay(1000);
  digitalWrite(ledPin, HIGH);
  delay(1000);
  digitalWrite(ledPin, LOW);
  delay(1000);
  digitalWrite(ledPin, HIGH);
  delay(1000);
  digitalWrite(ledPin, LOW);
  delay(1000);
  digitalWrite(ledPin, HIGH);
  delay(1000);
  digitalWrite(ledPin, LOW);
  delay(1000);
  digitalWrite(ledPin, HIGH);
  delay(1000);
  digitalWrite(ledPin, LOW);
  delay(1000);
  digitalWrite(ledPin, HIGH); */
}

void armed(boolean stat) {
  if (stat) {
    digitalWrite(ledPin, HIGH);
    Serial.println();
    Serial.println("armed");
  } else {
    digitalWrite(ledPin, LOW);
    Serial.println();
    Serial.println("unarmed");
  }
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
    delay(millisForPointOneInch * abs(measurement - lastHingeCW));
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
