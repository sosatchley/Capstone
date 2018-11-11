PShape shape;
Boolean running;
float startx;
float starty;
int v;

void setup() {
frameRate(60);
background(0);
stroke(255, 0, 0);
strokeWeight(5);
fill(92, 249, 126);
size(1500,1500);
this.running = false;
}

void draw() {
    if (this.running) {
        updateShape(mouseX, mouseY);
    }
    if (this.shape != null) {
        shape(this.shape);
    }
}
void mousePressed() {
    test();
}

void test() {
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

void updateShape(float x, float y) {
    if (!fieldComplete(x, y)) {
        this.shape.vertex(x,y);
        this.v++;
        point(x,y);
    }
}


Boolean fieldComplete(float x, float y) {
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
