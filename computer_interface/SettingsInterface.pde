class SettingsInterface {
  float currentHeight = 0;
  boolean overPM;
  boolean overCW;
  boolean inCW;
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
    fill(red(fillColor), green(fillColor), blue(fillColor), 255 - (currentHeight/maxY * 255));
    rect(-5, -15, 10, 30);
    currentHeight += (direction * 4);
    if (currentHeight > maxY || currentHeight < 0) {
      direction = 0;
      currentHeight = constrain(currentHeight, 0, maxY);
    }
    popMatrix();
    fill(250);
    gradient(0, 75, width, maxY, currentHeight, color(250), color(200));
    drawMasses();
  }
  
  void drawMasses() {
    // counterweight
    noStroke();
    fill(100);
    rect(25, 100, 200, max(0, min(50, currentHeight-25)));
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
      text("lbs.", 195, 145);
      textSize(50);
      text(str(Settings.getCounterweight()), 100, 145);
    }
    // projectile
    
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
    
    if (mouseX > 25 && mouseY > 100 && mouseX < (25 + 200) && mouseY < (100 + max(0, min(50, currentHeight-25)))) {
      overCW = true;
    } else {
      overCW = false;
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
      } else {
        println(key);
        println((int) key);
        println(BACKSPACE);
        println(keyCode);
      }
    }
  }
  
  void mouseClicked() {
    inCW = false;
    if (overPM) {
      direction = (currentHeight == 0 ? 1 : -1);
    } else if (overCW) {
      inCW = true;
    }
  }
  
  SettingsInterface() {
    Settings.init();
  }
}
