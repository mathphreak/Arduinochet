// Mega code.
int inByte = 0;
char firstRead = 0;
int inValue = -1;

void setup() {
  Serial.begin(9600);
}

void loop() {
  if (Serial.available() > 0) {
    inByte = Serial.read();
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
    } else if ((char) inValue == ' ') {
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

void fire() {
  // TODO fire
}

void armed(boolean stat) {
  // TODO set the armed status
}

void push(char command, int measurement) {
  // TODO push the measurement
}
