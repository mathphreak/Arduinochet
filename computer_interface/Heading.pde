class Heading {
  int heldDownStart = -1;
  int currentTrebuchetHeading = 0; // degrees
  boolean overHeadingPlus = false;
  boolean overHeadingMinus = false;
  
  void mouseMoved() {
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
  
  void draw() {
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
        currentTrebuchetHeading++;
        if (currentTrebuchetHeading == 360) {
          currentTrebuchetHeading = 0;
        }
        valuesDirty = true;
      } else {
        if (millis() - heldDownStart > 500) {
          if (frameCount % 5 == 0) {
            currentTrebuchetHeading++;
            valuesDirty = true;
            if (currentTrebuchetHeading == 360) {
              currentTrebuchetHeading = 0;
            }
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
        currentTrebuchetHeading--;
        if (currentTrebuchetHeading == -1) {
          currentTrebuchetHeading = 359;
        }
        valuesDirty = true;
      } else {
        if (millis() - heldDownStart > 500) {
          if (frameCount % 5 == 0) {
            currentTrebuchetHeading--;
            valuesDirty = true;
            if (currentTrebuchetHeading == -1) {
              currentTrebuchetHeading = 359;
            }
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
}
