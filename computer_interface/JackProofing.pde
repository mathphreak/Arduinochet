// Jack is a...friend of mine.

class JackProofing {
  boolean active = true;
  boolean blocked = true;
  boolean inCorner = false;
  final int secretCode = 522577663; // cellphone numbers for "JACKPROOF"
  int readNumber = 0;
  int lastActionTime = -1;
  final int timeoutInSeconds = 10;
  
  void mouseMoved() {
    if (mouseX == width-1 || mouseY == height-1) {
      inCorner = true;
    } else {
      inCorner = false;
    }
    lastActionTime = millis();
  }
  
  void draw() {
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
    fill(0, 255, 200);
    roundedRect(0, 0, width, height, 50);
    // text
    fill(255);
    textSize(50);
    if (inCorner) {
      text(str(readNumber), width/2 - ((floor(log10(readNumber))) * 25), height/2 - 75);
    }
    text("This program is Jack-proof", width/2 - 290, height/2 + 25);
    pushMatrix();
    translate(width/2 - 25, height/2 + 125);
    rotate(PI/2);
    text(":)", 0, 0);
    popMatrix();
  }
  
  float log10(int x) {
    return (log(x) / log(10));
  }
  
  void keyTyped() {
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
    }
  }
  
  void roundedRect(int x, int y, int w, int h, int depth) {
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
    
    
