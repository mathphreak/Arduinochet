import processing.serial.*;

// This code is in the public domain.

boolean PUSH_ON_CHANGE = false;

boolean valuesDirty = false;
Mega mega;

HingeCW hcw;
Heading head;
Buttons b;
SettingsInterface i;
boolean mousePressedLegit;

void setup() {
  println(Math.sin(90));
  mega = new Mega();
  mega.init();
  size(640, 480);
  smooth();
  imageMode(CENTER);
  hcw = new HingeCW();
  head = new Heading();
  b = new Buttons();
  i = new SettingsInterface();
  pushConfig();
}

void draw() {
  background(0);
  fill(255);
  textSize(60);
  text("Arduinochet Interface", 0, 50);
  hcw.draw();
  head.draw();
  b.draw();
  i.draw();
  mousePressedLegit = (mousePressed && !b.blocked && !i.blocked);
  println(mousePressedLegit);
}

void mouseMoved() {
  hcw.mouseMoved();
  head.mouseMoved();
  b.mouseMoved();
  i.mouseMoved();
}

void keyTyped() {
  i.keyTyped();
}

void mouseClicked() {
  if (!i.blocked) b.mouseClicked(); // hcw and head take care of this in draw() to account for holding down
  if (!b.blocked) i.mouseClicked();
//  println(mouseX + "," + mouseY);
}

void fire() {
  if (online || mega.demo) {
    link("http://upload.wikimedia.org/wikipedia/commons/8/89/Bomba_atomowa.gif");
  } else {
    mega.fire();
  }
}

void pushConfig() {
  valuesDirty = false;
  // send configuration data over serial here
  if (mega.sendConfig(hcw.hingeCWDistance, head.currentTrebuchetHeading, b.currentArmSwitchX)) {
    println("Config pushed.");
  }
}
