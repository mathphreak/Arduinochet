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
    pushMatrix();
    translate(200, 500, 50);
    rotateX(PI - QUARTER_PI);
    rotateY(-QUARTER_PI);
    rotateZ(0.2*PI);
    translate(0, -50, 0);
    fill(100);
    rect(25, 225, 590, 100);
    popMatrix();
    
    pushMatrix();
    translate(200, 500, 50);
    rotateX(PI - QUARTER_PI);
    rotateY(-QUARTER_PI);
    rotateZ(0.2*PI);
    fill(255);
    textSize(20);
    translate(0, -50, thickness);
    text("Heading: " + currentTrebuchetHeading + "\u00b0", 115, 275, 0);
    popMatrix();
    
    pushMatrix();
    translate(200, 500, 50);
    rotateX(PI - QUARTER_PI);
    rotateY(-QUARTER_PI);
    rotateZ(0.2*PI);
    translate(0, -50, thickness);
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
    translate(200, 500, 50);
    rotateX(PI - QUARTER_PI);
    rotateY(-QUARTER_PI);
    rotateZ(0.2*PI);
    translate(0, -50, thickness);
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
    translate(200, 500, 50);
    rotateX(PI - QUARTER_PI);
    rotateY(-QUARTER_PI);
    rotateZ(0.2*PI);
    translate(0, -50, thickness);
    translate(400, 260);
    rotate(currentTrebuchetHeading * PI/180);
    fill(255);
    stroke(0);
    ellipse(0, 0, 20, 20);
    line(0, 0, 0, -10);
    popMatrix();
  }
}
