class Mega {
  Serial port;
  int oldDistance = -1;
  int oldHeading = -1;
  boolean armed = true; // default to true so that we push the default false
  boolean demo;
  
  void init() {
    String[] ser = Serial.list();
    String[] options = new String[ser.length + 1];
    options[0] = "Demo mode";
    for (int i = 1; i < ser.length + 1; i++) {
      options[i] = ser[i-1];
    }
    SerialPortChooser c = new SerialPortChooser(options);
    while (!c.isReady()) {
      delay(200);
    }
    String r = c.getPort();
    demo = (r.equals("Demo mode"));
    if (!demo) {
      port = new Serial(computer_interface.this, r, 9600);
    }
  }
  
  boolean sendConfig(int distance, int heading, int armSwitch) {
    if (demo) return false;
    boolean res = false;
    if (distance != oldDistance) {
      oldDistance = distance;
      port.write("d" + oldDistance + " ");
      println("d" + oldDistance + " ");
      res = true;
    }
    if (heading != oldHeading) {
      oldHeading = heading;
      port.write("h" + oldHeading + " ");
      println("h" + oldHeading + " ");
      res = true;
    }
    boolean newArmed = (armSwitch == 400);
    if (newArmed != armed) {
      armed = newArmed;
      port.write(newArmed ? "a " : "u ");
      println(newArmed ? "a " : "u ");
      res = true;
    }
    return res;
  }
  
  void fire() {
    if (!demo) {
      port.write("f ");
      println("f ");
    }
  }
}
