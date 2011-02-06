class Buttons {
  boolean overPushSettings = false;
  boolean overArmSwitch = false;
  int currentArmSwitchX = 300;
  int armSwitchDragStartX = -1;
  int armSwitchOriginal = -1;
  int currentBlockOpacity = 0;
  int launchStart = -1;
  boolean overLaunchButton = false;
  boolean blocked = false;
  
  void drawOpaqueRect() {
    pushMatrix();
    translate(200, 500, 50);
    rotateX(PI - QUARTER_PI);
    rotateY(-QUARTER_PI);
    rotateZ(0.2*PI);
    translate(0, -50, thickness*4);
    fill(0, currentBlockOpacity);
    rect(0, 0, width, height);
    if (currentArmSwitchX == 400) {
      if (currentBlockOpacity < 200) currentBlockOpacity += 2;
    } else {
      if (currentBlockOpacity > 0) currentBlockOpacity -= 2;
    }
    blocked = (currentBlockOpacity != 0);
    popMatrix();
  }
  
  void mouseClicked() {
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
  
  void mouseMoved() {
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
  
  void draw() {
    // Push Config
    pushMatrix();
    translate(200, 500, 50);
    rotateX(PI - QUARTER_PI);
    rotateY(-QUARTER_PI);
    rotateZ(0.2*PI);
    translate(0, -50, 0);
    noStroke();
    fill(100);
    rect(25, 350, 200, 100);
    popMatrix();
    
    pushMatrix();
    translate(200, 500, 50);
    rotateX(PI - QUARTER_PI);
    rotateY(-QUARTER_PI);
    rotateZ(0.2*PI);
    translate(0, -50, thickness);
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
    popMatrix();
    
//    drawOpaqueRect();
    // LAUNCH
    pushMatrix();
    translate(200, 500, 50);
    rotateX(PI - QUARTER_PI);
    rotateY(-QUARTER_PI);
    rotateZ(0.2*PI);
    translate(0, -50, thickness*5);
    fill(100);
    rect(250, 350, 365, 100);
    popMatrix();
    // countdown
    if (launchStart != -1) {
      pushMatrix();
      translate(200, 500, 50);
      rotateX(PI - QUARTER_PI);
      rotateY(-QUARTER_PI);
      rotateZ(0.2*PI);
      translate(0, -50, thickness*6);
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
      popMatrix();
      return;
    }
    // launch slider
    pushMatrix();
    translate(200, 500, 50);
    rotateX(PI - QUARTER_PI);
    rotateY(-QUARTER_PI);
    rotateZ(0.2*PI);
    translate(0, -50, thickness*6);
    stroke(255);
    line(300, 400, 400, 400);
    popMatrix();
    
    pushMatrix();
    translate(200, 500, 50);
    rotateX(PI - QUARTER_PI);
    rotateY(-QUARTER_PI);
    rotateZ(0.2*PI);
    translate(0, -50, thickness*7);
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
    } else if (overArmSwitch && armSwitchDragStartX == -1) {
      fill(200, 100, 0);
    } else if (armSwitchDragStartX == -1) {
      fill(200, 50, 0);
    } else {
      fill(200, 0, 50);
    }
    rect(currentArmSwitchX - 20, 375, 40, 50);
    popMatrix();
    // launch button
    pushMatrix();
    translate(200, 500, 50);
    rotateX(PI - QUARTER_PI);
    rotateY(-QUARTER_PI);
    rotateZ(0.2*PI);
    translate(0, -50, thickness*7);
    if (currentArmSwitchX == 400) {
      fill((millis() % 1000 > 500) ? 255 : 200, 0, 0);
    } else {
      fill(50, 0, 0);
    }
    ellipse(525, 400, 90, 90);
    popMatrix();
    pushMatrix();
    translate(200, 500, 50);
    rotateX(PI - QUARTER_PI);
    rotateY(-QUARTER_PI);
    rotateZ(0.2*PI);
    translate(0, -50, thickness*8);
    if (currentArmSwitchX == 400) {
      fill((millis() % 1000 > 500) ? 200 : 150, 0, 0);
    } else {
      fill(50, 0, 0);
    }
    ellipse(525, 400, 85, 85);
    popMatrix();
    pushMatrix();
    translate(200, 500, 50);
    rotateX(PI - QUARTER_PI);
    rotateY(-QUARTER_PI);
    rotateZ(0.2*PI);
    translate(0, -50, thickness*9);
    fill(50, 0, 0);
    text("Launch!", 500, 405);
    popMatrix();
  }
}
