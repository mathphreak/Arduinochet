class Mega {
  Serial port;
  int oldDistance;
  int oldHeading;
  boolean armed;
  
  void init() {
    String portName = Serial.list()[0];
    port = new Serial(computer_interface.this, portName, 9600);
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
