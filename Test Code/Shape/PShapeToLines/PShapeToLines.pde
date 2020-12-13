PShape shape;
Boolean running;
float startx;
float starty;
float[][] originalVertices;
int rayState;
int resolutionReductionFactor;
int vertexRotation;
int slopeThreshold;
float translatex;
float translatey;
float rotate;

void setup() {
frameRate(60);
background(0);
stroke(255, 0, 0);
strokeWeight(5);
fill(92, 249, 126);
size(1000,1000);
// fullScreen();
this.running = false;
this.resolutionReductionFactor = 1;
this.vertexRotation = 0;
this.rayState = 0;
this.slopeThreshold = 0;
this.translatex = 0;
this.translatey = 0;
this.rotate = 0;
}

void draw() {
    background(0);
    drawGrid();
    rotate(this.rotate);
    translate(this.translatex, this.translatey);
    if (this.shape != null) {
        shape(this.shape);
    }
    if (this.running) {
        updateShape(mouseX, mouseY);
    } else {
        highlightNearestVertex();
    }
    drawRays();
}
void mousePressed() {
    if (this.shape == null) {
        test();
    } else {
        println(mouseInShape());
    }
}

void mouseWheel(MouseEvent event) {
    this.vertexRotation += event.getCount();
    reduceShapeResolutionByFactor(1);
}

void keyPressed() {
    if (this.shape != null) {
        switch(key) {
            case '1':
            this.slopeThreshold++;
                keepCurves();
                break;
            case '2':
                reduceShapeResolutionByFactor(2);
                break;
            case '3':
                reduceShapeResolutionByFactor(3);
                break;
            case '0':
                this.slopeThreshold = 0;
                reduceShapeResolutionByFactor(0);
                break;
            case 'a':
                step1();
                break;
            case 's':
                step2();
                break;
            case 'd':
                step3();
                break;
            case 'r':
                if (rayState == 1) {
                    rayState = 0;
                } else {rayState++;}
            default:
                return;
        }
    }
}

boolean mouseInShape() {
    java.awt.Polygon p = new java.awt.Polygon();
    for (int i = 0; i < this.shape.getVertexCount(); i++) {
        int x = Math.round(this.shape.getVertexX(i));
        int y = Math.round(this.shape.getVertexY(i));
        p.addPoint(x, y);
    }
    return (p.contains(Math.round(mouseX), Math.round(mouseY)));
}

void test() {
    running = true;
    noFill();
    this.startx = mouseX;
    this.starty = mouseY;
    rect(this.startx-15, this.starty-15, 30, 30);
    this.shape = createShape();
    this.shape.beginShape();
    this.shape.stroke(112, 143, 250);
    // this.shape.strokeWeight(10);

}

void updateShape(float x, float y) {
    if (!fieldComplete(x, y)) {
        this.shape.vertex(x,y);
        // point(x,y);
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
    if (cursorInStartingSquare(x, y) && this.shape.getVertexCount() > 20) {
        this.shape.fill(87, 43, 163);
        this.shape.endShape(CLOSE);
        this.running = false;
        storeShapeVertices(this.shape);
        println(this.shape.getVertexCount());
        this.resolutionReductionFactor = 1;
    }
    return false;
}

Boolean cursorInStartingSquare(float x, float y) {
    return ((x > this.startx-15 && x < this.startx + 15) &&
            (y > this.starty-15 && y < this.starty+15));
}

void storeShapeVertices(PShape shape) {
    this.originalVertices = new float[this.shape.getVertexCount()][2];
    for (int i = 0; i < this.shape.getVertexCount(); i++) {
        originalVertices[i][0] = this.shape.getVertexX(i);
        originalVertices[i][1] = this.shape.getVertexY(i);
    }
}

void keepCurves() {
     int threshold = this.slopeThreshold * 10;
     println(threshold);
     PShape currentShape = this.shape;
     PShape lowerResolutionShape = createShape();
     lowerResolutionShape.beginShape();
     lowerResolutionShape.fill(87, 43, 163);
     lowerResolutionShape.stroke(112, 143, 250);


     for (int i = 0; i < currentShape.getVertexCount(); i++) {
         int middleIndex = i + 1;
         int lastIndex = i + 2;
         if (middleIndex == currentShape.getVertexCount()) {
             middleIndex = 0;
             lastIndex = 1;
         } else if (lastIndex == currentShape.getVertexCount()) {
             lastIndex = 0;
         }
         PVector firstVert = new PVector(currentShape.getVertexX(i), currentShape.getVertexY(i));
         PVector middleVert = new PVector(currentShape.getVertexX(middleIndex), currentShape.getVertexY(middleIndex));
         PVector lastVert = new PVector(currentShape.getVertexX(lastIndex), currentShape.getVertexY(lastIndex));
         if ((middleVert.x == firstVert.x && middleVert.y == firstVert.y) ||
             (middleVert.x == lastVert.x && middleVert.y == lastVert.y)) {
             continue;
         }

         float slope = checkAngle(i);
         if (slope > threshold) {
             lowerResolutionShape.vertex(currentShape.getVertexX(middleIndex), currentShape.getVertexY(middleIndex));
         }
     }
     lowerResolutionShape.endShape(CLOSE);
     this.shape = lowerResolutionShape;
}

void reduceShapeResolutionByFactor(int factor) {
    if (factor == 0) {
        this.resolutionReductionFactor = 1;
        factor = 1;
    } else {this.resolutionReductionFactor *= factor;}
    int rotate = 0;
    if (this.vertexRotation < 0) {
        rotate += this.originalVertices.length;
    } else {
        rotate = this.vertexRotation % this.resolutionReductionFactor;
    }

    PShape lowerResolutionShape = createShape();
    lowerResolutionShape.beginShape();
    lowerResolutionShape.fill(87, 43, 163);
    lowerResolutionShape.strokeWeight(1);
    lowerResolutionShape.stroke(112, 143, 250);

    for (int i = rotate; i < this.originalVertices.length; i+=this.resolutionReductionFactor) {
        // println(i);
        if (i > this.originalVertices.length) {
            int nullPointerAdjustment = this.originalVertices.length;
            // println(i + " -> " + nullPointerAdjustment);
            i = nullPointerAdjustment;
        }
        lowerResolutionShape.vertex(getOriginalVertexX(i), getOriginalVertexY(i));
    }
    lowerResolutionShape.endShape(CLOSE);
    this.shape = lowerResolutionShape;
    println(this.shape.getVertexCount());
}

PVector highlightNearestVertex() {
    if (this.shape == null) {
        return null;
    }
    PShape currentShape = this.shape;
    float shortestDistance = width;
    PVector nearestVertex = new PVector();
    int nearestVertexIndex = 0;
    for (int i = 0; i < currentShape.getVertexCount(); i++) {
        float vertX = currentShape.getVertexX(i);
        float vertY = currentShape.getVertexY(i);
        PVector vert = new PVector(vertX, vertY);
        float distToMouse = distBetweenPoints(mouseX, mouseY, vertX, vertY);
        if (distToMouse < shortestDistance ||
                  // shortestDistance.isnull() ||
                     nearestVertex == null) {
            shortestDistance = distToMouse;
            nearestVertex = vert;
            nearestVertexIndex = i;
        }
    }
    if (shortestDistance < 100) {
        showVertexTag(nearestVertex, nearestVertexIndex);
    }
    return nearestVertex;
}

void showVertexTag(PVector vertex, int index) {
    pushMatrix();
    stroke(255, 0, 0);
    strokeWeight(20);
    point(vertex.x, vertex.y);
    translate(vertex.x+20, vertex.y+20);
    stroke(60, 193, 221);
    strokeWeight(1);
    fill(0, 200);
    rect(0,0,250, 100);
    fill(255);
    textSize(19);
    text("Index: " + index, 5, 23);
    text("(" + floor(vertex.x) + ", " + floor(vertex.y) + ")", 5, 46);
    text("Slope: " + checkAngle(index) + "º", 5, 69);
    popMatrix();
}

float getOriginalVertexX(int index) {
    return this.originalVertices[index][0];
}

float getOriginalVertexY(int index) {
    return this.originalVertices[index][1];
}

float distBetweenPoints(float x1, float y1, float x2, float y2) {
    return sqrt(pow(x2-x1, 2) + pow(y2-y1, 2));
}

float checkAngle(int index) {
    int leftIndex = index - 1;
    int rightIndex = index + 1;
    if (index == 0) {
        leftIndex = this.shape.getVertexCount()-1;
    } else if (index == this.shape.getVertexCount()-1) {
        rightIndex = 0;
    }
    PVector first = new PVector(this.shape.getVertexX(leftIndex), this.shape.getVertexY(leftIndex));
    PVector second = new PVector(this.shape.getVertexX(index), this.shape.getVertexY(index));
    PVector last = new PVector(this.shape.getVertexX(rightIndex), this.shape.getVertexY(rightIndex));

    // println("(" + first.x + ", " + first.y + ")");
    // println("(" + second.x + ", " + second.y + ")");
    // println("(" + last.x + ", " + last.y + ")");
    // println("--------------------");
    float firstSlope = (second.y - first.y) / (second.x - first.x);
    // println(firstSlope);
    float secondSlope = (last.y - second.y) / (last.x - second.x);
    // println(secondSlope);
    float slopeDifference = abs(secondSlope - firstSlope);
    // println(slopeDifference);
    // println("----------------");
    float angle = floor(degrees(atan((secondSlope-firstSlope)/(1+secondSlope*firstSlope))));
    return angle;//(index % 2 == 0) ? 180-angle : angle;
}

void checkAngle2(int index) {
    PVector first = new PVector(this.shape.getVertexX(index-1), this.shape.getVertexY(index-1));
    PVector second = new PVector(this.shape.getVertexX(index), this.shape.getVertexY(index));
    PVector last = new PVector(this.shape.getVertexX(index+1), this.shape.getVertexY(index+1));


    this.translatex = -second.x;
    this.translatey = -second.y;
    translate(-second.x, -second.y);
    this.rotate = atan2(first.y, first.x);
    frameRate(1);
    // pushMatrix();
    // translate(-second.x, -second.y);
    // float firstAngle = atan2(first.y, first.x);
    // println(degrees(firstAngle));
    // rotate(firstAngle);
    // float secondAngle = atan2(last.y, last.x);
    // println(180-degrees(secondAngle));
    // popMatrix();
    // return secondAngle;
}

void step1() {
    if (this.translatex == 0) {
        // translate(-this.shape.getVertexX(0), -this.shape.getVertexY(0));
        this.translatex = -this.shape.getVertexX(0);
        this.translatey = -this.shape.getVertexY(0);
    } else {
        this.translatex = 0;
        this.translatey = 0;
    }
}

void step2() {
    float firstX = this.shape.getVertexX(0);
    float firstY = this.shape.getVertexY(0);
    float lastX = this.shape.getVertexX(this.shape.getVertexCount() - 1);
    float lastY= this.shape.getVertexY(this.shape.getVertexCount() - 1);
    if (this.rotate == 0) {
        this.rotate = -1 * atan2(lastY - firstY, lastX - firstX);
    } else {
        this.rotate = 0;
    }
}

void step3() {
    println(atan2(this.shape.getVertexY(1),
                        this.shape.getVertexX(1)));
}

void drawRays() {
    switch(this.rayState) {
        case 0:
            return;
        case 1:
            if (get(mouseX, mouseY) == -11064413) {
                rayCast();
            }
    }
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
