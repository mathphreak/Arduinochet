class Mega {
  Serial port;
  int oldDistance;
  int oldHeading;
  boolean armed;
  
  void init() {
    println(Serial.list());
    SerialPortChooser c = new SerialPortChooser(Serial.list());
    while (!c.isReady()) {
      delay(200);
    }
    port = new Serial(computer_interface.this, c.getPort(), 9600);
  }
  
  void sendConfig(int distance, int heading, int armSwitch) {
    if (distance != oldDistance) {
      oldDistance = distance;
      port.write("d" + oldDistance + " ");
    }
    if (heading != oldHeading) {
      oldHeading = heading;
      port.write("h" + oldHeading + " ");
    }
    boolean newArmed = (armSwitch == 400);
    if (newArmed != armed) {
      armed = newArmed;
      port.write(newArmed ? "a " : "u ");
    }
  }
  
  void fire() {
    port.write("f ");
  }
}
