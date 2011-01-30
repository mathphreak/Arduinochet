// Mega code.

#include <VirtualWire.h>

int inByte = 0;
char firstRead = 0;
int inValue = -1;

void setup() {
  Serial.begin(9600);
  vw_set_ptt_inverted(true);
  vw_setup(2000);
  vw_set_tx_pin(26);
}

void loop() {
  if (Serial.available() > 0) {
    inByte = Serial.read();
    vw_send((uint8_t *)inByte, 1);
    vw_wait_tx();
  }
}
