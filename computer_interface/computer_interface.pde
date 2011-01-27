int hingeCWDistance = 20; // inches
int currentTrebuchetHeading = 0; // degrees
boolean overHCWPlus = false;
boolean overHCWMinus = false;
boolean overHeadingPlus = false;
boolean overHeadingMinus = false;

void setup() {
  size(640, 480);
}

void draw() {
  background(0);
  fill(255);
  textSize(67);
  text("Arduinochet Interface", 0, 50);
  drawHCW();
  drawHeading();
  drawButtons();
}

void drawButtons() {
  
}

void drawHCW() {
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
  popMatrix();
  pushMatrix();
  if (overHCWMinus) {
    fill(0, 255, 200);
  } else {
    fill(255, 0, 0);
  }
  translate(45, 120);
  rect(0, 25, 60, 10);
  popMatrix();
}

void drawHeading() {
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
  popMatrix();
  pushMatrix();
  if (overHeadingMinus) {
    fill(0, 255, 200);
  } else {
    fill(255, 0, 0);
  }
  translate(45, 245);
  rect(0, 25, 60, 10);
  popMatrix();
  pushMatrix();
  translate(400, 260);
  rotate(currentTrebuchetHeading * PI/180);
  fill(255);
  stroke(0);
  ellipse(0, 0, 10, 10);
  stroke(0);
  line(0, 0, 0, -5);
  popMatrix();
}

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

void mouseClicked() {
  if (overHCWPlus) {
    hingeCWDistance++;
  } else if (overHCWMinus) {
    hingeCWDistance--;
  } else if (overHeadingMinus) {
    currentTrebuchetHeading--;
  } else if (overHeadingPlus) {
    currentTrebuchetHeading++;
  } else {
    println(mouseX + "," + mouseY);
  }
}
