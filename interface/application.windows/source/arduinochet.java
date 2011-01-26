import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class arduinochet extends PApplet {

int hingeCWDistance = 30; // inches
int currentTrebuchetHeading = 0; // degrees

public void setup() {
  size(640, 480);
}

public void draw() {
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
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#F0F0F0", "arduinochet" });
  }
}
