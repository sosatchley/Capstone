
// class Util() {
//
//     Util()

    String coord(float x, float y) {
        String coord = "(" + x + ":" + y + ")";
        return coord;
    }

    String coord(PVector vector) {
        float x = vector.x;
        float y = vector.y;
        String coord = "(" + x + ":" + y + ")";
        return coord;
    }

    void drawGrid(int cellSize) {
        PFont font = createFont("Georgia", 8);
        textFont(font);
        for (float y = 0; y < height; y+=cellSize) {
            for (float x = 0; x < width; x+=cellSize) {
                line(x,y, x, y+cellSize);
                line(x,y, x+cellSize, y);
                text(coord(x, y), x+1, y+1);
            }
        }
    }

    double distance(PVector p, PVector q) {
        float x1 = p.x;
        float x2 = q.x;
        float y1 = p.y;
        float y2 = q.y;
        double dist;
        dist = sqrt(pow((x2-x1), 2)-pow((y2-y1), 2));
        return dist;
    }

    PVector angularDisplacement(float x, float y, float skew, float baseAngle, float change) {
        float Lx = x + skew * cos(baseAngle - change);
        float Ly = y + skew * sin(baseAngle - change);
        return new PVector(Lx, Ly);
    }

    PVector angularDisplacement(PVector pos, float skew, float baseAngle, float change) {
        float x = pos.x;
        float y = pos.y;
        float Lx = x + skew * cos(baseAngle - change);
        float Ly = y + skew * sin(baseAngle - change);
        return new PVector(Lx, Ly);
    }
    // float Lx = x + 9 * cos(this.agent.wheels.heading - this.angle);
    // float Ly = y + 9 * sin(this.agent.wheels.heading - this.angle);
    // float Rx= x + 9 * cos(this.agent.wheels.heading + this.angle);
    // float Ry = y + 9 * sin(this.agent.wheels.heading + this.angle);
