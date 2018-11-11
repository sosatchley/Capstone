
/**
* ControlP5 Toggle
*
*
* find a list of public methods available for the Toggle Controller
* at the bottom of this sketch.
*
* by Andreas Schlegel, 2011
* www.sojamo.de/libraries/controlp5
*
*/


import controlP5.*;

ControlP5 cp5;

int col = color(255);

boolean toggleValue = false;

void setup() {
  size(400,400);
  smooth();
  cp5 = new ControlP5(this);

  // create a toggle
  cp5.addToggle("toggleValue")
     .setPosition(40,100)
     .setSize(50,20)
     ;

  // create a toggle and change the default look to a (on/off) switch look
  cp5.addToggle("toggle")
     .setPosition(40,250)
     .setSize(50,20)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;

}


void draw() {
  background(0);

  pushMatrix();

  if(toggleValue==true) {
    fill(255,255,220);
  } else {
    fill(128,128,110);
  }
  translate(280,100);
  ellipse(0,0,100,100);


  translate(0,150);
  fill(col);
  ellipse(0,0,40,40);

  popMatrix();
}



void toggle(boolean theFlag) {
  if(theFlag==true) {
    col = color(255);
  } else {
    col = color(100);
  }
  println("a toggle event.");
}
