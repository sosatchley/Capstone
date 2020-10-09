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

public class ViewInterface extends PApplet {

Frame f;

public void setup() {
    
    f = new Frame(150,150);
}

public void draw() {
    background(20);
    f.render();
}

public void keyPressed() {
    if (keyCode == 1) {
        f.shape = new Circ(50,18);
    } else if (keyCode == 2) {
        f.shape = new Sqr(260,188);
    } else if (keyCode == 3) {
        f.shape = new Tri(435,350);
    }
}

class Frame {
    float x;
    float y;
    Shape shape;

    Frame(float x, float y) {
        this.x = x;
        this.y = y;
    }

    public void render() {
        fill(0);
        stroke(100);
        strokeWeight(3);
        rect(this.x, this.y, 500, 500);
        if (this.shape != null) {
            pushMatrix();
            translate(this.x, this.y);
            this.shape.display();
            popMatrix();
        }
    }
}

interface Shape {
    // float x;
    // float y;
    // PShape shape;
    public void display();
}

class Sqr implements Shape {
    float x;
    float y;
    PShape shape;
    Sqr(float x, float y) {
        this.shape = createShape(RECT, 0, 0, 50, 50);
        this.x = x;
        this.y = y;
    }

    public void display() {

        fill(58,24,125);
        stroke(100);
        strokeWeight(3);
        shape(this.shape, this.x, this.y);
    }
}

class Circ implements Shape {
    float x;
    float y;
    PShape shape;
    Circ(float x, float y) {
        this.shape = createShape(ELLIPSE, -25, 0, 50, 50);
        this.x = x;
        this.y = y;
    }

    public void display() {
        fill(200,15,73);
        stroke(100);
        strokeWeight(3);
        shape(this.shape, this.x, this.y);
    }
}

class Tri implements Shape {
    float x;
    float y;
    PShape shape;
    Tri(float x, float y) {
        this.shape = createShape();
        this.shape.beginShape(TRIANGLE_STRIP);
        this.shape.setFill(50, 150);
        this.shape.vertex(30, 75);
        this.shape.vertex(40, 20);
        this.shape.vertex(50, 75);
        this.shape.vertex(60, 20);
        this.shape.vertex(70, 75);
        this.shape.vertex(80, 20);
        this.shape.vertex(90, 75);
        this.shape.endShape();
        this.x = x;
        this.y = y;
    }

    public void display() {
        shape(this.shape, this.x, this.y);
    }
}
  public void settings() {  size(800, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ViewInterface" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
