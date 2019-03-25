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

public class sketch_181106a extends PApplet {


PShape s;

public void setup() {

s = createShape();
s.beginShape();
s.vertex(0, 0);
s.vertex(60, 0);
s.vertex(60, 60);
s.vertex(0, 60);
s.endShape(CLOSE);
}

public void draw() {
translate(20, 20);
for (int i = 0; i < s.getVertexCount(); i++) {
PVector v = s.getVertex(i);
v.x += random(-1, 1);
v.y += random(-1, 1);
s.setVertex(i, v);
}
shape(s);
}
  public void settings() { 
size(100, 100); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_181106a" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
