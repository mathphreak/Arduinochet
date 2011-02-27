// Duemilanove code.

#include <VirtualWire.h>

int inByte;
char firstRead = 0;
int inValue = -1;
int ledPin = 11;
int hingeCWPin = 2;
int hingeCWReversePin = 12;
int headingPin = 5;
int releasePin = 6;
int millisForPointOneInch = 100;
int millisForOneDegree = 1;
int millisForRelease = 1;
int lastHingeCW = 0;
int lastHeading = 0;
int duplicity = 0; // how many times did we recieve the same character?

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
      if (newByte == inByte) {
        duplicity++; // we have recieved it once more
        if (duplicity > 2) {
          // we know we recieved more than 2 of the same character, so we actually want both
          duplicity = 1;
        }
      } else {
        duplicity = 1; // we recieved it once
      }
      if (duplicity != 1) continue; // if we have recieved it more than once, then skip it
      inByte = buf[i];
      char inChar = (char) inByte;
      Serial.print(" '");
      Serial.print(inChar);
      Serial.print("'");
      if (inChar == ' ') {
        if (firstRead != 0) {
          Serial.print(" - pushing ");
          Serial.print(firstRead);
          Serial.print(inValue, DEC);
          push(firstRead, inValue);
        }
        inValue = -1;
        firstRead = 0;
        Serial.println(";");
        continue; // if we have a space, then we can't have anything else
      } else if (firstRead == 0) {
        Serial.print(" - something new");
        if (inChar == 'f') {
          fire();
        } else if (inChar == 'a') {
          armed(true);
        } else if (inChar == 'u') {
          armed(false);
        } else if (inChar == 'd' || inChar == 'h') {
          firstRead = inChar;
        } else {
          Serial.print(" - I don't recognize that");
        }
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
  Serial.print(" - **fire**");
  digitalWrite(releasePin, HIGH);
  delay(millisForRelease);
  digitalWrite(releasePin, LOW);
  digitalWrite(ledPin, HIGH);
  delay(200);
  digitalWrite(ledPin, LOW);
  delay(200);
  digitalWrite(ledPin, HIGH);
  delay(200);
  digitalWrite(ledPin, LOW);
  delay(200);
  digitalWrite(ledPin, HIGH);
  delay(200);
  digitalWrite(ledPin, LOW);
  delay(200);
  digitalWrite(ledPin, HIGH);
  delay(200);
  digitalWrite(ledPin, LOW);
  delay(200);
  digitalWrite(ledPin, HIGH);
  delay(200);
  digitalWrite(ledPin, LOW);
}

void armed(boolean stat) {
  if (stat) {
    digitalWrite(ledPin, HIGH);
    Serial.print(" - **armed**");
  } else {
    digitalWrite(ledPin, LOW);
    Serial.print(" - **unarmed**");
  }
}

void push(char command, int measurement) {
  if (command == 'd') {
    if (measurement == 0) { // reset
      digitalWrite(hingeCWReversePin, HIGH);
      digitalWrite(hingeCWPin, LOW);
      delay(millisForPointOneInch * 200); // pretend we're reversing 20 inches (i know that our distance is less than that)
      digitalWrite(hingeCWPin, LOW);
      digitalWrite(hingeCWReversePin, LOW);
      return;
    }
    boolean reverse = (measurement < lastHingeCW);
    digitalWrite(hingeCWReversePin, reverse ? HIGH : LOW);
    digitalWrite(hingeCWPin, reverse ? LOW : HIGH);
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
