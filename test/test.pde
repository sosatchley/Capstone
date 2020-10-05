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
    background(0);
    drawGrid();
    if (this.running) {
        updateShape(mouseX, mouseY);
    }
    if (this.shape != null) {
        shape(this.shape);
    }
    if (get(mouseX, mouseY) == -11064413) {
        rayCast();
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
    this.shape.strokeWeight(100);

}

void updateShape(float x, float y) {
    if (!fieldComplete(x, y)) {
        this.shape.vertex(x,y);
        this.v++;
        point(x,y);
    }
}

void drawGrid() {
    stroke(1, 255, 0);
    strokeWeight(1);
    fill(1, 255, 0);
    textSize(32);
    int Units = 10;
    for (int i = 0; i < Units; i++) {
        line(i * (width/Units), 0, i * (width/Units), height);
        text(i * (width/Units), (i * width/Units), 0+32);
        line(0, i * (height/Units), width, i * (height/Units));
        text(i * (height/Units), 0, i * (height/Units)+32);
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
        for (int i = 0; i < this.v; i++) {
            PVector vertex = this.shape.getVertex(i);
            strokeWeight(10);
            stroke(255, 0, 0);
            point(vertex.x, vertex.y);
        }

    }
    return false;
}

void rayCast() {
    // println(get(mouseX, mouseY));
    stroke(255, 0, 0);
    fill(255, 0, 0);
    textSize(20);
    strokeWeight(5);
    int cursorPixelColor = get(mouseX, mouseY);
    //Up
    int up = bruteRayY(mouseY, cursorPixelColor, -1);
    line(mouseX, mouseY-12, mouseX, up);
    text(mouseY - up, mouseX, up);
    //DOWN
    int down = bruteRayY(mouseY, cursorPixelColor, 1);
    line(mouseX, mouseY+12, mouseX, down);
    text(down - mouseY, mouseX, down);
    //LEFT
    int left = bruteRayX(mouseX, cursorPixelColor, -1);
    line(mouseX-12, mouseY, left, mouseY);
    text(mouseX - left, left, mouseY-5);
    //Right
    int right = bruteRayX(mouseX, cursorPixelColor, 1);
    line(mouseX+12, mouseY, right, mouseY);
    text(right - mouseX, right, mouseY-5);
    //Extensions
    stroke(255, 187, 0);
    int upExt = bruteRayY(up, get(mouseX, up-50), -1);
    line(mouseX, up, mouseX, upExt);
    text(up - upExt, mouseX, upExt);
    int downExt = bruteRayY(down, get(mouseX, down+50), 1);
    line(mouseX, down, mouseX, downExt);
    text(downExt - down, mouseX, downExt);
    int leftExt = bruteRayX(left, get(left, mouseY-50), -1);
    line(left, mouseY, leftExt, mouseY);
    text(left - leftExt, leftExt, mouseY-5);
    int rightExt = bruteRayX(right, get(right, mouseY+50), 1);
    line(right, mouseY, rightExt, mouseY);
    text(rightExt - right, rightExt, mouseY-5);
}

int bruteRayY(int start, int targetColor, int direction) {

    for (int i = start; i < height; i+=direction) {
        if (get(mouseX, i) != targetColor){
            if (get(mouseX, i) == -16646400 ||
                get(mouseX, i) == -65536) {
                continue;
            }
            return i;
        }
    }
    return (direction > 0) ? height : 0;
}

int bruteRayX(int start, int targetColor, int direction) {
    for (int i = start; i < width; i+=direction) {
        if (get(i, mouseY) != targetColor) {
            if (get(i, mouseY) == -16646400 ||
                get(i, mouseY) == -65536) {
                continue;
            }
            return i;
        }
    }
    return (direction > 0) ? width : 0;
}
