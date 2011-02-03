class HingeCW {
  int heldDownStart = -1;
  int hingeCWDistance = 0; // inches * 10
  boolean overHCWPlus = false;
  boolean overHCWMinus = false;
  
  void mouseMoved() {
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
  
  void draw() {
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
    if (mousePressed && overHCWPlus) {
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
    } else if (!mousePressed) {
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
    if (mousePressed && overHCWMinus) {
      if (heldDownStart == -1) {
        heldDownStart = millis();
        hingeCWDistance -= 1;
        valuesDirty = true;
      } else {
        if (millis() - heldDownStart > 500) {
          if (frameCount % 15 == 0) {
            hingeCWDistance -= 1;
            valuesDirty = true;
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
}
