import controlP5.*;

abstract class DrawnRegion {
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
    float regionWidth;
    float regionHeight;

    color strokeColor;
    color fillColor;

    DrawnRegion() {
        this.waiting = true;
        this.drawing = false;
        this.cursorHasExited = false;
        // TODO Move path funcitonality to Cutter?
        // this.cutPath = createShape();
        // this.cutPath.beginShape();
        // this.cutPath.stroke(255,50);
        // this.cutPath.strokeWeight(18);
    }

    DrawnRegion(PShape shape) {
        this.waiting = false;
        this.drawing = false;
        this.shape = shape;
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

    public void beginDrawing(float x, float y) {
        this.startx = x;
        this.starty = y;
        setupBoundaries();
        setupStartSquare();
        setupFieldShape();
        this.waiting = false;
        this.drawing = true;
    }

    void setupBoundaries() {
        this.minX = Float.POSITIVE_INFINITY;
        this.maxX = Float.NEGATIVE_INFINITY;
        this.minY = Float.POSITIVE_INFINITY;
        this.maxY = Float.NEGATIVE_INFINITY;
    }

    void setupStartSquare() {
        this.start = createShape();
        this.start.beginShape();
        this.start.stroke(255, 0, 0);
        this.start.strokeWeight(1);
        this.start.noFill();
        this.start.vertex(this.startx-15, this.starty-15);
        this.start.vertex(this.startx+15, this.starty-15);
        this.start.vertex(this.startx+15, this.starty+15);
        this.start.vertex(this.startx-15, this.starty+15);
        this.start.endShape(CLOSE);
    }

    void setupFieldShape() {
        this.shape = createShape();
        this.shape.beginShape();
        this.shape.noFill();
        this.shape.stroke(strokeColor);
        this.shape.strokeWeight(1);
    }

    void updateShape(float x, float y) {
        if (!complete(x, y)) {
            PVector lastVert = this.getLastAddedVertex();
            if (lastVert == null) {
                this.addVertex(x, y);
            } else {
                if (dist(lastVert.x, lastVert.y, x, y) > 5) {
                    this.addVertex(x, y);
                }
            }
        }
    }

    protected void addVertex(float x, float y) {
        this.shape.vertex(x, y);
        updateBoundaries(x, y);
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

    private PVector getLastAddedVertex() {
        int count = this.shape.getVertexCount();
        if (count == 0) {
            return null;
        } else {
            return new PVector(this.shape.getVertexX(count-1),
                               this.shape.getVertexY(count-1));
        }
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
        this.shape.fill(fillColor);
        this.shape.endShape(CLOSE);
    }

    void setGeometry() {
        this.center = new PVector((this.maxX + this.minX)/2,
                                  (this.maxY + this.minY)/2);
        this.regionWidth = this.maxX - this.minX;
        this.regionHeight = this.maxY - this.minY;
        this.xScale = width/this.regionWidth;
        this.yScale = height/this.regionHeight;
    }

    void storeShapeVertices(PShape shape) {
        this.originalVertices = new float[this.shape.getVertexCount()][2];
        for (int i = 0; i < this.shape.getVertexCount(); i++) {
            originalVertices[i][0] = this.shape.getVertexX(i);
            originalVertices[i][1] = this.shape.getVertexY(i);
        }
    }

    float[][] getShapeVertices() {
        this.storeShapeVertices(this.shape);
        return this.originalVertices;
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
        lowerResolutionShape.fill(fillColor);
        lowerResolutionShape.strokeWeight(1);
        lowerResolutionShape.stroke(strokeColor);

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
    }

    float getOriginalVertexX(int index) {
        return this.originalVertices[index][0];
    }

    float getOriginalVertexY(int index) {
        return this.originalVertices[index][1];
    }

    boolean pointIsInField(float x, float y) {
        java.awt.Polygon p = new java.awt.Polygon();
        p.invalidate();
        for (int i = 0; i < this.shape.getVertexCount(); i++) {
            int vertX = Math.round(this.shape.getVertexX(i));
            int vertY = Math.round(this.shape.getVertexY(i));
            p.addPoint(vertX, vertY);
        }
        return (p.contains(Math.round(x), Math.round(y)));
    }
}
