int hingeCWDistance = 30; // inches
int currentTrebuchetHeading = 0; // degrees

void setup() {
  size(640, 480);
}

void draw() {
  background(0);
  fill(255);
  textSize(67);
  text("Arduinochet Interface", 0, 50);
  fill(100);
  rect(25, 100, 590, 100);
  fill(255);
  textSize(20);
  text("Hinge-Counterweight Distance: " + hingeCWDistance + "\"", 115, 150);
  pushMatrix();
  translate(545, 120);
  fill(255, 0, 0);
  noStroke();
  rect(25, 0, 10, 60);
  rect(0, 25, 60, 10);
  popMatrix();
  pushMatrix();
  translate(45, 120);
  rect(0, 25, 60, 10);
  popMatrix();
}
