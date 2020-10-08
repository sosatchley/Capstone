ScrollRect scrollRect;        // the vertical scroll bar
float heightOfCanvas = 3000;  // realHeight of the entire scene

void setup() {
  size(1280, 720);
  scrollRect = new ScrollRect();
  background(90);
}

void draw() {
  background(90);
  scene();
  scrollRect.display();
  scrollRect.update();
}

// --------------------------------------------------------------

void scene() {
  pushMatrix();

  // reading scroll bar
  float newYValue = scrollRect.scrollValue();
  translate (0, newYValue);

  // The scene :
  stroke(255);
  rect( 66, height/2,
    110, 2100);
  ellipse(372, height-55,
    260, 260);
  ellipse(472, height+855,
    260, 260);

  fill(255, 2, 2); //red
  ellipse(372, heightOfCanvas-6,
    6, 6);
  text("End of virtual canvas", 380, heightOfCanvas-16);
  fill(122);
  popMatrix();
}

// --------------------------------------------------------------

void mousePressed() {
  scrollRect.mousePressedRect();
}

void mouseReleased() {
  scrollRect.mouseReleasedRect();
}

void mouseWheel(MouseEvent event) {
    // hud.currentView = ViewMode.PAN;
    float e = event.getCount()*5;
    scrollRect.rectPosY += e;
}

// ===============================================================

class ScrollRect {

  float rectPosX=0;
  float rectPosY=0;
  float rectWidth=14;
  float rectHeight=30;

  boolean holdScrollRect=false;

  float offsetMouseY;

  //constr
  ScrollRect() {
    // you have to make a scrollRect in setup after size()
    rectPosX=width-rectWidth-1;
  }//constr

  void display() {
    fill(122);
    stroke(0);
    line (rectPosX-1, 0,
      rectPosX-1, height);
    rect(rectPosX, rectPosY,
      rectWidth, rectHeight);

    // Three small lines in the center
    centerLine(-3);
    centerLine(0);
    centerLine(3);
  }

  void centerLine(float offset) {
    line(rectPosX+3, rectPosY+rectHeight/2+offset,
      rectPosX+rectWidth-3, rectPosY+rectHeight/2+offset);
  }

  void mousePressedRect() {
    if (mouseOver()) {
      holdScrollRect=true;
      offsetMouseY=mouseY-rectPosY;
    }
  }

  void mouseReleasedRect() {
    scrollRect.holdScrollRect=false;
  }

  void update() {
    // dragging of the mouse
    if (holdScrollRect) {
      rectPosY=mouseY-offsetMouseY;
      if (rectPosY<0)
        rectPosY=0;
      if (rectPosY+rectHeight>height-1)
        rectPosY=height-rectHeight-1;
    }
  }

  float scrollValue() {
    return
      map(rectPosY,
      0, height-rectHeight,
      0, - (heightOfCanvas - height));
  }

  boolean mouseOver() {
    return mouseX>rectPosX&&
      mouseX<rectPosX+rectWidth&&
      mouseY>rectPosY&&
      mouseY<rectPosY+rectHeight;
  }//function
  //
}//class
//
