class SettingsInterface {
  float currentHeight = 0;
  boolean overPM; // plus/minus
  boolean overCW;
  boolean overPW; // projectile weight
  boolean overAltitude;
  boolean overPsi;
  boolean inCW;
  boolean inPW;
  boolean inAltitude;
  boolean inPsi;
  int direction = 0;
  float maxY = height - 75;
  Settings s;
  
  void draw() {
    pushMatrix();
    translate(600, 30);
    rotate(currentHeight/maxY * 4*PI);
    fill(255);
    ellipse(0, 0, 45, 45);
    fill(200);
    ellipse(0, 0, 40, 40);
    color fillColor;
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
    popMatrix();
    fill(250);
    gradient(0, 75, width, maxY, currentHeight, color(250), color(200));
    drawWeights();
    drawAltitude();
    drawPsi();
  }
  
  void drawPsi() {
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
      text("degrees", 500, 295);
      textSize(50);
      text(str(Settings.getPsi()), 260, 295);
    }
  }
  
  void drawAltitude() {
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
  
  void drawWeights() {
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
      text("lbs.", 290, 145);
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
      text("lbs.", 585, 145);
      textSize(50);
      text(str(Settings.getProjectileWeight()), 435, 145);
    }
  }
  
  void gradient(int x, int y, float w, float h, float aH, color c1, color c2) {
    if (aH == 0) return;
    float deltaR = red(c2)-red(c1);
    float deltaG = green(c2)-green(c1);
    float deltaB = blue(c2)-blue(c1);
    for (int j = y; j<=(y+aH); j++){
      float r = (red(c1)+(j-y)*(deltaR/h));
      float g = (green(c1)+(j-y)*(deltaG/h));
      float b = (blue(c1)+(j-y)*(deltaB/h));
      color c = color(r, g, b);
      stroke(c);
      line(x, j, x+w, j);
    }
  }
  
  void mouseMoved() {
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
  }
  
  void keyTyped() {
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
    }
  }
  
  void mouseClicked() {
    inCW = false;
    inPW = false;
    inAltitude = false;
    inPsi = false;
    if (overPM) {
      direction = (currentHeight == 0 ? 1 : -1);
    } else if (overCW) {
      inCW = true;
    } else if (overPW) {
      inPW = true;
    } else if (overAltitude) {
      inAltitude = true;
    } else if (overPsi) {
      inPsi = true;
    }
  }
  
  SettingsInterface() {
    Settings.init();
  }
}
