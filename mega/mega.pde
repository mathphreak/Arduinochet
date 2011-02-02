// Mega code, with 20x4 lcd support//
#include <LiquidCrystal.h>
#include <VirtualWire.h>
#undef int
#undef abs
#undef double
#undef float
#undef round

LiquidCrystal lcd(7, 8, 36, 38, 40, 42, 9, 10, 11, 12);

byte newChar[8] = {
  B00000,
  B00000,
  B00000,
  B00000,
  B00000,
  B00000,
  B00000,
  B11111
};


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
  lcd.createChar(0, newChar);
  lcd.begin(20, 2);
  lcd.setCursor (0, 0);
  lcd.print("Arduinochet v. 0.8");
  lcd.setCursor (20, 4);
  delay(1000);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(1000);
  lcd.clear();
  lcd.setCursor(20, 2);



}

void loop() {
  lcd.setCursor(20, 2);
  lcd.print("Waiting for input");
  delay(500);
  lcd.print(".");
  delay(500);
  lcd.print(".");
  delay(500);
  lcd.print(".");
  delay(500);
  lcd.clear();
  int i;
  if (Serial.available() > 0) {
    inByte = Serial.read();
    uint8_t message[2];
    message[0] = inByte;
    message[1] = (uint8_t) 0;
    vw_send(message, 1);
    vw_wait_tx();
    if (firstRead == 0) {
      char inChar = (char) inByte;
      Serial.print(inChar);
      if (inChar == 'f') {
        fire();
      } 
      else if (inChar == 'a') {
        armed(true);
      } 
      else if (inChar == 'u') {
        armed(false);
      } 
      else {
        firstRead = inChar;
      }
    } 
    else if ((char) inByte == ' ') {
      if (firstRead != 0) push(firstRead, inValue);
      inValue = -1;
      firstRead = 0; 
    } 
    else {
      if (inValue == -1) {
        inValue = inByte - 48; // converts from ASCII to int
      } 
      else {
        inValue *= 10;
        inValue += inByte - 48;
      }
    }
  }
}
void fire() {
  // TODO fire
  lcd.print("Firing");
  lcd.setCursor (20, 4);
  delay(1000);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(50);
  lcd.write(0);
  delay(1000);
  lcd.clear();
  delay(5000);
  lcd.clear();
  lcd.print("done firing,");
  lcd.setCursor(0, 3);
  lcd.print("reload trebuchet");
}

void armed(boolean stat) {
  lcd.clear();
  lcd.print("-------ARMED--------");
  lcd.setCursor(0, 3);
  lcd.print("ready to fire");
  
  if (!stat) {
    lcd.clear();
    lcd.print("------DISARMED-------");
    lcd.setCursor(0,3);
    lcd.print("re-arm to fire");
  }
}

void push(char command, int measurement) {
  lcd.clear();
  lcd.print("adjusting");
  delay(5000);
  lcd.clear();
  // TODO push the measurement
}


