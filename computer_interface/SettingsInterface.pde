class SettingsInterface {
  float currentBottomY = 0;
  boolean overPM;
  int direction = 0;
  float maxY = height - 75;
  
  void draw() {
    pushMatrix();
    translate(600, 30);
    rotate(currentBottomY/maxY * 4*PI);
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
    float a = 255 - (currentBottomY/maxY * 255);
    fill(red(fillColor), green(fillColor), blue(fillColor), 255 - (currentBottomY/maxY * 255));
    rect(-5, -15, 10, 30);
    currentBottomY += direction;
    if (currentBottomY == maxY || currentBottomY == 0) {
      direction = 0;
    }
    popMatrix();
    fill(250);
    rect(0, 75, width, currentBottomY);
    gradient(0, 75, width, currentBottomY, color(250), color(200));
  }
  
  void gradient(int x, int y, float w, float h, color c1, color c2) {
    float deltaR = red(c2)-red(c1);
    float deltaG = green(c2)-green(c1);
    float deltaB = blue(c2)-blue(c1);
    /*nested for loops set pixels
     in a basic table structure */
    // column
    for (int i=x; i<=(x+w); i++){
      // row
      for (int j = y; j<=(y+h); j++){
        color c = color(
        (red(c1)+(j-y)*(deltaR/h)),
        (green(c1)+(j-y)*(deltaG/h)),
        (blue(c1)+(j-y)*(deltaB/h)) 
          );
        set(i, j, c);
      }
    }  
  }
  
  void mouseMoved() {
    if (dist(600, 30, mouseX, mouseY) < 45/2) {
      overPM = true;
    } else {
      overPM = false;
    }
  }
  
  void mouseClicked() {
    if (overPM) {
      direction = (currentBottomY == 0 ? 1 : -1);
    }
  }
}
