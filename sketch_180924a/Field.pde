
class Field {
    HUD hud;
    Boolean begun;
    Boolean drawing;
    Boolean complete;
    Boolean showVerticies;
    PShape shape;
    PShape start;
    PShape cutPath;
    float startx;
    float starty;
    PVector minX;
    PVector maxX;
    PVector minY;
    PVector maxY;
    int v;
    int side;
    Agent agent;
    PVector center;
    float fieldWidth;
    float fieldHeight;
    float xScale;
    float yScale;
    ArrayList<Vertex> verticies;
    Vertex lastVertex;

    // Util u = new Util();


    Field(Agent agent) {
        this.agent = agent;
        this.v = 0;
        this.begun = false;
        this.drawing = false;
        this.complete = false;
    }

    void startField(HUD hud) {
        this.verticies = new ArrayList<Vertex>();
        this.hud = hud;
        this.side = hud.sideToggle.getBooleanValue() ? 90 : -90;
        this.hud.fieldStarter.setOn();
        this.hud.currentView = ViewMode.FOLLOW;
        this.hud.viewButton.setLock(true);
        this.hud.viewButton.setLabel("Follow");
        this.startx = this.agent.getAxle().pos.x;
        this.starty = this.agent.getAxle().pos.y;
        this.minX = null;
        this.maxX = null;
        this.minY = null;
        this.maxY = null;
        stroke(255, 0, 0);
        noFill();
        PVector p = angularDisplacement(this.startx, this.starty, 18, this.agent.getHeading(), -this.side);
        this.startx = p.x;
        this.starty = p.y;
        this.start = createShape(RECT, this.startx-15,this.starty-15, 30, 30);
        this.shape = createShape();
        this.shape.beginShape();
        this.cutPath = createShape();
        this.cutPath.beginShape();
        this.shape.stroke(112, 143, 250);
        this.cutPath.stroke(255,50);
        this.cutPath.strokeWeight(18);
        this.drawing = true;
        this.complete = false;
        this.begun = true;

    }

    void render() {

        if (this.drawing) {
            float frontx = this.agent.getAxle().pos.x;
            float fronty = this.agent.getAxle().pos.y;
            // pushMatrix();
            shape(this.start);
            // scale(2);
            // translate(x, y);
            updateShape(frontx, fronty);
            // popMatrix();
        }
        if (frameCount % 10 == 0) {
            cut(this.agent.cutter.pos.x, this.agent.cutter.pos.y);
        }
        if (this.shape != null) {
            shape(this.shape);
            shape(this.cutPath);
        }
        if (this.complete) {
            this.agent.loopCheck();
            for (int i = 0; i < this.verticies.size(); i++) {
                Vertex vertex = this.verticies.get(i);
                vertex.render();
            }
        }
    }

    void cut(float x, float y) {
        this.cutPath.vertex(x, y);

        // float Lx = x + 9 * cos(this.agent.wheels.heading - this.side);
        // float Ly = y + 9 * sin(this.agent.wheels.heading - this.side);
        // float Rx= x + 9 * cos(this.agent.wheels.heading + this.side);
        // float Ry = y + 9 * sin(this.agent.wheels.heading + this.side);
        //
        // int count = this.cutPath.getVertexCount();
        // if (count < 2) {
        //     this.cutPath.vertex(Lx, Ly);
        //     this.cutPath.vertex(Rx, Ry);
        // } else {
        //     // if ((count/2) % 2 == 0) {
        //         this.cutPath.vertex(Lx, Ly);
        //         this.cutPath.vertex(Rx, Ry);
        //         for (int i = count/2+1; i < count+1; i++) {
        //             this.cutPath.setVertex(i+2, this.cutPath.getVertex(i));
        //         }
        //         this.cutPath.setVertex(count/2+1, Lx, Ly);
        //         this.cutPath.setVertex(count/2+1, Rx, Ry);
        //         PVector p = new PVector();
        //         this.cutPath.getVertex(count/2+1, p);
        //         stroke(255);
        //         strokeWeight(15);
        //         point(p.x, p.y);
            // } else {
            //     this.cutPath.vertex(Lx, Ly);
            //     this.cutPath.vertex(Rx, Ry);
            //     for (int i = count/2+1; i < count+1; i++) {
            //         setVertex(i+2, getVertex(i));
            //     }
            //     setVertex(count/2+1, Lx, Ly);
            //     setVertex(count/2+1, Rx, Ry);
            // }
        // }
    }

    void updateShape(float x, float y) {
        // FIXME: Something about where edge of field is drawn in relation to first pass
        //              Left Wheel? Draw field remaining after first pass?
        //              Right Wheel? Draw entire field, begin showing coverage during first pass?
        if (!complete(x, y)) {
            float x1 = x + 9 * cos(this.agent.wheels.heading - this.side);
            float y1 = y + 9 * sin(this.agent.wheels.heading - this.side);

            this.shape.vertex(x1, y1);
            if (this.verticies.size() == 0) {
                Vertex vertex = new Vertex(agent, angularDisplacement(this.agent.cutter.pos, 9, this.agent.cutter.angle, -this.side), this.agent.getHeading(), side);
                this.verticies.add(vertex);
            } else {//if (frameCount % 2 == 0){
                Vertex vertex = new Vertex(agent, angularDisplacement(this.agent.cutter.pos, 9, this.agent.cutter.angle, -this.side), this.agent.getHeading(), verticies.get(verticies.size()-1), side);
                this.verticies.add(vertex);
            }
            this.v++;
            // point(x,y);
        }
    }

    Boolean complete(float x, float y) {
        if (this.v < 200) {
            return false;
        }
        if (( x > this.startx-15 && x < this.startx + 15) && (y > this.starty-15 && y < this.starty + 15)) {
            this.shape.fill(87, 43, 163, 80);
            this.shape.endShape(CLOSE);
            for (int i = 0; i < this.shape.getVertexCount()-1; i++) {
                PVector vertex = this.shape.getVertex(i);
                // println(coord(vertex));
                strokeWeight(10);
                stroke(255, 0, 0);
                point(vertex.x, vertex.y);
                if (this.minX == null || this.minX.x > vertex.x) {
                    this.minX = vertex;
                }
                if (this.maxX == null || this.maxX.x < vertex.x) {
                    this.maxX = vertex;
                }
                if (this.minY == null || this.minY.y > vertex.y) {
                    this.minY = vertex;
                }
                if (this.maxY == null || this.maxY.y < vertex.y) {
                    this.maxY = vertex;
                }
            }
            this.drawing = false;
            this.complete = true;

            this.center = new PVector((field.maxX.x+field.minX.x)/2, (field.maxY.y+field.minY.y)/2);
            this.fieldWidth = this.maxX.x - this.minX.x;
            this.fieldHeight = this.maxY.y - this.minY.y;
            this.xScale = width/this.fieldWidth;
            this.yScale = height/this.fieldHeight;

            this.hud.currentView = ViewMode.CENTER;
            this.hud.viewButton.setLock(false);
            this.hud.viewButton.setLabel("Follow");
            this.hud.fieldStarter.setOff();
            this.v = 0;
            this.agent.field(this);
            this.agent.wheels.setVerts(this.verticies);
            // this.hud.controllerToggle.setValue(true);
            // this.agent.controller = new Controller(this.agent);
            return true;
        }
        return false;
    }

    void vertCheck(int loopCount) {
        // println("clear");
        for (Vertex vertex : this.verticies) {
            if (loopCount - vertex.moves > 1) {
                vertex.deprecated = true;
                vertex = null;
            }
        }
        this.agent.wheels.setVerts(this.verticies);
    }
}
