import processing.opengl.*;

import processing.serial.*;

// This code is in the public domain.

boolean PUSH_ON_CHANGE = false;

boolean valuesDirty = false;
Mega mega;

HingeCW hcw;
Heading head;
Buttons b;
SettingsInterface i;
JackProofing jp;
Camera c;
boolean mousePressedLegit;
int thickness = 1;

void setup() {
  size(640, 480, OPENGL);
  c = new Camera();
  println(floor(log(522577666)/log(10)));
  mega = new Mega();
//  mega.init();
  hcw = new HingeCW();
  head = new Heading();
  b = new Buttons();
  i = new SettingsInterface();
  jp = new JackProofing();
  jp.blocked = false; // when we don't draw it, don't block the screen
  pushConfig();
}

void draw() {
  background(0);
  lights();
  c.draw();
  pushMatrix();
  translate(200, 500, 50);
  rotateX(PI - QUARTER_PI);
  rotateY(-QUARTER_PI);
  rotateZ(0.2*PI);
  fill(255);
  textSize(60);
  text("Arduinochet Interface", 0, 0, 0);
  popMatrix();
  hcw.draw();
  head.draw();
  b.draw();
  i.draw();
//  jp.draw();
  mousePressedLegit = (mousePressed && !b.blocked && !i.blocked && !jp.blocked);
}

void mouseMoved() {
  hcw.mouseMoved();
  head.mouseMoved();
  b.mouseMoved();
  i.mouseMoved();
  jp.mouseMoved();
}

void keyTyped() {
  boolean a = i.keyTyped(); // only reacts if in something
  if (a) return;
  println("i didn't eat it");
  if (!i.blocked) {
    boolean b = jp.keyTyped(); // needs to know for re-enabling
    if (b) return;
  }
  println("jp didn't eat it");
  c.keyTyped();
}

void mouseClicked() {
  println(map(mouseX, 0, width, -1000, 1000));
  if (!i.blocked && !jp.blocked) b.mouseClicked(); // hcw and head take care of this in draw() to account for holding down
  if (!b.blocked && !jp.blocked) i.mouseClicked();
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
