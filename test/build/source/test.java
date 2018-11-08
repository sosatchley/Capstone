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

public class test extends PApplet {

PShape shape;
Boolean running;
float startx;
float starty;
int v;

public void setup() {
frameRate(60);
background(0);
stroke(255, 0, 0);
strokeWeight(5);
fill(92, 249, 126);

this.running = false;
}

public void draw() {
    if (this.running) {
        updateShape(mouseX, mouseY);
    }
    if (this.shape != null) {
        shape(this.shape);
    }
}
public void mousePressed() {
    test();
}

public void test() {
    running = true;
    noFill();
    this.startx = mouseX;
    this.starty = mouseY;
    rect(this.startx-15, this.starty-15, 30, 30);
    this.v = 0;
    this.shape = createShape();
    this.shape.beginShape();
    this.shape.stroke(112, 143, 250);

}

public void updateShape(float x, float y) {
    if (!fieldComplete(x, y)) {
        this.shape.vertex(x,y);
        this.v++;
        point(x,y);
    }
}


public Boolean fieldComplete(float x, float y) {
    if (this.v < 20) {
        return false;
    }
    if ((x > this.startx-15 && x < this.startx + 15) && (y > this.starty-15 && y < this.starty+15)) {
        this.running = false;
        this.shape.fill(87, 43, 163);
        this.shape.endShape(CLOSE);

    }
    return false;

}

  public void settings() { 
size(1500,1500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "test" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
