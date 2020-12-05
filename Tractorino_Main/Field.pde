import controlP5.*;

class Field {
    Agent agent;

    PShape shape;
    PShape start;

    float[][] originalVertices;
    int resolutionReductionFactor;
    int vertexRotation;

    float startx;
    float starty;
    Boolean waiting;
    Boolean drawing;
    Boolean cursorHasExited;

    float minX;
    float maxX;
    float minY;
    float maxY;
    float xScale;
    float yScale;
    PVector center;
    float fieldWidth;
    float fieldHeight;

    Field() {
        this.waiting = true;
        this.drawing = false;
        this.cursorHasExited = false;
        // TODO Move path funcitonality to Cutter?
        // this.cutPath = createShape();
        // this.cutPath.beginShape();
        // this.cutPath.stroke(255,50);
        // this.cutPath.strokeWeight(18);
    }

    void render(){
        if (this.waiting) {
            cursor(CROSS);
        }
        if (this.drawing) {
            shape(this.start);
            updateShape(mouseX, mouseY);
        }
        if (this.shape != null) {
            shape(this.shape);
        }
    }

    void updateShape(float x, float y) {
        if (!complete(x, y)) {
            this.shape.vertex(x, y);
            updateBoundaries(x, y);
        }
    }

    void updateBoundaries(float x, float y) {
        if (this.minX > x) {
            this.minX = x;
        }
        if (this.maxX < x) {
            this.maxX = x;
        }
        if (this.minY > y) {
            this.minY = y;
        }
        if (this.maxY < y) {
            this.maxY = y;
        }
    }

    void setupBoundaries() {
        this.minX = Float.POSITIVE_INFINITY;
        this.maxX = Float.NEGATIVE_INFINITY;
        this.minY = Float.POSITIVE_INFINITY;
        this.maxY = Float.NEGATIVE_INFINITY;
    }

    Boolean complete(float x, float y) {
        if (cursorReturnedToStartingSquare(x, y)) {
            closeFieldShape();
            storeShapeVertices(this.shape);
            this.resolutionReductionFactor = 1;
            this.vertexRotation = 0;
            setGeometry();
            cursor(ARROW);
            hud.panel.fieldReady();
            return true;
        }
        return false;
    }

    void closeFieldShape() {
        this.drawing = false;
        this.shape.fill(87, 43, 163, 80);
        this.shape.endShape(CLOSE);
    }

    void setupFieldShape() {
        this.shape = createShape();
        this.shape.beginShape();
        this.shape.noFill();
        this.shape.stroke(112, 143, 250);
    }

    void setGeometry() {
        this.center = new PVector((this.maxX + this.minX)/2,
                                  (this.maxY + this.minY)/2);
        this.fieldWidth = this.maxX - this.minX;
        this.fieldHeight = this.maxY - this.minY;
        this.xScale = width/this.fieldWidth;
        this.yScale = height/this.fieldHeight;
    }

    void storeShapeVertices(PShape shape) {
        this.originalVertices = new float[this.shape.getVertexCount()][2];
        for (int i = 0; i < this.shape.getVertexCount(); i++) {
            originalVertices[i][0] = this.shape.getVertexX(i);
            originalVertices[i][1] = this.shape.getVertexY(i);
        }
    }

    void setupStartSquare() {
        this.start = createShape();
        this.start.beginShape();
        this.start.stroke(255, 0, 0);
        this.start.noFill();
        this.start.vertex(this.startx-15, this.starty-15);
        this.start.vertex(this.startx+15, this.starty-15);
        this.start.vertex(this.startx+15, this.starty+15);
        this.start.vertex(this.startx-15, this.starty+15);
        this.start.endShape(CLOSE);
    }

    Boolean cursorReturnedToStartingSquare(float x, float y) {
        if (!cursorHasExited) {
            if (cursorInStartingSquare(x, y)) {
                return false;
            } else {
                cursorHasExited = true;
                return false;
            }
        } else {
            if (cursorInStartingSquare(x, y)) {
                return true;
            } else {
                return false;
            }
        }
    }

    Boolean cursorInStartingSquare(float x, float y) {
        return ((x > this.startx - 15 && x < this.startx + 15) &&
                (y > this.starty - 15 && y < this.starty + 15));
    }

    public void beginDrawing(float x, float y) {
        this.startx = x;
        this.starty = y;
        setupBoundaries();
        setupStartSquare();
        setupFieldShape();
        this.waiting = false;
        this.drawing = true;
    }

    void reduceShapeResolutionByFactor(int factor) {
        this.resolutionReductionFactor = factor;
        int rotate = 0;
        if (this.vertexRotation < 0) {
            rotate += this.originalVertices.length;
        } else {
            rotate = this.vertexRotation % this.resolutionReductionFactor;
        }

        PShape lowerResolutionShape = createShape();
        lowerResolutionShape.beginShape();
        lowerResolutionShape.fill(87, 43, 163, 80);
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

    float getOriginalVertexX(int index) {
        return this.originalVertices[index][0];
    }

    float getOriginalVertexY(int index) {
        return this.originalVertices[index][1];
    }
}
