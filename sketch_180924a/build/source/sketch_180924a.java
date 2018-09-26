import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sketch_180924a extends PApplet {

// Shane Atchley
// CSCI 410
// Auto-Steer Simulation


Agent t;

public void setup() {
  
  t = new Agent();
}

public void draw() {
  background(0);
  t.display();
  t.turn();
  t.update();
}

public void keyPressed() {
  if (keyCode == RIGHT) {
    t.setRotation(0.1f);
  } else if (keyCode == LEFT) {
    t.setRotation(-0.1f);
  } else if (keyCode == UP) {
    t.throttle();
  }
}

public void keyReleased() {
  t.setRotation(0);
}

  public void settings() {  size(1000, 1000); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_180924a" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
