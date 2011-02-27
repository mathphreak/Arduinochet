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
int awesomePos = 0;

void lcdHeader() {
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Arduinochet v. 0.8");
  lcd.setCursor(20, 2);
}

void setup() {
  Serial.begin(9600);
  vw_set_ptt_inverted(true);
  vw_setup(2000);
  vw_set_tx_pin(25);
  pinMode(13, OUTPUT);
  digitalWrite(13, HIGH);
  delay(1000);
  digitalWrite(13, LOW);
  lcd.createChar(0, newChar);
  lcd.begin(20, 2);
  lcdHeader();
  lcd.setCursor (20, 4);
  awesome_wait_tx();
  awesome_unwait_tx();
}

void loop() {
  lcd.setCursor(20, 2);
  int i;
  if (Serial.available() > 0) {
    inByte = Serial.read();
    char inChar = (char) inByte;
    Serial.print(inChar);
    if (firstRead == 0) {
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
    } else if ((char) inByte == ' ') {
      if (firstRead != 0) push(firstRead, inValue);
      inValue = -1;
      firstRead = 0; 
    } else {
      if (inValue == -1) {
        inValue = inByte - 48; // converts from ASCII to int
      } 
      else {
        inValue *= 10;
        inValue += inByte - 48;
      }
    }
    uint8_t message[2];
    message[0] = inByte;
    message[1] = (uint8_t) 0;
    digitalWrite(13, HIGH);
    vw_send(message, 2);
    awesome_wait_tx();
    digitalWrite(13, LOW);
    delay(100); // wait to make sure any temporary glitches have un-glitched
    digitalWrite(13, HIGH);
    vw_send(message, 2);
    awesome_unwait_tx();
    digitalWrite(13, LOW);
    if (((char) inByte) == ' ') lcdHeader(); // if we sent a space, then clear the status message
  }/* else {
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
  }*/
}

// better, but less functional, wait_tx() that requires VW hacking
//void epic_wait_tx() {
//  lcd.setCursor(20, 4);
//  while (vw_txing()) {
//    if (awesomePos > 20) {
//      lcd.print(" ");
//    } else if (awesomePos == 20) {
//      lcd.setCursor(20, 4);
//    } else {
//      lcd.write(0);
//    }
//    awesomePos++;
//    delay(50);
//  }
//}

void awesome_working() {
  lcd.setCursor(20, 4);
  lcd.print("W");
  delay(50);
  lcd.print("o");
  delay(50);
  lcd.print("r");
  delay(50);
  lcd.print("k");
  delay(50);
  lcd.print("i");
  delay(50);
  lcd.print("n");
  delay(50);
  lcd.print("g");
  delay(50);
}

void awesome_finished() {
  lcd.setCursor(27, 4);
  lcd.print(" ");
  delay(50);
  lcd.setCursor(26, 4);
  lcd.print(" ");
  delay(50);
  lcd.setCursor(25, 4);
  lcd.print(" ");
  delay(50);
  lcd.setCursor(24, 4);
  lcd.print(" ");
  delay(50);
  lcd.setCursor(23, 4);
  lcd.print(" ");
  delay(50);
  lcd.setCursor(22, 4);
  lcd.print(" ");
  delay(50);
  lcd.setCursor(21, 4);
  lcd.print(" ");
  delay(50);
  lcd.setCursor(20, 4);
  lcd.print(" ");
  delay(50);
}

void awesome_wait_tx() {
  lcd.setCursor(20, 4);
  for (int i = 0; i < 20; i++) {
    lcd.write(0);
    delay(50);
  }
}

void awesome_unwait_tx() {
  for (int i = 39; i >= 19; i--) {
    if (i >= 20) {
      lcd.setCursor(i, 4);
      lcd.print('~'); // tilde which is ->
      delay(50);
    }
    if (i < 39) {
      lcd.setCursor(i+1, 4);
      lcd.print(" ");
      delay(50);
    }
  }
}

void awesome_rewait_tx() {
  for (int i = 19; i <= 39; i++) {
    if (i >= 20) {
      lcd.setCursor(i, 4);
      lcd.print('-');
      delay(50);
    }
    if (i < 39) {
      lcd.setCursor(i+1, 4);
      lcd.print("~"); // tilde which is ->
      delay(50);
    }
    delay(50);
  }
}

void awesome_funwait_tx() {
  for (int i = 39; i >= 19; i--) {
    if (i >= 20) {
      lcd.setCursor(i, 4);
      lcd.print('~'); // tilde which is ->
      delay(50);
    }
    if (i < 39) {
      lcd.setCursor(i+1, 4);
      lcd.print(" ");
      delay(50);
    }
    delay(50);
  }
}

void fire() {
  // TODO fire
  lcd.print("Firing");
/*  lcd.setCursor (20, 4); // moved to afterwards so it's not fake
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
  delay(50);
  lcd.write(0);
  delay(500);
  lcdHeader();
  lcd.print("done firing,");
  lcd.setCursor(0, 2);
  lcd.print("reload trebuchet");
  delay(3000);
  lcd.clear();
  lcdHeader(); */
}

void armed(boolean stat) {
  if (stat) {
    lcdHeader();
    lcd.print("-------ARMED--------");
    lcd.setCursor(0, 2);
    lcd.print("ready to fire");
  } else {
    lcdHeader();
    lcd.print("------DISARMED------");
    lcd.setCursor(0, 2);
    lcd.print("not ready to fire");
  }
}

void push(char command, int measurement) {
  lcd.print("adjusting ");
  if (command == 'd') {
    lcd.print("distance");
  } else if (command == 'h') {
    lcd.print("heading");
  }
}


