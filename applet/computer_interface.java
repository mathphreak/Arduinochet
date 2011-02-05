import processing.core.*; 
import processing.xml.*; 

import processing.serial.*; 

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

boolean PUSH_ON_CHANGE = false;

boolean valuesDirty = false;
Mega mega;

HingeCW hcw;
Heading head;
Buttons b;
SettingsInterface i;
JackProofing jp;
boolean mousePressedLegit;

public void setup() {
  println(floor(log(522577666)/log(10)));
  mega = new Mega();
  mega.init();
  size(640, 480);
  smooth();
  imageMode(CENTER);
  hcw = new HingeCW();
  head = new Heading();
  b = new Buttons();
  i = new SettingsInterface();
  jp = new JackProofing();
  pushConfig();
}

public void draw() {
  background(0);
  fill(255);
  textSize(60);
  text("Arduinochet Interface", 0, 50);
  hcw.draw();
  head.draw();
  b.draw();
  i.draw();
  jp.draw();
  mousePressedLegit = (mousePressed && !b.blocked && !i.blocked && !jp.blocked);
}

public void mouseMoved() {
  hcw.mouseMoved();
  head.mouseMoved();
  b.mouseMoved();
  i.mouseMoved();
  jp.mouseMoved();
}

public void keyTyped() {
  i.keyTyped(); // only reacts if in something
  jp.keyTyped(); // needs to know for re-enabling
}

public void mouseClicked() {
  if (!i.blocked && !jp.blocked) b.mouseClicked(); // hcw and head take care of this in draw() to account for holding down
  if (!b.blocked && !jp.blocked) i.mouseClicked();
//  println(mouseX + "," + mouseY);
}

public void fire() {
  if (online || mega.demo) {
    link("http://upload.wikimedia.org/wikipedia/commons/8/89/Bomba_atomowa.gif");
  } else {
    mega.fire();
  }
}

public void pushConfig() {
  valuesDirty = false;
  // send configuration data over serial here
  if (mega.sendConfig(hcw.hingeCWDistance, head.currentTrebuchetHeading, b.currentArmSwitchX)) {
    println("Config pushed.");
  }
}
class Buttons {
  boolean overPushSettings = false;
  boolean overArmSwitch = false;
  int currentArmSwitchX = 300;
  int armSwitchDragStartX = -1;
  int armSwitchOriginal = -1;
  int currentBlockOpacity = 0;
  int launchStart = -1;
  boolean overLaunchButton = false;
  boolean blocked;
  
  public void drawOpaqueRect() {
    fill(0, currentBlockOpacity);
    rect(0, 0, width, height);
    if (currentArmSwitchX == 400) {
      if (currentBlockOpacity < 200) currentBlockOpacity += 2;
    } else {
      if (currentBlockOpacity > 0) currentBlockOpacity -= 2;
    }
    blocked = (currentBlockOpacity != 0);
  }
  
  public void mouseClicked() {
    if (overArmSwitch) {
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
      launchStart = millis();
    }
  }
  
  public void mouseMoved() {
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
        pushConfig();
      }
    }
    
    if (dist(525, 400, mouseX, mouseY) < (85/2)) {
      overLaunchButton = true;
    } else {
      overLaunchButton = false;
    }
  }
  
  public void draw() {
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
    drawOpaqueRect();
    // LAUNCH
    fill(100);
    rect(250, 350, 365, 100);
    // countdown
    if (launchStart != -1) {
      fill(0, currentBlockOpacity);
      rect(250, 350, 365, 100);
      textSize(75);
      if (millis() - launchStart < 1000) {
        fill(255);
        text("3", 275, 428);
      } else if (millis() - launchStart < 2000) {
        fill(255);
        text("2", 275, 428);
      } else if (millis() - launchStart < 3000) {
        fill(255);
        text("1", 275, 428);
      } else if (millis() - launchStart < 4000) {
        fill(100, 100, 255);
        text("LAUNCH", 275, 428);
      } else {
        fire();
        launchStart = -1;
        currentArmSwitchX = 300;
      }
      return;
    }
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
}
class Heading {
  int heldDownStart = -1;
  int currentTrebuchetHeading = 0; // degrees
  boolean overHeadingPlus = false;
  boolean overHeadingMinus = false;
  
  public void mouseMoved() {
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
  }
  
  public void draw() {
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
    if (mousePressedLegit && overHeadingPlus) {
      if (heldDownStart == -1) {
        heldDownStart = millis();
        currentTrebuchetHeading++;
        if (currentTrebuchetHeading == 360) {
          currentTrebuchetHeading = 0;
        }
        valuesDirty = true;
      } else {
        if (millis() - heldDownStart > 5000) {
          if (frameCount % 5 == 0) {
            currentTrebuchetHeading += 1;
            if (currentTrebuchetHeading == 360) {
              currentTrebuchetHeading = 0;
            }
            valuesDirty = true;
            if (PUSH_ON_CHANGE) {
              pushConfig();
            }
          }
        } else if (millis() - heldDownStart > 500) {
          if (frameCount % 15 == 0) {
            currentTrebuchetHeading += 1;
            if (currentTrebuchetHeading == 360) {
              currentTrebuchetHeading = 0;
            }
            valuesDirty = true;
            if (PUSH_ON_CHANGE) {
              pushConfig();
            }
          }
        }
      }
    } else if (!mousePressedLegit) {
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
    if (mousePressedLegit && overHeadingMinus) {
      if (heldDownStart == -1) {
        heldDownStart = millis();
        currentTrebuchetHeading--;
        if (currentTrebuchetHeading == -1) {
          currentTrebuchetHeading = 359;
        }
        valuesDirty = true;
      } else {
        if (millis() - heldDownStart > 5000) {
          if (frameCount % 5 == 0) {
            currentTrebuchetHeading -= 1;
            if (currentTrebuchetHeading == -1) {
              currentTrebuchetHeading = 359;
            }
            valuesDirty = true;
            if (PUSH_ON_CHANGE) {
              pushConfig();
            }
          }
        } else if (millis() - heldDownStart > 500) {
          if (frameCount % 15 == 0) {
            currentTrebuchetHeading -= 1;
            if (currentTrebuchetHeading == -1) {
              currentTrebuchetHeading = 359;
            }
            valuesDirty = true;
            if (PUSH_ON_CHANGE) {
              pushConfig();
            }
          }
        }
      }
    } else if (!mousePressedLegit) {
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
}
class HingeCW {
  int heldDownStart = -1;
  int hingeCWDistance = 0; // inches * 10
  boolean overHCWPlus = false;
  boolean overHCWMinus = false;
  
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
  }
  
  public void draw() {
    // Rectangle
    noStroke();
    fill(100);
    rect(25, 100, 590, 100);
    
    // Text
    fill(255);
    textSize(20);
    String shown = str((int) (hingeCWDistance / 10)) + "." + str(hingeCWDistance % 10); 
    text("Hinge-Counterweight Distance: " + shown + "\"", 115, 150);
    
    // Plus
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
    if (mousePressedLegit && overHCWPlus) {
      if (heldDownStart == -1) {
        heldDownStart = millis();
        hingeCWDistance += 1;
        valuesDirty = true;
      } else {
        if (millis() - heldDownStart > 5000) {
          if (frameCount % 5 == 0) {
            hingeCWDistance += 1;
            valuesDirty = true;
            if (PUSH_ON_CHANGE) {
              pushConfig();
            }
          }
        } else if (millis() - heldDownStart > 500) {
          if (frameCount % 15 == 0) {
            hingeCWDistance += 1;
            valuesDirty = true;
            if (PUSH_ON_CHANGE) {
              pushConfig();
            }
          }
        }
      }
    } else if (!mousePressedLegit) {
      heldDownStart = -1;
    }
    popMatrix();
    
    // Minus
    pushMatrix();
    if (overHCWMinus) {
      fill(0, 255, 200);
    } else {
      fill(255, 0, 0);
    }
    translate(45, 120);
    rect(0, 25, 60, 10);
    if (mousePressedLegit && overHCWMinus) {
      if (heldDownStart == -1) {
        heldDownStart = millis();
        hingeCWDistance -= 1;
        valuesDirty = true;
      } else {
        if (millis() - heldDownStart > 5000) {
          if (frameCount % 5 == 0) {
            hingeCWDistance -= 1;
            valuesDirty = true;
            if (PUSH_ON_CHANGE) {
              pushConfig();
            }
          }
        } else if (millis() - heldDownStart > 500) {
          if (frameCount % 15 == 0) {
            hingeCWDistance -= 1;
            valuesDirty = true;
            if (PUSH_ON_CHANGE) {
              pushConfig();
            }
          }
        }
      }
    } else if (!mousePressedLegit) {
      heldDownStart = -1;
    }
    popMatrix();
  }
}
// Jack is a...friend of mine.

class JackProofing {
  boolean active = true;
  boolean blocked = true;
  boolean inCorner = false;
  final int secretCode = 522577663; // cellphone numbers for "JACKPROOF"
  int readNumber = 0;
  int lastActionTime = -1;
  final int timeoutInSeconds = 10;
  boolean failed = false;
  int failTime = 0;
  
  public void mouseMoved() {
    if (mouseX == width-1 || mouseY == height-1) {
      inCorner = true;
    } else {
      inCorner = false;
    }
    lastActionTime = millis();
  }
  
  public void draw() {
    if (!active) {
      blocked = false;
      if (abs(millis() - lastActionTime) > timeoutInSeconds * 1000) {
        active = true;
      }
      return;
    }
    blocked = true; // at this point, we know that we are active, and therefore blocking the interface
    // background
    noStroke();
    if (failed) {
      fill(255, 0, 0);
      if (millis() - failTime > 5000) {
        failed = false;
      }
    } else {
      fill(0, 255, 200);
    }
    roundedRect(0, 0, width, height, 50);
    // text
    fill(255);
    textSize(50);
    if (inCorner) {
      text(str(readNumber), width/2 - ((floor(log10(readNumber))) * 25), height/2 - 75);
    }
    text("Arduinochet v0.8\nauthentication " + (failed ? "invalid" : "required"), width/2 - 270, height/2);
    pushMatrix();
    translate(width/2 - 25, height/2 + 125);
    rotate(PI/2);
    //text(":)", 0, 0);
    popMatrix();
  }
  
  public float log10(int x) {
    return (log(x) / log(10));
  }
  
  public void keyTyped() {
    if (key != BACKSPACE) {
      readNumber *= 10;
      readNumber += ((int) key) - 48; // convert to number represented
    } else {
      readNumber -= (readNumber % 10);
      readNumber /= 10;
    }
    if (readNumber == secretCode) {
      active = !active;
      if (!active) {
        lastActionTime = millis();
      }
      readNumber = 0;
    } else if (floor(log10(readNumber))+1 == 9) {
      // we have all nine digits, but we aren't perfectly matched
      failed = true;
      failTime = millis();
      readNumber = 0;
    }
  }
  
  public void roundedRect(int x, int y, int w, int h, int depth) {
    beginShape();
    vertex(w - depth, y);
    bezierVertex(w, y, w, y, w, depth);
    vertex(w, h - depth);
    bezierVertex(w, h, w, h, w - depth, h);
    vertex(depth, h);
    bezierVertex(x, h, x, h, x, h - depth);
    vertex(x, depth);
    bezierVertex(x, y, x, y, depth, y);
    endShape(CLOSE);
  }
}
    
    
class Mega {
  Serial port;
  int oldDistance = -1;
  int oldHeading = -1;
  boolean armed;
  boolean demo;
  
  public void init() {
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
  
  public boolean sendConfig(int distance, int heading, int armSwitch) {
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
  
  public void fire() {
    if (!demo) {
      port.write("f ");
      println("f ");
    }
  }
}
class SettingsInterface {
  float currentHeight = 0;
  boolean overPM; // plus/minus
  boolean overCW;
  boolean overPW; // projectile weight
  boolean overAltitude;
  boolean overPsi;
  boolean overAlpha;
  boolean overV0;
  boolean inCW;
  boolean inPW;
  boolean inAltitude;
  boolean inPsi;
  boolean inAlpha;
  boolean inV0;
  int direction = 0;
  float maxY = height - 75;
  Settings s;
  boolean blocked; // whether or not the rest of the interface is blocked
  
  public void draw() {
    pushMatrix();
    translate(600, 30);
    rotate(currentHeight/maxY * 4*PI);
    fill(255);
    ellipse(0, 0, 45, 45);
    fill(200);
    ellipse(0, 0, 40, 40);
    int fillColor;
    if (overPM) {
      fillColor = color(0, 255, 200);
    } else {
      fillColor = color(255);
    }
    fill(fillColor);
    rect(-15, -5, 30, 10);
    float r = red(fillColor);
    float g = green(fillColor);
    float b = blue(fillColor);
    float a = 255 - (currentHeight/maxY * 255);
    fill(r, g, b, a);
    rect(-5, -15, 10, 30);
    currentHeight += (direction * 4);
    if (currentHeight > maxY || currentHeight < 0) {
      direction = 0;
      currentHeight = constrain(currentHeight, 0, maxY);
    }
    blocked = (currentHeight != 0);
    popMatrix();
    fill(250);
    gradient(0, 75, width, maxY, currentHeight, color(250), color(200));
    drawWeights();
    drawAltitude();
    drawPsi();
    drawAlpha();
    drawV0();
    drawRangeEstimate();
  }
  
  public void drawV0() {
    noStroke();
    fill(100);
    rect(330, 325, 285, max(0, min(50, currentHeight-250)));
    if (currentHeight-250 > 20) {
      if (inV0) {
        fill(0, 255, 200);
      } else {
        fill(255);
      }
      textSize(20);
      text("V  (initial", 335, 345);
    }
    if (currentHeight-250 > 25) {
      textSize(15);
      text("0", 345, 350);
    }
    if (currentHeight-250 > 45) {
      textSize(20);
      text("velocity): ", 335, 370);
      text("ft/s", 580, 370);
      textSize(50);
      text(str(Settings.getV0()), 420, 370);
    }
  }
  
  public void drawAlpha() {
    noStroke();
    fill(100);
    rect(25, 325, 280, max(0, min(50, currentHeight-250)));
    if (currentHeight-250 > 20) {
      if (inAlpha) {
        fill(0, 255, 200);
      } else {
        fill(255);
      }
      textSize(20);
      text("Alpha (angle", 30, 345);
    }
    if (currentHeight-250 > 45) {
      text("of release): ", 30, 370);
      text("degrees", 230, 370);
      textSize(50);
      text(str((int) (Settings.getAlpha() * 180/PI)), 145, 370);
    }
  }
  
  public void drawRangeEstimate() {
    noStroke();
    fill(100);
    rect(25, 400, 590, max(0, min(50, currentHeight-325)));
    if (currentHeight-325 > 45) {
      fill(255);
      textSize(20);
      text("Range: ", 30, 445);
      text("ft.", 590, 445);
      textSize(50);
      float cw = Settings.getCounterweight();
//      print("cw=" + str(cw) + ", ");
      float pw = Settings.getProjectileWeight();
//      print("pw=" + str(pw) + ", ");
      float hingeCWDist = ((float) hcw.hingeCWDistance/10)/12;
//      print("hingeCWDist=" + str(hingeCWDist) + ", ");
      float psi = Settings.getPsi() * PI/180;
//      print("psi=" + str(psi) + ", ");
      float v0 = Settings.getV0();
//      print("v0=" + str(v0) + ", ");
      float a = Settings.getAlpha();
//      print("a=" + str(a) + ", ");
      int altitude = Settings.getAltitude();
//      print("altitude=" + str(altitude) + ", ");
      float r = (float) Calculation.range(cw, pw, hingeCWDist, psi, v0, a, altitude);
//      println("r=" + str(r));
      text(str(r), 100, 445);
    }
  }
  
  public void drawPsi() {
    noStroke();
    fill(100);
    rect(25, 250, 590, max(0, min(50, currentHeight-175)));
    if (currentHeight-175 > 20) {
      if (inPsi) {
        fill(0, 255, 200);
      } else {
        fill(255);
      }
      textSize(20);
      text("\u03C8 (angle formed between", 30, 270);
    }
    if (currentHeight-175 > 45) {
      text("beam and base at sling):", 30, 295);
      text("degrees", 540, 295);
      textSize(50);
      text(str(Settings.getPsi()), 260, 295);
    }
  }
  
  public void drawAltitude() {
    noStroke();
    fill(100);
    rect(25, 175, 590, max(0, min(50, currentHeight-100)));
    if (currentHeight-100 > 45) {
      if (inAltitude) {
        fill(0, 255, 200);
      } else {
        fill(255);
      }
      textSize(20);
      text("Altitude:", 30, 220);
      text("ft. above sea level", 450, 220);
      textSize(50);
      text(str(Settings.getAltitude()), 110, 220);
    }
  }
  
  public void drawWeights() {
    // counterweight
    noStroke();
    fill(100);
    rect(25, 100, 295, max(0, min(50, currentHeight-25)));
    if (currentHeight-25 > 20) {
      if (inCW) {
        fill(0, 255, 200);
      } else {
        fill(255);
      }
      textSize(20);
      text("Counter", 30, 120);
    }
    if (currentHeight-25 > 45) {
      text("weight: ", 30, 145);
      text("lbs.", 280, 145);
      textSize(50);
      text(str(Settings.getCounterweight()), 100, 145);
    }
    // projectile
    noStroke();
    fill(100);
    rect(345, 100, 270, max(0, min(50, currentHeight-25)));
    if (currentHeight-25 > 20) {
      if (inPW) {
        fill(0, 255, 200);
      } else {
        fill(255);
      }
      textSize(20);
      text("Projectile", 350, 120);
    }
    if (currentHeight-25 > 45) {
      text("weight: ", 350, 145);
      text("lbs.", 575, 145);
      textSize(50);
      text(str(Settings.getProjectileWeight()), 435, 145);
    }
  }
  
  public void gradient(int x, int y, float w, float h, float aH, int c1, int c2) {
    if (aH == 0) return;
    float deltaR = red(c2)-red(c1);
    float deltaG = green(c2)-green(c1);
    float deltaB = blue(c2)-blue(c1);
    for (int j = y; j<=(y+aH); j++){
      float r = (red(c1)+(j-y)*(deltaR/h));
      float g = (green(c1)+(j-y)*(deltaG/h));
      float b = (blue(c1)+(j-y)*(deltaB/h));
      int c = color(r, g, b);
      stroke(c);
      line(x, j, x+w, j);
    }
  }
  
  public void mouseMoved() {
    if (dist(600, 30, mouseX, mouseY) < 45/2) {
      overPM = true;
    } else {
      overPM = false;
    }
    
    if (mouseX > 25 && mouseY > 100 && mouseX < (25 + 295) && mouseY < (100 + max(0, min(50, currentHeight-25)))) {
      overCW = true;
    } else {
      overCW = false;
    }
    
    if (mouseX > 345 && mouseY > 100 && mouseX < (345 + 270) && mouseY < (100 + max(0, min(50, currentHeight-25)))) {
      overPW = true;
    } else {
      overPW = false;
    }
    
    if (mouseX > 25 && mouseY > 175 && mouseX < (25 + 590) && mouseY < (175 + max(0, min(50, currentHeight-100)))) {
      overAltitude = true;
    } else {
      overAltitude = false;
    }
    
    if (mouseX > 25 && mouseY > 250 && mouseX < (25 + 590) && mouseY < (250 + max(0, min(50, currentHeight-175)))) {
      overPsi = true;
    } else {
      overPsi = false;
    }
    
    if (mouseX > 25 && mouseY > 325 && mouseX < (25 + 280) && mouseY < (325 + max(0, min(50, currentHeight-250)))) {
      overAlpha = true;
    } else {
      overAlpha = false;
    }
    
    if (mouseX > 330 && mouseY > 325 && mouseX < (330 + 285) && mouseY < (325 + max(0, min(50, currentHeight-250)))) {
      overV0 = true;
    } else {
      overV0 = false;
    }
  }
  
  public void keyTyped() {
    if (inCW) {
      if (key >= '0' && key <= '9') {
        int cw = Settings.getCounterweight();
        Settings.setCounterweight((cw * 10) + ((int) key) - 48);
      } else if (key == '.') {
        // TODO use this
      } else if (key == BACKSPACE) { // backspace
        int cw = Settings.getCounterweight();
        Settings.setCounterweight((cw - (cw % 10))/10);
      }
    } else if (inPW) {
      if (key >= '0' && key <= '9') {
        int pw = Settings.getProjectileWeight();
        Settings.setProjectileWeight((pw * 10) + ((int) key) - 48);
      } else if (key == '.') {
        // TODO use this
      } else if (key == BACKSPACE) { // backspace
        int pw = Settings.getProjectileWeight();
        Settings.setProjectileWeight((pw - (pw % 10))/10);
      }
    } else if (inAltitude) {
      if (key >= '0' && key <= '9') {
        int a = Settings.getAltitude();
        Settings.setAltitude((a * 10) + ((int) key) - 48);
      } else if (key == '.') {
        // TODO use this
      } else if (key == BACKSPACE) { // backspace
        int a = Settings.getAltitude();
        Settings.setAltitude((a - (a % 10))/10);
      }
    } else if (inPsi) {
      if (key >= '0' && key <= '9') {
        int a = Settings.getPsi();
        Settings.setPsi((a * 10) + ((int) key) - 48);
      } else if (key == '.') {
        // TODO use this
      } else if (key == BACKSPACE) { // backspace
        int a = Settings.getPsi();
        Settings.setPsi((a - (a % 10))/10);
      }
    } else if (inAlpha) {
      if (key >= '0' && key <= '9') {
        int a = (int) (Settings.getAlpha() * 180/PI);
        Settings.setAlpha(((a*10) + ((int) key) - 48)*PI/180);
      } else if (key == '.') {
        // TODO use this
      } else if (key == BACKSPACE) {
        int a = (int) (Settings.getAlpha() * 180/PI);
        Settings.setAlpha(((a - (a % 10))/10)*PI/180);
      }
    } else if (inV0) {
      if (key >= '0' && key <= '9') {
        int a = Settings.getV0();
        Settings.setV0((a * 10) + ((int) key) - 48);
      } else if (key == '.') {
        // TODO use this
      } else if (key == BACKSPACE) { // backspace
        int a = Settings.getV0();
        Settings.setV0((a - (a % 10))/10);
      }
    }
  }
  
  public void mouseClicked() {
    inCW = false;
    inPW = false;
    inAltitude = false;
    inPsi = false;
    inAlpha = false;
    inV0 = false;
    if (overPM) {
      if (direction == 0) {
        direction = (currentHeight == 0 ? 1 : -1);
      } else {
        direction = -1 * direction;
      }
    } else if (overCW) {
      inCW = true;
    } else if (overPW) {
      inPW = true;
    } else if (overAltitude) {
      inAltitude = true;
    } else if (overPsi) {
      inPsi = true;
    } else if (overAlpha) {
      inAlpha = true;
    } else if (overV0) {
      inV0 = true;
    }
  }
  
  SettingsInterface() {
    Settings.init();
  }
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#F0F0F0", "computer_interface" });
  }
}
