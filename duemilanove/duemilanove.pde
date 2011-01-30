// Duemilanove code.

#include <VirtualWire.h>

int inByte;
char firstRead = 0;
int inValue = -1;

void setup() {
  Serial.begin(9600);  
  pinMode(11, OUTPUT);
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
    digitalWrite(11, HIGH);
    delay(1000);
    digitalWrite(11, LOW);
    int i;
    for (i = 0; i < buflen; i++) {
      inByte = buf[i];
      if (firstRead == 0) {
        char inChar = (char) inByte;
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
}

void armed(boolean stat) {
  // TODO set the armed status
}

void push(char command, int measurement) {
  // TODO push the measurement
}
