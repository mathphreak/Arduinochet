import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class computer_interface extends PApplet {

// This code is in the public domain.

final boolean DRAW_PUSH_BUTTON = true;
boolean PUSH_ON_CHANGE = false;

int hingeCWDistance = 20; // inches
int currentTrebuchetHeading = 0; // degrees
boolean overHCWPlus = false;
boolean overHCWMinus = false;
boolean overHeadingPlus = false;
boolean overHeadingMinus = false;
boolean overPushSettings = false;
boolean overArmSwitch = false;
int currentArmSwitchX = 300;
int armSwitchDragStartX = -1;
int armSwitchOriginal = -1;
boolean valuesDirty = false;
boolean overLaunchButton = false;
boolean launched = false;
int currentBlockOpacity = 0;
int heldDownStart = -1;

public void setup() {
  size(640, 480);
  smooth();
  imageMode(CENTER);
}

public void draw() {
  background(0);
  fill(255);
  textSize(67);
  text("Arduinochet Interface", 0, 50);
  drawHCW();
  drawHeading();
  drawButtons();
}

public void drawButtons() {
  // Push Config
  noStroke();
  fill(100);
  rect(25, 350, 200, 100);
  if (PUSH_ON_CHANGE) {
    fill(150);
  } else if (overPushSettings && valuesDirty) {
    fill(255, 200, 100);
  } else if (valuesDirty) {
    fill(255, 0, 0);
  } else if (overPushSettings) {
    fill(0, 255, 200);
  } else {
    fill(255);
  }
  textSize(20);
  text("Push Config", 50, 400);
  fill(175);
  rect(30, 420, 190, 25);
  if (PUSH_ON_CHANGE) {
    fill(255);
    text("Live", 35, 440);
    fill(200);
    text("Manual", 150, 440);
  } else {
    fill(200);
    text("Live", 35, 440);
    fill(255);
    text("Manual", 150, 440);
  }
  // dark rectangle
  fill(0, currentBlockOpacity);
  rect(0, 0, width, height);
  if (currentArmSwitchX == 400) {
    if (currentBlockOpacity < 200) currentBlockOpacity++;
  } else {
    if (currentBlockOpacity > 0) currentBlockOpacity--;
  }
  // LAUNCH
  fill(100);
  rect(250, 350, 365, 100);
  // launch slider
  stroke(255);
  line(300, 400, 400, 400);
  noStroke();
  if (currentArmSwitchX == 400) {
    fill(255, 0, 0);
  } else {
    fill(50);
  }
  textSize(15);
  text("ARMED", 369, 370);
  text("ARMED", 370, 370);
  if (currentArmSwitchX == 400) {
    fill(255, 0, 0);
  } else if (armSwitchDragStartX == -1) {
    fill(200, 50, 0);
  } else if (overArmSwitch) {
    fill(200, 100, 0);
  } else {
    fill(200, 0, 50);
  }
  rect(currentArmSwitchX - 20, 375, 40, 50);
  // launch button
  if (currentArmSwitchX == 400) {
    fill((millis() % 1000 > 500) ? 255 : 200, 0, 0);
  } else {
    fill(50, 0, 0);
  }
  ellipse(525, 400, 90, 90);
  if (currentArmSwitchX == 400) {
    fill((millis() % 1000 > 500) ? 200 : 150, 0, 0);
  } else {
    fill(50, 0, 0);
  }
  ellipse(525, 400, 85, 85);
  fill(50, 0, 0);
  text("Launch!", 500, 405);
}

public void drawHCW() {
  noStroke();
  fill(100);
  rect(25, 100, 590, 100);
  fill(255);
  textSize(20);
  text("Hinge-Counterweight Distance: " + hingeCWDistance + "\"", 115, 150);
  pushMatrix();
  translate(545, 120);
  if (overHCWPlus) {
    fill(0, 255, 200);
  } else {
    fill(255, 0, 0);
  }
  noStroke();
  rect(25, 0, 10, 60);
  rect(0, 25, 60, 10);
  if (mousePressed && overHCWPlus) {
    if (heldDownStart == -1) {
      heldDownStart = millis();
    } else {
      if (millis() - heldDownStart > 500) {
        if (frameCount % 15 == 0) {
          hingeCWDistance++;
          if (PUSH_ON_CHANGE) {
            pushConfig();
          }
        }
      }
    }
  } else if (!mousePressed) {
    heldDownStart = -1;
  }
  popMatrix();
  pushMatrix();
  if (overHCWMinus) {
    fill(0, 255, 200);
  } else {
    fill(255, 0, 0);
  }
  translate(45, 120);
  rect(0, 25, 60, 10);
  if (mousePressed && overHCWMinus) {
    if (heldDownStart == -1) {
      heldDownStart = millis();
    } else {
      if (millis() - heldDownStart > 500) {
        if (frameCount % 15 == 0) {
          hingeCWDistance--;
          if (PUSH_ON_CHANGE) {
            pushConfig();
          }
        }
      }
    }
  } else if (!mousePressed) {
    heldDownStart = -1;
  }
  popMatrix();
}

public void drawHeading() {
  fill(100);
  rect(25, 225, 590, 100);
  fill(255);
  textSize(20);
  text("Heading: " + currentTrebuchetHeading + "\u00b0", 115, 275);
  pushMatrix();
  translate(545, 245);
  if (overHeadingPlus) {
    fill(0, 255, 200);
  } else {
    fill(255, 0, 0);
  }
  noStroke();
  rect(25, 0, 10, 60);
  rect(0, 25, 60, 10);
  if (mousePressed && overHeadingPlus) {
    if (heldDownStart == -1) {
      heldDownStart = millis();
    } else {
      if (millis() - heldDownStart > 500) {
        if (frameCount % 5 == 0) {
          currentTrebuchetHeading++;
          if (PUSH_ON_CHANGE) {
            pushConfig();
          }
        }
      }
    }
  } else if (!mousePressed) {
    heldDownStart = -1;
  }
  popMatrix();
  pushMatrix();
  if (overHeadingMinus) {
    fill(0, 255, 200);
  } else {
    fill(255, 0, 0);
  }
  translate(45, 245);
  rect(0, 25, 60, 10);
  if (mousePressed && overHeadingMinus) {
    if (heldDownStart == -1) {
      heldDownStart = millis();
    } else {
      if (millis() - heldDownStart > 500) {
        if (frameCount % 5 == 0) {
          currentTrebuchetHeading--;
          if (PUSH_ON_CHANGE) {
            pushConfig();
          }
        }
      }
    }
  } else if (!mousePressed) {
    heldDownStart = -1;
  }
  popMatrix();
  pushMatrix();
  translate(400, 260);
  rotate(currentTrebuchetHeading * PI/180);
  fill(255);
  stroke(0);
  ellipse(0, 0, 20, 20);
  line(0, 0, 0, -10);
  popMatrix();
}

public void mouseMoved() {
  if (mouseX > 45 && mouseX < (45 + 60) && mouseY > (120 + 25) && mouseY < (120 + 25 + 10)) {
    overHCWMinus = true;
  } else {
    overHCWMinus = false;
  }
  if (mouseX > (545 + 25) && mouseX < (545 + 25 + 10) && mouseY > 120 && mouseY < (120 + 60)) {
    overHCWPlus = true;
  } else if (mouseX > 545 && mouseX < (545 + 60) && mouseY > (120 + 25) && mouseY < (120 + 25 + 10)) {
    overHCWPlus = true;
  } else {
    overHCWPlus = false;
  }
  
  if (mouseX > 45 && mouseX < (45 + 60) && mouseY > (245 + 25) && mouseY < (245 + 25 + 10)) {
    overHeadingMinus = true;
  } else {
    overHeadingMinus = false;
  }
  if (mouseX > (545 + 25) && mouseX < (545 + 25 + 10) && mouseY > 245 && mouseY < (245 + 60)) {
    overHeadingPlus = true;
  } else if (mouseX > 545 && mouseX < (545 + 60) && mouseY > (245 + 25) && mouseY < (245 + 25 + 10)) {
    overHeadingPlus = true;
  } else {
    overHeadingPlus = false;
  }
  
  if (mouseX > 25 && mouseX < (25 + 200) && mouseY > 350 && mouseY < (350 + 100)) {
    overPushSettings = true;
  } else {
    overPushSettings = false;
  }
  
  if (mouseX > (currentArmSwitchX - 20) && mouseX < (currentArmSwitchX + 20) && mouseY > 375 && mouseY < (375 + 50)) {
    overArmSwitch = true;
  } else {
    overArmSwitch = false;
  }
  if (armSwitchDragStartX != -1) {
    currentArmSwitchX = constrain(armSwitchOriginal + (mouseX - armSwitchDragStartX), 300, 400);
    if ((currentArmSwitchX == 400 && armSwitchDragStartX != 400) || (currentArmSwitchX == 300 && armSwitchDragStartX != 300)) {
      armSwitchDragStartX = -1;
    }
  }
  
  if (dist(525, 400, mouseX, mouseY) < (85/2)) {
    overLaunchButton = true;
  } else {
    overLaunchButton = false;
  }
}

public void fire() {
  // tell the arduino to fire
  launched = true;
  link("http://upload.wikimedia.org/wikipedia/commons/8/89/Bomba_atomowa.gif");
}

public void mouseClicked() {
  if (overHCWPlus) {
    hingeCWDistance++;
    valuesDirty = true;
  } else if (overHCWMinus) {
    hingeCWDistance--;
    valuesDirty = true;
  } else if (overHeadingMinus) {
    currentTrebuchetHeading--;
    valuesDirty = true;
  } else if (overHeadingPlus) {
    currentTrebuchetHeading++;
    valuesDirty = true;
  } else if (overArmSwitch) {
    if (armSwitchDragStartX == -1) {
      armSwitchDragStartX = mouseX;
      armSwitchOriginal = currentArmSwitchX;
    } else {
      armSwitchDragStartX = -1;
    }
  } else if (overPushSettings) {
    if (mouseButton == LEFT) {
      pushConfig();
    } else if (mouseButton == RIGHT) {
      PUSH_ON_CHANGE = !PUSH_ON_CHANGE;
    }
  } else if (overLaunchButton && currentArmSwitchX == 400) {
    fire();
  } else {
    println(mouseX + "," + mouseY);
  }
  if (valuesDirty && PUSH_ON_CHANGE) {
    pushConfig();
  }
}

public void pushConfig() {
  valuesDirty = false;
  // send configuration data over serial here
  println("Config pushed.");
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#F0F0F0", "computer_interface" });
  }
}
