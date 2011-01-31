// Mega code.

#include <VirtualWire.h>
#undef int
#undef abs
#undef double
#undef float
#undef round

int inByte = 0;
char firstRead = 0;
int inValue = -1;

void setup() {
  Serial.begin(9600);
  vw_set_ptt_inverted(true);
  vw_setup(2000);
  vw_set_tx_pin(29);
//  pinMode(29, OUTPUT);
//  digitalWrite(29, HIGH);
//  delay(1000);
//  digitalWrite(29, LOW);
}

void loop() {
//  digitalWrite(29, LOW);
  if (Serial.available() > 0) {
    inByte = Serial.read();
    uint8_t message[2];
    message[0] = inByte;
    message[1] = (uint8_t) 0;
    vw_send(message, 1);
    vw_wait_tx();
//    digitalWrite(29, HIGH);
  }
}
